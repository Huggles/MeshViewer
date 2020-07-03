/**
 * Created by jaapbranderhorst on 17/05/2020.
 */

public inherited sharing class LicenseManagementTabController {

    @AuraEnabled(Cacheable=true)
    public static String[] getLicenseTypes() {
        try {
            List<License_Type_Definition__mdt> licenseTypeDefinitions = new List<License_Type_Definition__mdt>();
            licenseTypeDefinitions = [
                    SELECT
                            Licence_Type_Name__c,
                            Nr_Of_Seats_Feature_Param_API_Name__c,
                            Permission_Set_API_Name__c,
                            Title__c,
                            DeveloperName,
                            Id,
                            Label,
                            Language,
                            MasterLabel,
                            NamespacePrefix,
                            QualifiedApiName,
                            Order__c
                    FROM License_Type_Definition__mdt
                    WHERE Order__c > 0
                    ORDER BY Order__c ASC
            ];
            List<String> returnValues = new List<String>();
            for (License_Type_Definition__mdt licenseTypeDefinition : licenseTypeDefinitions) {
                Integer nrOfSeats = LicenseManagementService.newInstance().getTotalNumberOfSeats(LicenseManagementService.newInstance().getLicenseTypeByName(licenseTypeDefinition.Licence_Type_Name__c));
                if (nrOfSeats != null && nrOfSeats > 0)
                    returnValues.add(licenseTypeDefinition.Licence_Type_Name__c);
            }
            return returnValues;

        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

}