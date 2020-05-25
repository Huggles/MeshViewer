/**
 * Created by jaapbranderhorst on 06/05/2020.
 */

public inherited sharing class PermissionSetAssignmentSelector extends fflib_SObjectSelector implements IPermissionSetAssignmentSelector {

    private static Map<LicenseType, Set<Id>> permissionSetIdsByLicenseTypes = new Map<LicenseType, Set<Id>>();

    private static Set<Id> getPermissionSetIds(LicenseType licenseType) {
//        Set<Id> result = permissionSetIdsByLicenseTypes.get(licenseType);
//        if (result == null) {
//            License_Type_Definition__mdt licenseTypeDefinition = [SELECT Id FROM License_Type_Definition__mdt WHERE DeveloperName = :licenseType.name()];
//            License_Type_Permission_Set__mdt[] licenseTypePermissionSets = [SELECT Permission_Set_API_Name__c FROM License_Type_Permission_Set__mdt WHERE License_Type_Definition__c = :licenseTypeDefinition.Id];
//            Set<String> permissionSetApiNames = new Set<String>();
//            for (License_Type_Permission_Set__mdt licenseTypePermissionSet : licenseTypePermissionSets) {
//                permissionSetApiNames.add(licenseTypePermissionSet.Permission_Set_API_Name__c);
//            }
//            result = (new Map<Id, PermissionSet>([SELECT Id FROM PermissionSet WHERE Name IN :permissionSetApiNames])).keySet();
//        }
//        return result;
        // TODO: implement this
        return null;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                PermissionSetAssignment.AssigneeId,
                PermissionSetAssignment.PermissionSetGroupId,
                PermissionSetAssignment.PermissionSetId,
                PermissionSetAssignment.Id
        };
    }

    public SObjectType getSObjectType() {
        return PermissionSetAssignment.SObjectType;
    }

    // need to override this because the PermissionSetAssignment 'SObject' doesn't have a createddate or name
    public override String getOrderBy() {
        return null;
    }


    public static IPermissionSetAssignmentSelector newInstance() {
        SObjectType op = PermissionSetAssignment.SObjectType;
        return (IPermissionSetAssignmentSelector)Application.Selector.newInstance(PermissionSetAssignment.SObjectType);
        // return (IPermissionSetAssignmentSelector) Application.Selector.newInstance(op);
    }

    public PermissionSetAssignment[] selectByPermissionSetGroupAndUsers(PermissionSetGroup permissionSetGroup, List<User> users) {
        Set<Id> userIds = (new Map<Id, User>(users)).keySet();
        fflib_QueryFactory queryFactory = newQueryFactory();
        List<PermissionSetAssignment> result = new List<PermissionSetAssignment>();
        Id groupId = permissionSetGroup.Id;
        queryFactory.setCondition('PermissionSetGroupId = :groupId AND AssigneeId IN :userIds');
        result = Database.query(queryFactory.toSOQL());
        return result;
    }

    public PermissionSetAssignment[] selectByPermissionSetGroup(PermissionSetGroup permissionSetGroup) {
        fflib_QueryFactory queryFactory = newQueryFactory();
        List<PermissionSetAssignment> result = new List<PermissionSetAssignment>();
        Id groupId = permissionSetGroup.Id;
        queryFactory.setCondition('PermissionSetGroupId = :groupId');
        result = Database.query(queryFactory.toSOQL());
        return result;
    }

    public PermissionSetAssignment[] selectByPermissionSetGroup(PermissionSetGroup permissionSetGroup, Integer offSet, Integer nrOfRows, List<fflib_QueryFactory.Ordering> orderings) {
        fflib_QueryFactory queryFactory = newQueryFactory(false, false, true);
        List<PermissionSetAssignment> result = new List<PermissionSetAssignment>();
        Id groupId = permissionSetGroup.Id;
        queryFactory.setCondition('PermissionSetGroupId = :groupId');
        for (fflib_QueryFactory.Ordering ordering : orderings) {
            queryFactory.addOrdering(ordering);
        }
        queryFactory.setOffset(offSet);
        queryFactory.setLimit(nrOfRows);
        result = Database.query(queryFactory.toSOQL());
        return result;
    }

    public PermissionSetAssignment[] selectByLicenseType(LicenseType licenseType, Integer offSet, Integer nrOfRows, List<fflib_QueryFactory.Ordering> orderings) {
        fflib_QueryFactory queryFactory = newQueryFactory(false, false, true);
        List<PermissionSetAssignment> result = new List<PermissionSetAssignment>();
        Set<Id> permissionSetIds = getPermissionSetIds(licenseType);
        queryFactory.setCondition('PermissionSetId = :permissionSetIds');
        for (fflib_QueryFactory.Ordering ordering : orderings) {
            queryFactory.addOrdering(ordering);
        }
        queryFactory.setOffset(offSet);
        queryFactory.setLimit(nrOfRows);
        result = Database.query(queryFactory.toSOQL());
        return result;
    }

}