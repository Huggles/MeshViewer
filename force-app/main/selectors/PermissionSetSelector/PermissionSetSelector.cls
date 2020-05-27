/**
 * Created by jaapbranderhorst on 26/05/2020.
 */

public with sharing class PermissionSetSelector extends fflib_SObjectSelector implements IPermissionSetSelector{

    @TestVisible
    private static Map<LicenseType, PermissionSet> permissionSetByLicenseTypes {
        get {
            if (permissionSetByLicenseTypes == null) {
                permissionSetByLicenseTypes = new Map<LicenseType, PermissionSet>();
                Map<String, LicenseType> licenseTypesByName = new Map<String, LicenseType>();
                for (LicenseType licenseType : LicenseType.values()) {
                    licenseTypesByName.put(licenseType.name(), licenseType);
                }
                System.debug('license type names: ' + JSON.serializePretty(licenseTypesByName));
                License_Type_Definition__mdt[] licenseTypeDefinitions = [SELECT Permission_Set_API_Name__c, DeveloperName, Licence_Type_Name__c FROM License_Type_Definition__mdt];
                Set<String> permissionSetApiNames = new Set<String>();
                Map<String, LicenseType> licenseTypesByPermissionSetApiName = new Map<String, LicenseType>();
                for (License_Type_Definition__mdt licenseTypeDefinition : licenseTypeDefinitions) {
                    permissionSetApiNames.add(licenseTypeDefinition.Permission_Set_API_Name__c);
                    licenseTypesByPermissionSetApiName.put(licenseTypeDefinition.Permission_Set_API_Name__c, licenseTypesByName.get(licenseTypeDefinition.Licence_Type_Name__c));
                }
                System.debug('permission set names: ' + JSON.serializePretty(permissionSetApiNames));
                PermissionSet[] permissionSets = [SELECT Name, Id, Label, NamespacePrefix FROM PermissionSet WHERE Name IN : permissionSetApiNames];
                System.debug('permission sets: ' + JSON.serializePretty(permissionSets));

                for (PermissionSet permissionSet : permissionSets) {
                    LicenseType licenseType = licenseTypesByName.get(permissionSet.Name.toUpperCase());
                    permissionSetByLicenseTypes.put(licenseType, permissionSet);
                }
            }
            return permissionSetByLicenseTypes;
        }
        set;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                PermissionSet.Id,
                PermissionSet.Name,
                PermissionSet.Label,
                PermissionSet.NamespacePrefix
        };
    }

    public SObjectType getSObjectType() {
        return PermissionSet.SObjectType;
    }

    public static IPermissionSetSelector newInstance() {
        SObjectType op = PermissionSet.SObjectType;
        return (IPermissionSetSelector)Application.Selector.newInstance(PermissionSet.SObjectType);
    }

    public PermissionSet selectByLicenseType(LicenseType licenseType) {
        return permissionSetByLicenseTypes.get(licenseType);
    }

    public PermissionSet[] selectLicenseTypePermissionSetsExcludingLicenseType(LicenseType licenseTp) {
        Set<LicenseType> otherLicenseTypes = new Set<LicenseType>(LicenseType.values());
        otherLicenseTypes.remove(licenseTp);
        PermissionSet[] returnValue = new List<PermissionSet>();
        for (LicenseType licenseType2 : otherLicenseTypes) {
            if (permissionSetByLicenseTypes.get(licenseType2) != null) // test license type values don't have permission sets related to them and will return null therefore
                returnValue.add(permissionSetByLicenseTypes.get(licenseType2));
        }
        System.debug('permission sets with exclusion: ' + JSON.serializePretty(returnValue));
        return returnValue;
    }


}