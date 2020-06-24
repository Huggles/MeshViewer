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
                License_Type_Definition__mdt[] licenseTypeDefinitions = [SELECT Permission_Set_API_Name__c, DeveloperName, Licence_Type_Name__c FROM License_Type_Definition__mdt];
                Set<String> permissionSetApiNames = new Set<String>();
                Map<String, LicenseType> licenseTypesByPermissionSetApiName = new Map<String, LicenseType>();
                for (License_Type_Definition__mdt licenseTypeDefinition : licenseTypeDefinitions) {
                    if (!String.isEmpty(licenseTypeDefinition.Permission_Set_API_Name__c) && (!String.isEmpty(licenseTypeDefinition.Licence_Type_Name__c))) {
                        permissionSetApiNames.add(licenseTypeDefinition.Permission_Set_API_Name__c);
                        licenseTypesByPermissionSetApiName.put(licenseTypeDefinition.Permission_Set_API_Name__c, licenseTypesByName.get(licenseTypeDefinition.Licence_Type_Name__c));
                    }
                }
                PermissionSet[] permissionSets = [SELECT Name, Id, Label, NamespacePrefix FROM PermissionSet WHERE Name IN : permissionSetApiNames];
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
        return returnValue;
    }

    public PermissionSet[] selectAllLicenseTypePermissionSets() {
        return permissionSetByLicenseTypes.values();
    }

    public PermissionSet[] selectPermissionSetsByCustomPermission(List<CustomPermission> customPermissions) {
        Set<Id> customPermissionIds = (new Map<Id, CustomPermission>(customPermissions)).keySet();
        PermissionSet[] permissionSets = [SELECT Id, Name, Label, NamespacePrefix FROM PermissionSet WHERE IsOwnedByProfile = false AND Id IN (SELECT ParentId FROM SetupEntityAccess WHERE SetupEntityType = 'CustomPermission' AND SetupEntityId IN :customPermissionIds)];
        return permissionSets;
    }


}