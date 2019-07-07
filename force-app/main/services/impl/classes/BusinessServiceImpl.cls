/****************************************************************************************
Author          : Jaap Branderhorst
Description     : Service layer for DutchBusiness webservice calls and data processing
******************************************************************************************/
public with sharing class BusinessServiceImpl implements IBusinessService {

    public static final Integer MAX_SEARCH_RESULTS = 1000;

    public List<SearchForDossiersResultDto> searchForDossiers(String country, String trade_name, String registration_number, String vat_number, String city, String street, String postcode, Integer house_number, String house_number_addition, String province, String telephone_number, String domain_name) {
        // Handle valid postcodes that the web service does not like
        if (postcode != null){ // fix for postal code
            postcode = postcode.replaceAll('(\\s+)', '').toUpperCase();
        }
        if (String.isEmpty(country)) {
            Exception ex = new CCInputException('Country must be filled when searching for dossiers');
            ErrorLogUtil.logException(ex);
            throw ex;
        }
        List<SearchForDossiersResultDto> resultValue = new List<SearchForDossiersResultDto>();
        if (country == CreditSafe.Country.NL.name()) {
            resultValue = searchForDutchDossiers(trade_name, city, street, postcode, house_number, house_number_addition, telephone_number, domain_name);
        } else {
            resultValue = searchForCreditSafeDossiers(new List<String>{country}, null, null, registration_number, null, vat_number, province, city, street, postcode, trade_name);
        }
        return resultValue;
    }

    /**
     * Searches for credit safe dossiers.
     *
     * @param country
     * @param id
     * @param status
     * @param registration_number
     * @param registration_type
     * @param vat_number
     * @param province
     * @param city
     * @param street
     * @param postal_code
     * @param name
     *
     * @return
     */
    private List<SearchForDossiersResultDto> searchForCreditSafeDossiers(List<String> countries, String id, String status, String registration_number, String registration_type, String vat_number, String province, String city, String street, String postal_code, String name) {
        List<SearchForDossiersResultDto> returnValue = new List<SearchForDossiersResultDto>();
        CreditsafeWsdl.stringArray creditSafeCountries = new CreditsafeWsdl.stringArray();
        creditSafeCountries.item = new List<String>();
        for (String country : countries) {
            creditSafeCountries.item.add(country);
        }
        CreditsafeWsdl.CreditsafeSearchResultV2 searchResult = WsCreditsafe.creditsafeSearchV2(creditSafeCountries, id, status, registration_number, registration_type, vat_number, province, city, street, postal_code, name);
        if (searchResult.companies != null && searchResult.companies.item != null) {
            for (CreditsafeWsdl.CreditsafeCompanyV2 company : searchResult.companies.item) {
                returnValue.add(new SearchForDossiersResultDto(company));
            }
        }
        return returnValue;

    }

    /**
     * Searches for dutch business dossiers in Company.info backend (Dutch Business service)
     *
     * @param trade_name
     * @param city
     * @param street
     * @param postcode
     * @param house_number
     * @param house_number_addition
     * @param telephone_number
     * @param domain_name
     *
     * @return
     */
    private List<SearchForDossiersResultDto> searchForDutchDossiers(String trade_name, String city, String street, String postcode, Integer house_number, String house_number_addition, String telephone_number, String domain_name) {
        List<DutchBusinessWsdl.DutchBusinessReferenceV2> searchResults = new List<DutchBusinessWsdl.DutchBusinessReferenceV2>();
        DutchBusinessWsdl.DutchBusinessReferenceV2PagedResult returnedResults = WsDutchBusiness.dutchBusinessSearchParametersV2(trade_name, city, street, postcode, house_number, house_number_addition, telephone_number, domain_name, false, 1);
        if (returnedResults.results != null && returnedResults.results.item != null) {
            searchResults.addAll(returnedResults.results.item);
            Integer numPages = returnedResults.paging.numpages;
            for (Integer i = 2; i <= numPages && searchResults.size() < MAX_SEARCH_RESULTS; i++) {
                returnedResults = WsDutchBusiness.dutchBusinessSearchParametersV2(trade_name, city, street, postcode, house_number, house_number_addition, telephone_number, domain_name, false, i);
                searchResults.addAll(returnedResults.results.item);
            }
        }

        List<SearchForDossiersResultDto> returnValue = new List<SearchForDossiersResultDto>();
        for (DutchBusinessWsdl.DutchBusinessReferenceV2 dutchBusinessReferenceV2 : searchResults) {
            returnValue.add(new SearchForDossiersResultDto(dutchBusinessReferenceV2));
        }
        return returnValue;
    }


    public List<Business_Dossier__c> updateDossiersWithDataVendorData(List<UpdateDossierRequestDTO> updateDossierRequestDTOS) {
        // no CRUD and FLS checks since this needs to be done in system mode. The customer has paid for the data fetched
        fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance();
        List<Business_Dossier__c> dossiers = updateDossiers(updateDossierRequestDTOS, unitOfWork);
        unitOfWork.commitWork();
        return dossiers;
    }
    
    public InsertDossiersFromDataVendorResponseDTO insertSingleDossierFromDataVendorData(String creditSafeId, String dossierNumber, String establishmentNumber, String vendor, Id accountId) {
        fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance();
        InsertDossiersFromDataVendorResponseDTO response = null;
        if (vendor == CustomerConnect.DataVendor.COMPANY_INFO.name()) {
            response = insertSingleDossierFromCompanyInfo(dossierNumber, establishmentNumber, accountId, unitOfWork);
        } else { // no checks on input but should be ok
            response = insertSingleDossierFromCreditSafe(creditSafeId, accountId, unitOfWork);

        }
        return response;
    }

    private InsertDossiersFromDataVendorResponseDTO insertSingleDossierFromCreditSafe(String creditSafeId, Id accountId,  fflib_ISObjectUnitOfWork unitOfWork) {
        InsertDossiersFromDataVendorResponseDTO response = null;
        // we don't want double dossiers so let's first check it
        List<Business_Dossier__c> existingDossiers = BusinessDossierSelector.newInstance().selectByCreditSafeId(creditSafeId, false);
        if (existingDossiers != null && existingDossiers.size() > 0) {
            response = new InsertDossiersFromDataVendorResponseDTO(existingDossiers.get(0), true);
        } else { // no duplicate, we need to create a new dossier
            try {
                CreditsafeWsdl.stringArray countries = new CreditsafeWsdl.stringArray();
                countries.item = new List<String>();
                for (CreditSafe.Country country : CreditSafe.Country.values()) {
                    countries.item.add(country.name());
                }
                CreditsafeWsdl.CreditsafeSearchResultV2 searchResult = WsCreditsafe.creditsafeSearchV2(countries, creditSafeId, null, null, null, null, null, null, null, null, null);
                CreditsafeWsdl.CreditsafeCompanyV2Array companies = searchResult.companies;
                if (companies != null && companies.item != null) {
                    CreditsafeWsdl.CreditsafeCompanyV2 dataVendorDossier = companies.item.get(0);
                    Account account = null;
                    if (accountId == null) {
                        account = insertAccount(dataVendorDossier, unitOfWork);
                    } else {
                        List<Account> accounts = AccountSelector.newInstance().selectById(new Set<Id>{accountId});
                        account = accounts.get(0);
                    }
                    Business_Dossier__c dossierDB = insertCreditSafeDossier(dataVendorDossier, account, unitOfWork);
                    response = new InsertDossiersFromDataVendorResponseDTO(dossierDB, false);
                    unitOfWork.commitWork();

                    // now update the account in a new round since only now we have the id of the dossier.
                    // Someone had the smart idea of creating a circular relationship in the database...
                    // Since the id of the account is not known before creation, registering a relationship doesn't work
                    unitOfWork = Application.UnitOfWork.newInstance();
                    unitOfWork.registerDirty(account, Schema.Account.Business_Dossier__c, dossierDB);
                    unitOfWork.commitWork();
                }
            } catch (CCDuplicateException e) { // multiple duplicate accounts have been found
                throw e;
            } catch (Exception e) {
                ErrorLogUtil.logException(e);
                throw new CCException(e);
            }
        }
        return response;

    }

    private Business_Dossier__c insertCreditSafeDossier(CreditsafeWsdl.CreditsafeCompanyV2 dataVendorDossier, Account account, fflib_ISObjectUnitOfWork unitOfWork) {
        Business_Dossier__c dossierDB = new Business_Dossier__c();
        dossierDB = mapCreditSafeDataToDossier(dataVendorDossier, dossierDB);
        unitOfWork.registerNew(dossierDB, Business_Dossier__c.Account__c, account);

        Dossier_Address__c addressDB = mapCreditSafeAddress(dataVendorDossier, new Dossier_Address__c());
        unitOfWork.registerNew(addressDB, Dossier_Address__c.Business_Data__c, dossierDB);

        return dossierDB;
    }

    private Dossier_Address__c mapCreditSafeAddress(CreditsafeWsdl.CreditsafeCompanyV2 dataVendorDossier, Dossier_Address__c addressDB) {
        if (dataVendorDossier.address != null) {
            addressDB = new Dossier_Address__c();
            addressDB.Name = dataVendorDossier.address.full_address;
            addressDB.Postcode__c = dataVendorDossier.address.postal_code;
            addressDB.Street__c = dataVendorDossier.address.street;
            addressDB.City__c = dataVendorDossier.address.city;
            addressDB.House_Number__c = dataVendorDossier.address.house_number;
            addressDB.House_Number_Addition__c = null;
            addressDB.Country__c = dataVendorDossier.address.country;
            addressDB.Type__c = 'Creditsafe';
        }
        return addressDB;
    }

    private Business_Dossier__c mapCreditSafeDataToDossier(CreditsafeWsdl.CreditsafeCompanyV2 dataVendorDossier, Business_Dossier__c dossierDB) {
        Id recordTypeId = Schema.SObjectType.Business_Dossier__c.getRecordTypeInfosByDeveloperName()
                .get('Creditsafe').getRecordTypeId();
        dossierDB.RecordTypeId = recordTypeId;
        dossierDB.Dossier_Number__c = dataVendorDossier.registration_number;
        dossierDB.Name = dataVendorDossier.name;
        if (dataVendorDossier.trade_names != null && dataVendorDossier.trade_names.item != null) {
            if (dataVendorDossier.trade_names.item.size() > 0) {
                dossierDB.Trade_Name_Full__c = dataVendorDossier.trade_names.item.get(0);
            }
            String trade_names = '';
            for (Integer i = 0; i < dataVendorDossier.trade_names.item.size(); i++) {
                trade_names += dataVendorDossier.trade_names.item[i] + (i == dataVendorDossier.trade_names.item.size()-1 ? '' : ', ');
            }
            dossierDB.Trade_Names__c = trade_names;
        }

        dossierDB.Registration_Country__c = dataVendorDossier.country;
        dossierDB.Creditsafe_Id__c = dataVendorDossier.creditsafe_number;
        dossierDB.Date_of_Last_Account__c = dataVendorDossier.date_last_account;
        dossierDB.Date_of_Last_Change__c = dataVendorDossier.date_last_change;
        dossierDB.Status__c = dataVendorDossier.status;

        if (dataVendorDossier.vat_numbers != null && dataVendorDossier.vat_numbers.item != null && dataVendorDossier.vat_numbers.item.size() > 0) {
            // TODO: handle multiple VAT numbers
            dossierDB.VAT_Number__c = dataVendorDossier.vat_numbers.item.get(0);
        }
        dossierDB.Office_Type__c = dataVendorDossier.office_type;
        dossierDB.Type__c = dataVendorDossier.type_x;

        return dossierDB;
    }



    private Account insertAccount(CreditsafeWsdl.CreditsafeCompanyV2 dataVendorDossier, fflib_ISObjectUnitOfWork unitOfWork) {
        Account account = mapDataVendorToAccount(dataVendorDossier, new Account());

        List<Account> duplicateAccounts = BusinessDuplicateService.checkForAccountDuplicates(account);
        if (duplicateAccounts.size() > 1) { // too many duplicates found. Cannot map them.
            throw new CCDuplicateException(Label.Dossier_Multiple_Account_Duplicates_Found);
        } else {
            if (duplicateAccounts.size() == 1) { // one duplicate found, let's reuse that one
                account = duplicateAccounts.get(0);
            } else { // no duplicates found, create a new account
                unitOfWork.registerNew(account);
            }
        }

        return  account;
    }

    private Account mapDataVendorToAccount(CreditsafeWsdl.CreditsafeCompanyV2 dataVendorDossier, Account account) {
        account.Name = dataVendorDossier.name;
        return account;
    }

    private InsertDossiersFromDataVendorResponseDTO insertSingleDossierFromCompanyInfo(String dossierNumber, String establishmentNumber, Id accountId, fflib_ISObjectUnitOfWork unitOfWork ) {
        InsertDossiersFromDataVendorResponseDTO response = null;
        Account account = null;

        // first find any dossiers that are already existing
        List<CheckDuplicateDossierResponse> duplicateDossierResponses = BusinessDuplicateService.checkForDuplicateDossiers(
                new List<CheckDuplicateDossierRequest>{new CheckDuplicateDossierRequest(dossierNumber, establishmentNumber)}
        );
        if (duplicateDossierResponses.get(0).dossierFound != null) { // duplicate found
            Business_Dossier__c duplicateDossier = duplicateDossierResponses.get(0).dossierFound;
            response = new InsertDossiersFromDataVendorResponseDTO(duplicateDossier, true);
        } else { // no duplicate, we need to insert the dossier
            try {
                // get the dossier from the datavendor
                DutchBusinessWsdl.DutchBusinessDossierV3 dataVendorDossier = getDossier(dossierNumber, establishmentNumber);

                // create an account if the account id is null
                if (accountId == null) {
                    List<InsertAccountResponseDTO> accountResponseDTOS = insertAccount(new List<DutchBusinessWsdl.DutchBusinessDossierV3>{dataVendorDossier}, unitOfWork);
                    account = accountResponseDTOS.get(0).account;
                } else {
                    List<Account> accounts = AccountSelector.newInstance().selectById(new Set<Id>{accountId});
                    account = accounts.get(0);
                }
                List<Business_Dossier__c> dossierDBs = insertCompanyInfoDossier(new List<InsertDossierRequestDTO>{new InsertDossierRequestDTO(dataVendorDossier, account)}, unitOfWork);

                response = new InsertDossiersFromDataVendorResponseDTO(dossierDBs.get(0), false);
                unitOfWork.commitWork();

                // now update the account in a new round since only now we have the id of the dossier.
                // Someone had the smart idea of creating a circular relationship in the database...
                // Since the id of the account is not known before creation, registering a relationship doesn't work
                unitOfWork = Application.UnitOfWork.newInstance();
                unitOfWork.registerDirty(account, Schema.Account.Business_Dossier__c, dossierDBs.get(0));
                unitOfWork.commitWork();

            } catch (CCDuplicateException e) { // multiple duplicate accounts have been found
                throw e;
            } catch (Exception e) {
                ErrorLogUtil.logException(e);
                throw new CCException(e);
            }
        }
        return response;
    }

    public static Boolean deleteDossier(Id accountId) {
        List<Account> accounts = AccountSelector.newInstance().selectById(new Set<Id>{
                accountId
        });
        List<Business_Dossier__c> dossierList = BusinessDossierSelector.newInstance().selectById(new Set<Id>{
                accounts.get(0).Business_Dossier__c
        });
        Boolean response = false;
        if (dossierList.size() == 1) {
            fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance();
            unitOfWork.registerDeleted(dossierList[0]);
            unitOfWork.commitWork();
            response = true;
        }
        return response;
    }

    public Business_Dossier__c setVatNumber(Id dossierId) {
        if (dossierId == null) {
            throw new CCException('DossierId must be filled when setting VAT number'); // shouldn't happen but let's check the input
        }

        List<Business_Dossier__c> dossiersDB = ((IBusinessDossierSelector)Application.Selector.newInstance(Business_Dossier__c.SObjectType)).selectById(new Set<Id>{dossierId});
        if (dossiersDB.isEmpty()) {
            throw new CCException('User doesn\'t have access to dossier with ID: ' + dossierId);
        }

        Business_Dossier__c dossierDB = dossiersDB.get(0);
        String vatNumber = BusinessDuplicateService.checkForExistingVatNumberInDB(dossierDB.Dossier_Number__c);

        // if no vat number in the db, get it from the data vendor
        if (String.isEmpty(vatNumber)) { // no VAT number for any other dossier in the database
            DutchBusinessWsdl.DutchBusinessVatNumber vatResponse = WsDutchBusiness.dutchBusinessGetVatNumber(dossierDB.Dossier_Number__c);
            vatNumber = vatResponse.vat_number;
        }

        // update the dossier with the vatnumber
        dossierDB.VAT_Number__c = vatNumber;
        // without CRUD/FLS check since the user has paid for the data and has access to the original record
        fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance();
        unitOfWork.registerDirty(dossierDB);
        unitOfWork.commitWork();
        return dossierDB;
    }

    /**************
     * Implementation methods
     **************/

    @TestVisible
    private List<InsertAccountResponseDTO> insertAccount(List<DutchBusinessWsdl.DutchBusinessDossierV3> dataVendorDossiers, fflib_ISObjectUnitOfWork unitOfWork) {
        List<InsertAccountResponseDTO> responses = new List<InsertAccountResponseDTO>();
        for (DutchBusinessWsdl.DutchBusinessDossierV3 dataVendorDossier : dataVendorDossiers) {
            Account account = mapDataVendorToAccount(dataVendorDossier, new Account());
            // TODO: make this bulkified and move it outside of the loop
            List<Account> duplicateAccounts = BusinessDuplicateService.checkForAccountDuplicates(account);
            if (duplicateAccounts.size() > 1) { // too many duplicates found. Cannot map them.
                throw new CCDuplicateException(Label.Dossier_Multiple_Account_Duplicates_Found);
            } else
            if (duplicateAccounts.size() == 1) { // one duplicate found, let's reuse that one
                account = duplicateAccounts.get(0);
            } else { // no duplicates found, create a new account
                unitOfWork.registerNew(account);
            }
            InsertAccountResponseDTO response = new InsertAccountResponseDTO(dataVendorDossier, account);
            responses.add(response);
        }
        return responses;
    }

    private Account mapDataVendorToAccount(DutchBusinessWsdl.DutchBusinessDossierV3 dataVendorDossier, Account account) {
        account.Name = dataVendorDossier.trade_name_full;
        return account;
    }

    private List<Business_Dossier__c> insertCompanyInfoDossier(List<InsertDossierRequestDTO> InsertDossierRequestDTOS, fflib_ISObjectUnitOfWork unitOfWork) {
        List<Business_Dossier__c> returnList = new List<Business_Dossier__c>();
        for (InsertDossierRequestDTO insertDossierRequestDTO : InsertDossierRequestDTOS) {
            Business_Dossier__c dossier = mapDataVendorDataToDossier(insertDossierRequestDTO.dossier, new Business_Dossier__c());
            unitOfWork.registerNew(dossier, Business_Dossier__c.Account__c, insertDossierRequestDTO.account);

            // unitOfWork.registerRelationship(insertDossierRequestDTO.account, Account.Business_Dossier__c, dossier);
            
            Dossier_Address__c establishmentAddress = mapDataVendorDataToEstablishmentAddress(insertDossierRequestDTO.dossier, new Dossier_Address__c());
            unitOfWork.registerNew(establishmentAddress, Dossier_Address__c.Business_Data__c, dossier);

            Dossier_Address__c correspondenceAddress = mapDataVendorDataToCorrespondenceAddress(insertDossierRequestDTO.dossier, new Dossier_Address__c());
            unitOfWork.registerNew(correspondenceAddress, Dossier_Address__c.Business_Data__c, dossier);
            
            List<Business_Data_SBI__c> sbiCodes = mapDataVendorDataToSBICodes(insertDossierRequestDTO.dossier, new List<Business_Data_SBI__c>());
            for (Business_Data_SBI__c businessDataSBI : sbiCodes) {
                unitOfWork.registerNew(businessDataSBI, Business_Data_SBI__c.Business_Dossier__c, dossier);
            }
            returnList.add(dossier);
        }
        return returnList;
    }

    private List<Business_Dossier__c> updateDossiers(List<UpdateDossierRequestDTO> updateDossierRequestDTOS, fflib_ISObjectUnitOfWork unitOfWork) {
        List<Business_Dossier__c> returnList = new List<Business_Dossier__c>();
        for (UpdateDossierRequestDTO updateDossierRequestDTO : updateDossierRequestDTOS) {
            Business_Dossier__c dossier = mapDataVendorDataToDossier(updateDossierRequestDTO.dataVendorDossier, updateDossierRequestDTO.dossierDB);
            unitOfWork.registerDirty(dossier);

            // *** handle addresses ***
            // delete the addresses
            List<Dossier_Address__c> currentAddresses = DossierAddressSelector.newInstance().selectByDossierId(new Set<Id>{dossier.Id});
            unitOfWork.registerDeleted(currentAddresses);
            // create new addresses
            Dossier_Address__c establishmentAddress = mapDataVendorDataToEstablishmentAddress(updateDossierRequestDTO.dataVendorDossier, new Dossier_Address__c());
            unitOfWork.registerNew(establishmentAddress, Dossier_Address__c.Business_Data__c, dossier);
            Dossier_Address__c correspondenceAddress = mapDataVendorDataToCorrespondenceAddress(updateDossierRequestDTO.dataVendorDossier, new Dossier_Address__c());
            unitOfWork.registerNew(correspondenceAddress, Dossier_Address__c.Business_Data__c, dossier);

            // *** handle SBI codes ***
            // delete the SBI codes
            List<Business_Data_SBI__c> currentSBICodes = SbiCodeSelector.newInstance().selectByDossierId(new Set<Id>{dossier.Id});
            unitOfWork.registerDeleted(currentSBICodes);
            // create new SBI codes
            List<Business_Data_SBI__c> sbiCodes = mapDataVendorDataToSBICodes(updateDossierRequestDTO.dataVendorDossier, new List<Business_Data_SBI__c>());
            for (Business_Data_SBI__c businessDataSBI : sbiCodes) {
                unitOfWork.registerNew(businessDataSBI, Business_Data_SBI__c.Business_Dossier__c, dossier);
            }

            returnList.add(dossier);
        }
        return returnList;

    }

    private Business_Dossier__c mapDataVendorDataToDossier(DutchBusinessWsdl.DutchBusinessDossierV3 dataVendorDossier, Business_Dossier__c dossierDB) {
        Id recordTypeId = Schema.SObjectType.Business_Dossier__c.getRecordTypeInfosByDeveloperName()
                .get('Dutch_Business').getRecordTypeId();
        dossierDB.RecordTypeId = recordTypeId;
        dossierDB.Registration_Country__c = 'NL';
        String trade_names = '';
        // TODO: move this to a list of tradelist (seperate sObject)
        if (dataVendorDossier.trade_names != null && dataVendorDossier.trade_names.item != null && dataVendorDossier.trade_names.item.size() > 0) {
            // Condense all trade names into single field, seperated by new lines.
            for (Integer i = 0; i < dataVendorDossier.trade_names.item.size(); i++) {
                trade_names += dataVendorDossier.trade_names.item[i] + (i == dataVendorDossier.trade_names.item.size()-1 ? '' : ', ');
            }
            dossierDB.Trade_Names__c = trade_names;
        }
        if(dataVendorDossier.legal_name != null && dataVendorDossier.legal_name != ''){
            dossierDB.Name = dataVendorDossier.legal_name;
        }else{
            dossierDB.Name = dataVendorDossier.trade_name_full;
        }
        dossierDB.Registration_Country__c = 'NL';
        dossierDB.Dossier_Number__c = dataVendorDossier.dossier_number;
        dossierDB.Establishment_Number__c = dataVendorDossier.establishment_number;
        dossierDB.Main_Establishment_Number__c = dataVendorDossier.main_establishment_number;
        dossierDB.Indication_Main_Establishment__c = dataVendorDossier.indication_main_establishment;
        dossierDB.Rsin_Number__c = String.valueOf(dataVendorDossier.rsin_number);
        dossierDB.Chamber_Number__c = convertToInteger(dataVendorDossier.chamber_number);
        dossierDB.Legal_Form_Code__c = convertToInteger(dataVendorDossier.legal_form_code);
        dossierDB.Legal_Form_Text__c = dataVendorDossier.legal_form_text;
        dossierDB.Indication_Organisation_Code__c = dataVendorDossier.indication_organisation_code;
        dossierDB.Trade_Name_45__c = dataVendorDossier.trade_name_45;
        dossierDB.Trade_Name_Full__c = dataVendorDossier.trade_name_full;
        dossierDB.Trade_Names__c = trade_names;
        dossierDB.Telephone_Number__c = dataVendorDossier.telephone_number;
        dossierDB.Mobile_Number__c = dataVendorDossier.mobile_number;
        dossierDB.Domain_Name__c = dataVendorDossier.domain_name;

        dossierDB.Authorized_Share_Capital__c = dataVendorDossier.authorized_share_capital;
        dossierDB.Authorized_Share_Capital_Currency__c = dataVendorDossier.authorized_share_capital_currency;
        dossierDB.Class_Personnel__c = convertToString(dataVendorDossier.class_personnel);
        dossierDB.Class_Personnel_Fulltime__c = convertToString(dataVendorDossier.class_personnel_fulltime);
        dossierDB.Continuation_Date__c = convertToDate(dataVendorDossier.continuation_date);
        dossierDB.Discontinuation_Date__c = convertToDate(dataVendorDossier.discontinuation_date);
        dossierDB.Establishment_Date__c = convertToDate(dataVendorDossier.establishment_date);
        dossierDB.Founding_Date__c = convertToDate(dataVendorDossier.founding_date);
        dossierDB.Issued_Share_Capital__c = convertToInteger(dataVendorDossier.issued_share_capital);
        dossierDB.Issued_Share_Capital_Currency__c = dataVendorDossier.issued_share_capital_currency;
        dossierDB.Paid_Up_Share_Capital__c = convertToInteger(dataVendorDossier.paid_up_share_capital);
        dossierDB.Paid_Up_Share_Capital_Currency__c = dataVendorDossier.paid_up_share_capital_currency;
        dossierDB.Personnel__c = dataVendorDossier.personnel;
        dossierDB.Personnel_Fulltime__c = dataVendorDossier.personnel_fulltime;
        dossierDB.Personnel_Reference_Date__c = convertToDate(dataVendorDossier.personnel_reference_date);
        dossierDB.Primary_Sbi_Code__c = dataVendorDossier.primary_sbi_code;
        dossierDB.Primary_Sbi_Code_Text__c = dataVendorDossier.primary_sbi_code_text;
        dossierDB.Secondary_Sbi_Code_1__c = dataVendorDossier.secondary_sbi_code1;
        dossierDB.Secondary_Sbi_Code_1_Text__c = dataVendorDossier.secondary_sbi_code1_text;
        dossierDB.Secondary_Sbi_Code_2__c = dataVendorDossier.secondary_sbi_code2;
        dossierDB.Secondary_Sbi_Code_2_Text__c = dataVendorDossier.secondary_sbi_code2_text;

        dossierDB.Chamber_Code__c = dataVendorDossier.chamber_number;
        dossierDB.Status__c = determineStatus(dataVendorDossier);

        // dossierDB.Annual_Financial_Statement_Summary__c = dataVendorDossier.annual_financial_statement_summary.;
        if (dataVendorDossier.annual_financial_statement_summary != null) {
            dossierDB.Year__c = String.valueOf(dataVendorDossier.annual_financial_statement_summary.year);
            if (dataVendorDossier.annual_financial_statement_summary.profit != null) { dossierDB.Profit__c = dataVendorDossier.annual_financial_statement_summary.profit.formatted;}
            if (dataVendorDossier.annual_financial_statement_summary.turnover != null) { dossierDB.Turnover__c = dataVendorDossier.annual_financial_statement_summary.turnover.formatted; }
            if (dataVendorDossier.annual_financial_statement_summary.assets != null) { dossierDB.Assets__c = dataVendorDossier.annual_financial_statement_summary.assets.formatted; }
        }

        dossierDB.Personnel_CI__c = dataVendorDossier.personnel_ci;
        dossierDB.Class_Personnel_CI__c = convertToString(dataVendorDossier.class_personnel_ci);
        dossierDB.Personnel_CI_Reference_Date__c = convertToDate(dataVendorDossier.personnel_ci_reference_date);
        dossierDB.Contact_Initials__c = dataVendorDossier.contact_initials;
        dossierDB.Contact_Prefix__c = dataVendorDossier.contact_prefix;
        dossierDB.Contact_Surname__c = dataVendorDossier.contact_surname;
        dossierDB.Contact_Title1__c = dataVendorDossier.contact_title1;
        dossierDB.Contact_Title2__c = dataVendorDossier.contact_title2;
        dossierDB.Contact_Gender__c = dataVendorDossier.contact_gender;
        if (dataVendorDossier.indication_bankruptcy != null) { dossierDB.Indication_Bankruptcy__c = dataVendorDossier.indication_bankruptcy;}
        if (dataVendorDossier.indication_dip != null) { dossierDB.Indication_Dip__c = dataVendorDossier.indication_dip;}
        if (dataVendorDossier.indication_economically_active != null) { dossierDB.Indication_Economically_Active__c = dataVendorDossier.indication_economically_active;}
        if (dataVendorDossier.indication_export != null) { dossierDB.Indication_Export__c = dataVendorDossier.indication_export;}
        if (dataVendorDossier.indication_import != null) { dossierDB.Indication_Import__c = dataVendorDossier.indication_import;}
        if (dataVendorDossier.indication_main_establishment != null) { dossierDB.Indication_Main_Establishment__c = dataVendorDossier.indication_main_establishment;}
        if (dataVendorDossier.indication_non_mailing != null) { dossierDB.Indication_Non_Mailing__c = dataVendorDossier.indication_non_mailing;}

        if (dataVendorDossier.structure != null) {
            dossierDB.Number_Of_Subsidiaries__c = String.valueOf(dataVendorDossier.structure.number_of_subsidiaries);
            dossierDB.Parent_Chamber_Of_Commerce_Number__c = dataVendorDossier.structure.parent;
            dossierDB.Ultimate_Parent_Chamber_Of_Commerce_Nr__c = dataVendorDossier.structure.ultimate_parent;
        }
        return dossierDB;
    }

    private Dossier_Address__c mapDataVendorDataToEstablishmentAddress(DutchBusinessWsdl.DutchBusinessDossierV3 dataVendorDossier, Dossier_Address__c addressDB) {
        if (dataVendorDossier.establishment_address != null && dataVendorDossier.establishment_address.original != null) {
            addressDB.Name = dataVendorDossier.establishment_address.original.postcode + ' ' + dataVendorDossier.establishment_address.original.street; //dataVendorDossier.establishment_address.original.address;
            addressDB.Postcode__c = dataVendorDossier.establishment_address.original.postcode;
            addressDB.Street__c = dataVendorDossier.establishment_address.original.street;
            addressDB.City__c = dataVendorDossier.establishment_address.original.city;
            addressDB.House_Number__c = String.valueOf(dataVendorDossier.establishment_address.original.house_number);
            addressDB.House_Number_Addition__c = dataVendorDossier.establishment_address.original.house_number_addition;
            addressDB.Country__c = dataVendorDossier.establishment_address.original.country;
            addressDB.Type__c = 'Establishment';
        }
        return addressDB;
    }

    private Dossier_Address__c mapDataVendorDataToCorrespondenceAddress(DutchBusinessWsdl.DutchBusinessDossierV3 dataVendorDossier, Dossier_Address__c addressDB) {
        if (dataVendorDossier.correspondence_address != null && dataVendorDossier.correspondence_address.original != null) {
            addressDB.Name = dataVendorDossier.correspondence_address.original.postcode + ' ' + dataVendorDossier.correspondence_address.original.street; //dataVendorDossiercorrespondence_address_original_address;
            addressDB.Postcode__c = dataVendorDossier.correspondence_address.original.postcode;
            addressDB.Street__c = dataVendorDossier.correspondence_address.original.street;
            addressDB.City__c = dataVendorDossier.correspondence_address.original.city;
            addressDB.House_Number__c = String.valueOf(dataVendorDossier.correspondence_address.original.house_number);
            addressDB.House_Number_Addition__c = dataVendorDossier.correspondence_address.original.house_number_addition;
            addressDB.Country__c = dataVendorDossier.correspondence_address.original.country;
            addressDB.Type__c = 'Correspondence';
        }
        return addressDB;
    }

    private List<Business_Data_SBI__c> mapDataVendorDataToSBICodes(DutchBusinessWsdl.DutchBusinessDossierV3 dataVendorDossier, List<Business_Data_SBI__c> sbiCodesDB) {
        if (sbiCodesDB == null) {
            sbiCodesDB = new List<Business_Data_SBI__c>();
        }
        Map<String, Business_Data_SBI__c> sbiCodeRecordsOriginaBySbiCode = new Map<String, Business_Data_SBI__c>();
        Map<String, Business_Data_SBI__c> sbiCodeRecordsCompanyInfoBySbiCode = new Map<String, Business_Data_SBI__c>();
        for (Business_Data_SBI__c businessDataSBI : sbiCodesDB) {
            if (businessDataSBI.SBI_Type__c == 'original') {
                sbiCodeRecordsOriginaBySbiCode.put(businessDataSBI.SBI_Code__c, businessDataSBI);
            } else {
                sbiCodeRecordsCompanyInfoBySbiCode.put(businessDataSBI.SBI_Code__c, businessDataSBI);
            }
        }
        if (dataVendorDossier.sbi_collection != null) {
            if (dataVendorDossier.sbi_collection.original != null) {
                if (dataVendorDossier.sbi_collection.original.item != null) {
                    for (DutchBusinessWsdl.DutchBusinessSBICode sbiCodeOriginal : dataVendorDossier.sbi_collection.original.item) {
                        if (sbiCodeRecordsOriginaBySbiCode.get(sbiCodeOriginal.sbi_code) == null) {
                            sbiCodesDB.add(new Business_Data_SBI__c(SBI_Code__c = sbiCodeOriginal.sbi_code, SBI_Type__c = 'original', SBI_Description__c = sbiCodeOriginal.description));
                        }
                    }
                }
            }
            if (dataVendorDossier.sbi_collection.company_info != null) {
                if (dataVendorDossier.sbi_collection.company_info.item != null) {
                    for (DutchBusinessWsdl.DutchBusinessSBICode sbiCodeCompanyInfo : dataVendorDossier.sbi_collection.company_info.item) {
                        if (sbiCodeRecordsCompanyInfoBySbiCode.get(sbiCodeCompanyInfo.sbi_code) == null) {
                            sbiCodesDB.add(new Business_Data_SBI__c(SBI_Code__c = sbiCodeCompanyInfo.sbi_code, SBI_Type__c = 'original', SBI_Description__c = sbiCodeCompanyInfo.description));
                        }
                    }
                }
            }
        }
        return sbiCodesDB;
    }



    private static Date convertToDate(DutchBusinessWsdl.DutchBusinessDateV3 theDate) {
        Date returnDate = null;
        if (theDate == null) {
            return null;
        }
        if (theDate != null && theDate.year != null && theDate.month != null && theDate.day != null && theDate.year >= 1700) {
            returnDate= Date.newInstance(theDate.year, theDate.month, theDate.day);
        }
        return returnDate;
    }

    // method to skip doing if for every value
    @TestVisible
    private static Integer convertToInteger(String value){
        try{
            return Integer.valueOf(value);
        }catch(Exception e){
            return null;
        }
    }
    // method to skip doing if for every value
    private static Integer convertToInteger(Long value){
        try{
            return Integer.valueOf(value);
        }catch(Exception e){
            return null;
        }
    }
    // method to skip doing if for every value
    private static String convertToString(Integer value){
        return value != null ? String.valueOf(value) : null;
    }


    @TestVisible
    private DutchBusinessWsdl.DutchBusinessDossierV3 getDossier(String dossierNumber, String establishmentNumber) {
        if (dossierNumber == null){ return null;}
        return WsDutchBusiness.dutchBusinessGetDossierV3(dossierNumber, establishmentNumber);
    }

    private static String determineStatus(DutchBusinessWsdl.DutchBusinessDossierV3 dossier) {
        List<String> status = new List<String>();
        if (dossier.indication_import != null && Boolean.valueOf(dossier.indication_import) == true) status.add('Import');
        if (dossier.indication_export != null && Boolean.valueOf(dossier.indication_export) == true) status.add('Export');
        if (dossier.indication_economically_active != null && Boolean.valueOf(dossier.indication_economically_active) == true) status.add('Economically Active');
        if (dossier.indication_non_mailing != null && Boolean.valueOf(dossier.indication_non_mailing) == true) status.add('Non Mailing');
        if (dossier.indication_bankruptcy != null && Boolean.valueOf(dossier.indication_bankruptcy) == true) status.add('Bankruptcy');
        if (dossier.indication_dip != null && Boolean.valueOf(dossier.indication_dip) == true) status.add('DIP');
        return String.join(status, ';');
    }

}