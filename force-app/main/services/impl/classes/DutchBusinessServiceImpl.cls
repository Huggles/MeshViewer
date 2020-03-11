/**
 * Created by jaapbranderhorst on 19/02/2020.
 */

public inherited sharing class DutchBusinessServiceImpl implements IDutchBusinessService {

    private inherited sharing class UpsertBusinessDossierWorker extends AbstractUpsertUnitOfWork {

        public UpsertBusinessDossierWorker() {
            m_records = new List<Business_Dossier__c>();
        }
    }

    public static final Integer MAX_SEARCH_RESULTS = 1000;

    /**
    * Searches for dutch business dossiers in Company.info backend (Dutch Business service)
    *
    * @param dossier_number
    * @param trade_name
    * @param city
    * @param street
    * @param postcode
    * @param house_number
    * @param house_number_addition
    * @param telephone_number
    * @param domain_name
    * @param strict_search
    *
    * @return
    */
    public List<Business_Dossier__c> searchForDutchDossiersSObject(String dossier_number, String trade_name, String city, String street, String postcode, Integer house_number, String house_number_addition, String telephone_number, String domain_name, Boolean strict_search) {
        // sanitize the input
        if (!String.isEmpty(postcode)) {
            if (postcode.startsWith('NL-')) {
                postcode = postcode.substring(3);
            }
            postcode = postcode.deleteWhitespace();
        }
        List<DutchBusinessWsdl.DutchBusinessEstablishmentReference> searchResults = searchForDutchBusinessesInCompanyInfo(dossier_number, trade_name, city, street, postcode, house_number, house_number_addition, telephone_number, domain_name, strict_search);

        List<Business_Dossier__c> returnValue = new List<Business_Dossier__c>();
        for (DutchBusinessWsdl.DutchBusinessEstablishmentReference dutchBusinessEstablishmentReference : searchResults) {
            returnValue.add(mapDutchBusinessEstablishmentReferenceToBusinessDossier(dutchBusinessEstablishmentReference));
        }
        return returnValue;
    }


    /**
    * Processes the dutch business dossiers that have been removed from the CI backend
    *
    * @param removedDossiers
    */
    public void processRemovedDutchDossiers(List<Business_Dossier__c> removedDossiers) {
        fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance();
        if (removedDossiers != null) {
            for (Business_Dossier__c businessDossier : removedDossiers) {
                businessDossier.Is_Removed__c = true;
            }
            unitOfWork.registerDirty(removedDossiers);
            unitOfWork.commitWork();
        }
    }

    /**
     * Stores the given dossiers in the database. If no id is present inserts the dossiers, otherwise updates them.
     *
     * @param dossiers the dossiers to be stored
     * @param unitOfWork if null a new uow will be created and used to do the work
     */
    public static void storeDossiers(List<Business_Dossier__c> dossiers, fflib_ISObjectUnitOfWork originalInitOfWork) {
        fflib_ISObjectUnitOfWork unitOfWork = null;
        if (originalInitOfWork == null) {
            unitOfWork = Application.UnitOfWork.newInstance();
        } else {
            unitOfWork = originalInitOfWork;
        }
        UpsertBusinessDossierWorker upsertUnitOfWork = new UpsertBusinessDossierWorker();
        upsertUnitOfWork.registerUpsert(dossiers);
        unitOfWork.registerWork(upsertUnitOfWork);
        if (originalInitOfWork == null) {
            unitOfWork.commitWork();
        }
    }

    /**
     * Updates every dossier given with the newest data from the CI backend.
     *
     * @param dossiersToUpdate the dossiers to update
     */
    public void updateDossiersWithVendorData(List<Business_Dossier__c> dossiersToUpdate) {
        // we are going to do callouts here so let's check if we have any room to do that
        Integer calloutsLeft = Limits.getLimitCallouts() - Limits.getCallouts();
        if (dossiersToUpdate.size() > calloutsLeft) {
            CCInputException e = new CCInputException('Too many dossiers in updateDossiersWithVendorData call. Number of dossiers: ' + dossiersToUpdate.size() + '. Number of callouts left: ' + calloutsLeft);
            ErrorLogUtil.logException(e);
            throw e;
        }
        fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance();

        // delete the old SBI codes and the old addresses
        Map<Id, Business_Dossier__c> dossiersByIds = new Map<Id, Business_Dossier__c>(dossiersToUpdate);
        List<Business_Data_SBI__c> oldSbiCodes = ((ISbiCodeSelector)Application.Selector.newInstance(Business_Data_SBI__c.SObjectType)).selectByDossierId(dossiersByIds.keySet());
        unitOfWork.registerDeleted(oldSbiCodes);
        List<Dossier_Address__c> oldAddresses = ((IDossierAddressSelector)Application.Selector.newInstance(Dossier_Address__c.SObjectType)).selectByDossierId(dossiersByIds.keySet());
        unitOfWork.registerDeleted(oldAddresses);

        // update the records or create new ones
        for (Business_Dossier__c businessDossier : dossiersToUpdate) {
            String dossierNumber = businessDossier.Dossier_Number__c;
            String establishmentNumber = businessDossier.Establishment_Number__c;
            DutchBusinessWsdl.DutchBusinessDossierV3 dutchBusinessDossierV3 = WsDutchBusiness.dutchBusinessGetDossierV3(dossierNumber, establishmentNumber);

            Business_Dossier__c dossier = mapDutchBusinessDossierV3ToDossier(dutchBusinessDossierV3, businessDossier);
            unitOfWork.registerDirty(dossier);

            Dossier_Address__c establishmentAddress = mapDataVendorDataToEstablishmentAddress(dutchBusinessDossierV3, new Dossier_Address__c());
            unitOfWork.registerNew(establishmentAddress, Dossier_Address__c.Business_Data__c, dossier);

            Dossier_Address__c correspondenceAddress = mapDataVendorDataToCorrespondenceAddress(dutchBusinessDossierV3, new Dossier_Address__c());
            unitOfWork.registerNew(correspondenceAddress, Dossier_Address__c.Business_Data__c, dossier);

            List<Business_Data_SBI__c> sbiCodes = mapDataVendorDataToSBICodes(dutchBusinessDossierV3, new List<Business_Data_SBI__c>());
            for (Business_Data_SBI__c businessDataSBI : sbiCodes) {
                unitOfWork.registerNew(businessDataSBI, Business_Data_SBI__c.Business_Dossier__c, dossier);
            }
        }
        unitOfWork.commitWork();
    }

    /**
     * Fetches the dutch business dossier with the given dossier number and establishment number and creates it in the database (incl. any related records)
     * If getVAT is true, also enriches the dossier with the VAT number (if available) before inserting it in the database.
     *
     * @param dossierNumber
     * @param establishmentNumber
     * @param getVAT
     *
     * @return
     */
    public Business_Dossier__c createDutchDossier(String dossierNumber, String establishmentNumber, Boolean getVAT) {
        if (dossierNumber == null || dossierNumber == '') {
            Exception ex = new CCInputException('empty dossier number');
            ErrorLogUtil.logException(ex);
            throw ex;
        }
        // fetch the data
        DutchBusinessWsdl.DutchBusinessDossierV3 dossierV3 = WsDutchBusiness.dutchBusinessGetDossierV3(dossierNumber, establishmentNumber);
        // insert the dossier
        fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance();
        Business_Dossier__c dossier = new Business_Dossier__c();
        dossier = mapDutchBusinessDossierV3ToDossier(dossierV3, dossier);
        unitOfWork.registerNew(dossier);
        List<Business_Data_SBI__c> sbiCodes = new List<Business_Data_SBI__c>();
        sbiCodes = mapDataVendorDataToSBICodes(dossierV3, sbiCodes);
        for (Business_Data_SBI__c businessDataSBI : sbiCodes) {
            unitOfWork.registerNew(businessDataSBI, Business_Data_SBI__c.Business_Dossier__c, dossier);
        }
        Dossier_Address__c correspondenceAddress = new Dossier_Address__c();
        correspondenceAddress = mapDataVendorDataToCorrespondenceAddress(dossierV3, correspondenceAddress);
        unitOfWork.registerNew(correspondenceAddress, Dossier_Address__c.Business_Data__c, dossier);
        Dossier_Address__c establishmentAddress = new Dossier_Address__c();
        establishmentAddress = mapDataVendorDataToEstablishmentAddress(dossierV3, establishmentAddress);
        unitOfWork.registerNew(establishmentAddress, Dossier_Address__c.Business_Data__c, dossier);

        if(getVAT) {
            // try {
                dossier = DutchBusinessService.updateBusinessDossierWithVATNumber(dossier);
//            } catch(CCWsServerDataNotFoundVatException e) {
//                // just don't do anything since the VAT number should stay null in this case.
//            }
        }

        unitOfWork.commitWork();
        return dossier;
    }

    /**
      * Updates a given Dutch business dossier with the VAT number from the CI backend.
      * Sets the flag No_VAT__c to true if no VAT number is known in the backend.
      * Does not update it in the backend.
      *
      * @param dossier the dossier to be updated
      *
      * @return the updated dossier
      */
    public  Business_Dossier__c updateBusinessDossierWithVATNumber(Business_Dossier__c dossier) {
        if (dossier == null) {
            throw new CCInputException(System.Label.Dossier_ID_Missing); // shouldn't happen but let's check the input
        }
        if (dossier.Dossier_Number__c == null) {
            throw new CCInputException(System.Label.Dossier_Number_Missing);
        }
        try {
            DutchBusinessWsdl.DutchBusinessVatNumber vatResponse = WsDutchBusiness.dutchBusinessGetVatNumber(dossier.Dossier_Number__c);
            dossier.VAT_Number__c = vatResponse.vat_number;
        } catch (CCWsServerDataNotFoundVatException notFoundVatException) {
            dossier.No_VAT_Number__c = true;
        }
        return dossier;
    }

    /**
     * Retrieves all Dutch Business Dossiers that have been updated since a certain date. Paginated. Supply the right CI page nr. to get the right results
     *
     * @param pageNr
     * @param updateTypes
     * @param changedSince
     *
     * @return
     */
    public List<UpdateDossierReferenceDTO> getDutchBusinessUpdatedDossiersSince(Integer pageNr, List<String> updateTypes, Date changedSince) {
        if (pageNr == null || pageNr < 1) {
            Exception ex = new CCInputException('pageNr not correct. PageNr is ' + pageNr);
            ErrorLogUtil.logException(ex);
            throw ex;
        }
        if (changedSince == null) {
            Exception ex = new CCInputException('Changed since date is required and is null.');
            ErrorLogUtil.logException(ex);
            throw ex;
        }
        if (changedSince > Date.today()) {
            Exception ex = new CCInputException('Changed since date should be today or earlier. Changed date is ' + changedSince);
            ErrorLogUtil.logException(ex);
            throw ex;
        }
        if (updateTypes == null || updateTypes.size() == 0) {
            Exception ex = new CCInputException('Update tupes should be provided. Update types is:' + updateTypes);
            ErrorLogUtil.logException(ex);
            throw ex;
        }

        DutchBusinessWsdl.stringArray wsUpdateTypesArray = new DutchBusinessWsdl.stringArray();
        wsUpdateTypesArray.item = updateTypes;

        //callout to get the list of dossiers with updates
        DutchBusinessWsdl.DutchBusinessUpdateReferencePagedResult response = WsDutchBusiness.dutchBusinessUpdateGetChangedDossiers(changedSince, wsUpdateTypesArray, pageNr);
        Integer numPages = response.paging.numpages;

        //collect list of dossiers that needs to be updated
        List<UpdateDossierReferenceDTO> updateDossiersList = new List<UpdateDossierReferenceDTO>();

        for (DutchBusinessWsdl.DutchBusinessUpdateReference updatedDossier : response.results.item) {
            updateDossiersList.add(new UpdateDossierReferenceDTO(updatedDossier, numPages));
        }
        return updateDossiersList;
    }

    /**
     * Reads the dossiers with the given ids from the DB
     *
     * @param ids
     *
     * @return
     */
    public List<Business_Dossier__c> getDossiersById(Set<Id> ids) {
        return BusinessDossierSelector.newInstance().selectById(ids);
    }

    /*****************************
    /** IMPLEMENTATION METHODS
    /******************************/

    private List<DutchBusinessWsdl.DutchBusinessEstablishmentReference> searchForDutchBusinessesInCompanyInfo(String dossier_number, String trade_name, String city, String street, String postcode, Integer house_number, String house_number_addition, String telephone_number, String domain_name, Boolean strict_search) {
        List<DutchBusinessWsdl.DutchBusinessEstablishmentReference> searchResults = new List<DutchBusinessWsdl.DutchBusinessEstablishmentReference>();
        DutchBusinessWsdl.DutchBusinessEstablishmentReferencePagedResult returnedResults = WsDutchBusiness.dutchBusinessSearch(dossier_number, trade_name, city, street, postcode, house_number, house_number_addition, telephone_number, domain_name, strict_search, 1);
        if (returnedResults.results != null && returnedResults.results.item != null) {
            searchResults.addAll(returnedResults.results.item);
            Integer numPages = returnedResults.paging.numpages;
            for (Integer i = 2; i <= numPages && searchResults.size() < MAX_SEARCH_RESULTS; i++) {
                returnedResults = WsDutchBusiness.dutchBusinessSearch(dossier_number, trade_name, city, street, postcode, house_number, house_number_addition, telephone_number, domain_name, strict_search, i);
                searchResults.addAll(returnedResults.results.item);
            }
        }
        return searchResults;
    }

    private Account mapDataVendorToAccount(DutchBusinessWsdl.DutchBusinessDossierV3 dataVendorDossier, Account account) {
        account.Name = dataVendorDossier.trade_name_full;
        return account;
    }

    // TODO: refactor Has side effects.
    @TestVisible
    private DutchBusinessWsdl.DutchBusinessDossierV3 getDossier(String dossierNumber, String establishmentNumber) {
        if (dossierNumber == null){ return null;}
        return WsDutchBusiness.dutchBusinessGetDossierV3(dossierNumber, establishmentNumber);
    }

    @TestVisible
    private Business_Dossier__c mapDutchBusinessDossierV3ToDossier(DutchBusinessWsdl.DutchBusinessDossierV3 dataVendorDossier, Business_Dossier__c dossierDB) {
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

    /**
     * Maps a dutch business search result from dutchBusinessSearchParametersV2 to a business dossier SObject
     *
     * @param reference the dutch business reference (search result)
     *
     * @return a new business dossier
     */
    private Business_Dossier__c mapDutchBusinessReferenceV2ToBusinessDossier(DutchBusinessWsdl.DutchBusinessReferenceV2 reference) {
        Business_Dossier__c dossier = new Business_Dossier__c();
        dossier.Dossier_Number__c = reference.dossier_number;
        dossier.Establishment_Number__c = reference.establishment_number;
        dossier.Name = reference.name;
        dossier.Indication_Economically_Active__c = reference.indication_economically_active;
        dossier.Establishment_City__c = reference.establishment_city;
        dossier.Establishment_street__c = reference.establishment_street;
        dossier.Correspondence_City__c = reference.correspondence_city;
        dossier.Correspondence_Street__c = reference.correspondence_street;
        dossier.RecordTypeId = Schema.SObjectType.Business_Dossier__c.getRecordTypeInfosByDeveloperName().get('Dutch_Business').recordTypeId;
        return dossier;
    }

    /**
     * Maps a dutch business search result from dutchBusinessSearch to a business dossier SObject
     *
     * @param reference the dutch business reference (search result)
     *
     * @return a new business dossier
     */
    private Business_Dossier__c mapDutchBusinessEstablishmentReferenceToBusinessDossier(DutchBusinessWsdl.DutchBusinessEstablishmentReference reference) {
        Business_Dossier__c dossier = new Business_Dossier__c();
        dossier.Dossier_Number__c = reference.dossier_number;
        dossier.Establishment_Number__c = reference.establishment_number;
        if (!String.isEmpty(reference.legal_name)) {
            dossier.Name = reference.legal_name;
        } else {
            dossier.Name = reference.trade_name;
        }
        dossier.Trade_Name_Full__c = reference.trade_name;
        dossier.Establishment_City__c = reference.establishment_city;
        dossier.Establishment_street__c = reference.establishment_street;
        dossier.Correspondence_City__c = reference.correspondence_city;
        dossier.Correspondence_Street__c = reference.correspondence_street;
        dossier.Indication_Main_Establishment__c = reference.indication_main_establishment;
        dossier.RecordTypeId = Schema.SObjectType.Business_Dossier__c.getRecordTypeInfosByDeveloperName().get('Dutch_Business').recordTypeId;
        return dossier;
    }

    private String determineStatus(DutchBusinessWsdl.DutchBusinessDossierV3 dossier) {
        List<String> status = new List<String>();
        if (dossier.indication_import != null && Boolean.valueOf(dossier.indication_import) == true) status.add('Import');
        if (dossier.indication_export != null && Boolean.valueOf(dossier.indication_export) == true) status.add('Export');
        if (dossier.indication_economically_active != null && Boolean.valueOf(dossier.indication_economically_active) == true) status.add('Economically Active');
        if (dossier.indication_non_mailing != null && Boolean.valueOf(dossier.indication_non_mailing) == true) status.add('Non Mailing');
        if (dossier.indication_bankruptcy != null && Boolean.valueOf(dossier.indication_bankruptcy) == true) status.add('Bankruptcy');
        if (dossier.indication_dip != null && Boolean.valueOf(dossier.indication_dip) == true) status.add('DIP');
        return String.join(status, ';');
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

}