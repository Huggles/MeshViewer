/**
 * Created by jaapbranderhorst on 05/05/2020.
 */

public inherited sharing class UserSelector  extends fflib_SObjectSelector implements IUserSelector  {


    public static IUserSelector newInstance() {
        return (IUserSelector) Application.Selector.newInstance(User.SObjectType);
    }

    public SObjectType getSObjectType() {
        return User.SObjectType;
    }


    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                User.Id,
                User.Alias,
                User.Name,
                User.IsActive,
                User.Username,
                User.FirstName,
                User.LastName
        };
    }

    public override String getOrderBy() { // no default ordering
        return null;
    }

    public List<User> selectByLicenseType(LicenseType licenseType, Integer offSet, Integer nrOfRows, List<fflib_QueryFactory.Ordering> orderings){
        List<fflib_QueryFactory.Ordering> permissionSetAssignmentOrderings = new List<fflib_QueryFactory.Ordering>();
        for (fflib_QueryFactory.Ordering ordering : orderings) {
            permissionSetAssignmentOrderings.add(new fflib_QueryFactory.Ordering('Assignee.' + ordering.getField(), ordering.getDirection(), ordering.isNullsLast()));
        }
        PermissionSetAssignment[] permissionSetAssignments = PermissionSetAssignmentSelector.newInstance().selectByLicenseType(licenseType, offSet, nrOfRows, permissionSetAssignmentOrderings);
        Set<Id> userIds = new Set<Id>();
        for (PermissionSetAssignment permissionSetAssignment : permissionSetAssignments) {
            userIds.add(permissionSetAssignment.AssigneeId);
        }
        fflib_QueryFactory queryFactory = newQueryFactory().selectField('Profile.Name').selectField('UserRole.Name').setCondition('Id IN :userIds');
        // TODO: check the ordering
        for (fflib_QueryFactory.Ordering ordering : orderings) {
            queryFactory.addOrdering(ordering);
        }
        return Database.query(queryFactory.toSOQL());
    }

    public List<User> selectByLicenseType(LicenseType licenseType) {
        PermissionSetAssignment[] assignments = PermissionSetAssignmentSelector.newInstance().selectByLicenseType(licenseType);
        Set<Id> assigneeIds = new Set<Id>();
        for (PermissionSetAssignment permissionSetAssignment : assignments) {
            assigneeIds.add(permissionSetAssignment.AssigneeId);
        }
        fflib_QueryFactory queryFactory = newQueryFactory().selectField('Profile.Name').selectField('UserRole.Name').setCondition('Id IN :assigneeIds');
        List<User> result = Database.query(queryFactory.toSOQL());
        return result;
    }

//    public List<User> selectUsersWithoutLicenseTypeSeat(LicenseType licenseType, Integer offSet, Integer nrOfRows, List<fflib_QueryFactory.Ordering> orderings) {
//        // only users with the right profiles/license types. Only users that do not have the seat (so not in permission set).
//        List<User> results = new List<User>();
//        PermissionSet permissionSet = PermissionSetSelector.newInstance().selectByLicenseType(licenseType);
//        if (permissionSet != null) { // can be null if the licenseType is a test licensetype
//            Id permissionSetId = permissionSet.Id;
//            // List<User> users = [SELECT Id FROM User WHERE ProfileId IN :profileIds AND Id IN (SELECT AssigneeId FROM PermissionSetAssignment WHERE )]
//            fflib_QueryFactory queryFactory = newQueryFactory().selectField('Profile.Name').selectField('UserRole.Name').setCondition('Id IN (SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId != :permissionSetId) AND ProfileId IN :profileIds' +
//                    ' AND Id NOT IN (SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId = :permissionSetId)');
//            // TODO: check the ordering
//            for (fflib_QueryFactory.Ordering ordering : orderings) {
//                queryFactory.addOrdering(ordering);
//            }
//            User[] rawResults = Database.query(queryFactory.toSOQL());
//            Map<Id, User> usersByIds = new Map<Id, User>(rawResults);
//            results = usersByIds.values();
//        }
//        return results;
//    }

    public List<User> selectUsersAvailableForLicenseType(LicenseType licenseType, Integer offSet, Integer nrOfRows, List<fflib_QueryFactory.Ordering> orderings) {
        List<User> results = new List<User>();
        PermissionSet permissionSet = PermissionSetSelector.newInstance().selectByLicenseType(licenseType);
        if (permissionSet != null) { // can be null if the licenseType is a test licensetype
            PermissionSet[] permissionSets = PermissionSetSelector.newInstance().selectAllLicenseTypePermissionSets();
            Set<Id> permissionSetIds = (new Map<Id, PermissionSet>(permissionSets)).keySet();
            Set<Id> profileIds = LicenseManagementService.getAllowedProfileIdsForLicenseType(licenseType);
            fflib_QueryFactory queryFactory = newQueryFactory()
                    .selectField('Profile.Name')
                    .selectField('UserRole.Name')
                    .setCondition('ProfileId IN :profileIds ' +
                            'AND Id NOT IN (SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId = :permissionSetIds)');
            for (fflib_QueryFactory.Ordering ordering : orderings) {
                queryFactory.addOrdering(ordering);
            }
            User[] rawResults = Database.query(queryFactory.toSOQL());
            Map<Id, User> usersByIds = new Map<Id, User>(rawResults);
            results = usersByIds.values();
        }
        return results;
    }

}