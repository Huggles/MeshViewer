/****************************************************************************************
Author          : Jaap Branderhorst
Description     : Service layer for Business dossier related functionality
******************************************************************************************/

public inherited sharing class BusinessServiceImpl implements IBusinessService {

    public static final Integer MAX_SEARCH_RESULTS = 1000;

    /**
     * Deletes the dossier with the given id with all related objects
     *
     * @param dossierId
     *
     */
    public void deleteDossier(Id dossierId, Boolean checkPermissions) {
        if (String.isNotEmpty(dossierId)) {
            List<Business_Dossier__c> dossierList = BusinessDossierSelector.newInstance().selectById(new Set<Id>{
                    dossierId
            });

            if (dossierList.size() == 1) {
                fflib_ISObjectUnitOfWork unitOfWork = null;
                if (checkPermissions) {
                    unitOfWork = Application.UnitOfWork.newInstance(new DMLWithCRUD());
                } else {
                    unitOfWork = Application.UnitOfWork.newInstance();
                }
                unitOfWork.registerDeleted(dossierList[0]);
                unitOfWork.commitWork();

                // TODO: commented for now. Must be added back when we move to update lists
                //if dossier is deleted, then remove it from the update list of dossiers on the company.info server
                //WsDutchBusiness.dutchBusinessUpdateRemoveDossier(dossierList[0].Dossier_Number__c, dossierList[0].Establishment_Number__c);
            }
        }
        else {
            throw new CCInputException(Label.Error_Input_Incorrect);
        }
    }

    public Map<String, String> getCountryOptionsForBusinessSearch() {
        // first get the appropriated datasourcePerCountries

        Set<Datasource_Per_Country__mdt> datasourcePerCountries = new Set<Datasource_Per_Country__mdt>();
        if (LicenseManagementService.userHasAccess(Feature.DUTCH_BUSINESS_GET_DOSSIER))
            datasourcePerCountries.addAll([
                    SELECT
                            ISO_3166_Entry__r.Country_Name__c,
                            ISO_3166_Entry__r.Alpha_2_Code__c,
                            ISO_3166_Entry__r.Label,
                            ISO_3166_Entry__c
                    FROM Datasource_Per_Country__mdt WHERE Data_Source_Select_Record__c = TRUE AND ISO_3166_Entry__r.Alpha_2_Code__c = 'NL']); // doesn't matter what the data source selected is, user has access
        if (LicenseManagementService.userHasAccess(Feature.INTERNATIONAL_BUSINESS_SEARCH)) {
            datasourcePerCountries.addAll([
                    SELECT
                            ISO_3166_Entry__r.Country_Name__c,
                            ISO_3166_Entry__r.Alpha_2_Code__c,
                            ISO_3166_Entry__r.Label,
                            ISO_3166_Entry__c
                    FROM Datasource_Per_Country__mdt
                    WHERE Data_Source_Select_Record__c = TRUE]); // user can search in all countries so we need to return all values
        }

        // next get the  map
        Map<String, String> countryCodesByTranslatedCountryNames = new Map<String, String>();
        for (Datasource_Per_Country__mdt datasourcePerCountry : datasourcePerCountries) {
            String translatedCountry = translatedCountryByAlpha3Code.get(datasourcePerCountry.ISO_3166_Entry__r.Label);
            if (translatedCountry != null)
                countryCodesByTranslatedCountryNames.put(translatedCountry, datasourcePerCountry.ISO_3166_Entry__r.Alpha_2_Code__c);
        }
        return countryCodesByTranslatedCountryNames;
    }


    public List<Business_Dossier__c> findDuplicateDossiersByDossierAndEstablishmentNumber(List<String> dossierNumbers, List<String> establishmentNumbers) {
        if(dossierNumbers == null){
            throw new InputException('Require at least one item in the list.');
        }
        //Make sure to query all fields that might need to be copied to the new dossier.
        List<Business_Dossier__c> duplicateBusinessDossiers = [
                SELECT Id, appsolutely__Business_Positions_Updated_Date__c FROM Business_Dossier__c
                WHERE Dossier_Number__c IN :dossierNumbers AND
                Establishment_Number__c IN :establishmentNumbers
                WITH SECURITY_ENFORCED
        ];
        return duplicateBusinessDossiers;
    }

    public static List<Business_Dossier__c> upsertDossiersAndAccounts(List<Business_Dossier__c> businessDossiers, List<Account> accounts, Boolean ignoreAlertDuplicateRules){
        //The paramters should not be empty, and the size of both lists should be equal
        if(businessDossiers.size() == 0 || accounts.size() == 0 || businessDossiers.size() != accounts.size()){
            throw new InputException(Label.Error_Input_Incorrect);
        }
        fflib_ISObjectUnitOfWork unitOfWork;
        if(ignoreAlertDuplicateRules){
            unitOfWork = Application.UnitOfWork.newInstance(new fflib_SObjectUnitOfWork.DuplicateDML(true));
        }else{
            unitOfWork = Application.UnitOfWork.newInstance();
        }

        List<Business_Dossier__c> response = new List<Business_Dossier__c>();

        //Loop through records to register for insert.
        for (Integer i = 0; i < businessDossiers.size(); i++) {
            Account relatedAccount = accounts[i];
            Business_Dossier__c businessDossier = businessDossiers[i];

            //Add account to response
            unitOfWork.registerUpsert(relatedAccount);

            //Loop through all records to register them for upsert.
            unitOfWork.registerUpsert(businessDossier);
            for(Business_Data_SBI__c sbi : businessDossier.SBIs__r){
                unitOfWork.registerRelationship(sbi, Business_Data_SBI__c.Business_Dossier__c, businessDossier);
                unitOfWork.registerNew(sbi);
            }
            unitOfWork.registerRelationship(relatedAccount, Account.Business_Dossier__c, businessDossier);

            response.add(businessDossier);
        }
        try {
            unitOfWork.commitWork();
        }catch (Exception e){
            throw e;
        }
        return response;
    }

    // TODO: move this to a constant util class in the ISO 3166 dir?
    private final static Map<String, String> translatedCountryByAlpha3Code = new Map<String, String> {
            'BEL' => Label.Country_Belgium,
            'NLD' => Label.Country_Netherlands,
            'GBR' => Label.Country_United_Kingdom,
            'IRL' => Label.Country_Ireland,
            'ITA' => Label.Country_Italy,
            'NOR' => Label.Country_Norway,
            'SWE' => Label.Country_Sweden,
            'ESP' => Label.Country_Spain,
            'DEU' => Label.Country_Germany,
            'FRA' => Label.Country_France,
            'DNK' => Label.Country_Denmark,
            'LUX' => Label.Country_Luxembourg
    };
}
