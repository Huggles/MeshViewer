/****************************************************************************************
Author          : Jaap Branderhorst
Description     : Service layer for DutchBusiness webservice calls and data processing
******************************************************************************************/

public inherited sharing class BusinessServiceImpl implements IBusinessService {

    public static final Integer MAX_SEARCH_RESULTS = 1000;

    /**
     * Searches for dossiers with the given params
     *
     * @param country the country in ISO notation. Currently supports NL, GB, IE, DE, FR, SE, BE
     * @param trade_name the name of the company we are searching for
     * @param registration_number the number under which the company has been registered. Chamber of commerce number in the Netherlands
     * @param vat_number the vat number we search for
     * @param city
     * @param street
     * @param postcode
     * @param house_number
     * @param house_number_addition
     * @param province
     * @param telephone_number
     * @param domain_name
     *
     * @return
     */
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
            resultValue = DutchBusinessService.searchForDutchDossiers(trade_name, city, street, postcode, house_number, house_number_addition, telephone_number, domain_name);
        } else {
            // TODO: refactor so it uses the credit safe services
            resultValue = searchForCreditSafeDossiers(new List<String>{country}, null, null, registration_number, null, vat_number, province, city, street, postcode, trade_name);
        }
        return resultValue;
    }







    /**
     * Inserts a single dossier + account into the DB found through the search function (so based on the dossier number and establishment number).
     * If the dossier is already there, just returns the dossier with a flag it already existed. If the account already exists, just reuses it.
     * If more than one duplicate account exist, throws a CCDuplicateException. This method is synchronous so only one dossier
     * can be created since the datavendor only allows one fetch per call
     *
     * @param creditSafeId The unique id of the record in credit safe
     * @param dossierNumber The Chamber of Commerce number in the Netherlands. Used for Company INfo
     * @param establishmentNumber The establishment number used for Company.info. Unique combined with dossier number
     * @param accountId The id of the account this should be related to
     *
     * @return
     */
    public InsertDossiersFromDataVendorResponseDTO insertSingleDossierFromDataVendorData(String creditSafeId, String dossierNumber, String establishmentNumber, String vendor, Id accountId) {
        fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance();
        InsertDossiersFromDataVendorResponseDTO response = null;
        if (vendor == CustomerConnect.DataVendor.COMPANY_INFO.name()) {
            response = DutchBusinessService.insertSingleDossierFromCompanyInfo(dossierNumber, establishmentNumber, accountId, unitOfWork);
        } else { // no checks on input but should be ok
            response = insertSingleDossierFromCreditSafe(creditSafeId, accountId, unitOfWork);

        }
        return response;
    }



    /**************************************************************************
     * IMPLEMENTATION METHODS (PRIVATE, NOT IMPLEMENTING THE INTERFACE) BELOW *
     **************************************************************************/

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
        creditSafeCountries.item.addAll(countries);

        CreditsafeWsdl.CreditsafeSearchResultV2 searchResult = WsCreditsafe.creditsafeSearchV2(creditSafeCountries, id, status, registration_number, registration_type, vat_number, province, city, street, postal_code, name);
        if (searchResult != null && searchResult.companies != null && searchResult.companies.item != null) {
            for (CreditsafeWsdl.CreditsafeCompanyV2 company : searchResult.companies.item) {
                returnValue.add(new SearchForDossiersResultDto(company));
            }
        }
        return returnValue;

    }

    /**
     * Inserts a single creditsafe search result as a business dossier.
     *
     * @param creditSafeId
     * @param accountId
     * @param unitOfWork
     *
     * @return
     */
    private InsertDossiersFromDataVendorResponseDTO insertSingleDossierFromCreditSafe(String creditSafeId, Id accountId,  fflib_ISObjectUnitOfWork unitOfWork) {
        InsertDossiersFromDataVendorResponseDTO response = null;
        // we don't want double dossiers so let's first check it
        List<Business_Dossier__c> existingDossiers = BusinessDossierSelector.newInstance().selectByCreditSafeId(creditSafeId, false);
        if (existingDossiers != null && existingDossiers.size() > 0) {
            response = new InsertDossiersFromDataVendorResponseDTO(existingDossiers.get(0), true);
        } else { // no duplicate, we need to create a new dossier
            try {
                CreditsafeWsdl.CreditsafeSearchResultV2 searchResult = WsCreditsafe.creditsafeSearchV2(null, creditSafeId, null, null, null, null, null, null, null, null, null);
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
        if (dataVendorDossier != null && dataVendorDossier.address != null) {
            Dossier_Address__c addressDB = mapCreditSafeAddress(dataVendorDossier, new Dossier_Address__c());
            unitOfWork.registerNew(addressDB, Dossier_Address__c.Business_Data__c, dossierDB);
        }

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
            //addressDB.Type__c = 'Creditsafe';
        }
        return addressDB;
    }

    private Business_Dossier__c mapCreditSafeDataToDossier(CreditsafeWsdl.CreditsafeCompanyV2 dataVendorDossier, Business_Dossier__c dossierDB) {
        Id recordTypeId = Schema.SObjectType.Business_Dossier__c.getRecordTypeInfosByDeveloperName().get('Creditsafe').getRecordTypeId();
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
        dossierDB.Company_Id__c = dataVendorDossier.id;

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

    // TODO: find out why this is public static
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

            //if dossier is deleted, then remove it from the update list of dossiers on the company.info server
            WsDutchBusiness.dutchBusinessUpdateRemoveDossier(dossierList[0].Dossier_Number__c, dossierList[0].Establishment_Number__c);
        }

        return response;
    }

    /**************
     * Implementation methods
     **************/



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

    private static CreditsafeWsdl.stringArray countries {
        get {
            if (countries == null) {
                countries = new CreditsafeWsdl.stringArray();
                countries.item = new List<String>();
                for (CreditSafe.Country country : CreditSafe.Country.values()) {
                    countries.item.add(country.name());
                }
            }
            return countries;
        }
        set;
    }

    private static CreditsafeWsdl.stringArray creditSafeCountries {
        get {
            if (creditSafeCountries == null) {
                creditSafeCountries = new CreditsafeWsdl.stringArray();
            }
            return creditSafeCountries;
        }
        set;
    }
}
