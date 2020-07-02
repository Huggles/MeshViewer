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

    // TODO: move this to a constant util class in the ISO 3166 dir?
    private final static Map<String, String> translatedCountryByAlpha3Code = new Map<String, String> {
            'BEL' => Label.Country_Belgium,
            'NLD' => Label.Country_Netherlands,
            'GBR' => Label.Country_United_Kingdom,
            'IRE' => Label.Country_Ireland,
            'ITA' => Label.Country_Italy,
            'NOR' => Label.Country_Norway,
            'SWE' => Label.Country_Sweden,
            'ESP' => Label.Country_Spain,
            'DEU' => Label.Country_Germany,
            'FRA' => Label.Country_France,
            'DNK' => Label.Country_Denmark
    };
}
