/**
 * Created by jaapbranderhorst on 05/05/2020.
 */

public inherited sharing class UserSelector  extends fflib_SObjectSelector implements IUserSelector  {

    private static Set<Id> profileIds {
        get {
            if (profileIds == null) {
                profileIds = (new Map<Id, Profile>([SELECT Id FROM Profile WHERE UserLicenseId IN: LicenseManagementServiceImpl.allowedUserLicenseIds])).keySet();
            }
            return profileIds;
        }
        set;
    }

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
                User.Username
        };
    }

    public override String getOrderBy() { // no default ordering
        return null;
    }


//    public List<User> selectByPermissionSetGroup(PermissionSetGroup permissionSetGroup) {
//        Set<Id> ids = selectUserIdsByPermissionSetGroup(permissionSetGroup);
//        fflib_QueryFactory queryFactory = newQueryFactory().selectField('Profile.Name').selectField('UserRole.Name').setCondition('Id IN :ids AND ProfileId IN :profileIds');
//        return Database.query(queryFactory.toSOQL());
//    }
//
//    public List<User> selectByPermissionSetGroup(PermissionSetGroup permissionSetGroup, Integer offSet, Integer nrOfRows, List<fflib_QueryFactory.Ordering> orderings) {
//        List<fflib_QueryFactory.Ordering> permissionSetAssignmentOrderings = new List<fflib_QueryFactory.Ordering>();
//        for (fflib_QueryFactory.Ordering ordering : orderings) {
//            permissionSetAssignmentOrderings.add(new fflib_QueryFactory.Ordering('Assignee.' + ordering.getField(), ordering.getDirection(), ordering.isNullsLast()));
//        }
//
//        PermissionSetAssignment[] permissionSetAssignments = PermissionSetAssignmentSelector.newInstance().selectByPermissionSetGroup(permissionSetGroup, offSet, nrOfRows, permissionSetAssignmentOrderings);
//        Set<Id> userIds = new Set<Id>();
//        for (PermissionSetAssignment permissionSetAssignment : permissionSetAssignments) {
//            userIds.add(permissionSetAssignment.AssigneeId);
//        }
//        fflib_QueryFactory queryFactory = newQueryFactory().selectField('Profile.Name').selectField('UserRole.Name').setCondition('Id IN :userIds AND ProfileId IN :profileIds');
//        return Database.query(queryFactory.toSOQL());
//    }
//
//    public List<User> selectUsersWithoutPermissionSetGroup(PermissionSetGroup permissionSetGroup, Integer offSet, Integer nrOfRows, List<fflib_QueryFactory.Ordering> orderings) {
//        Set<Id> usersWithPermissionSetGroupIds = selectUserIdsByPermissionSetGroup(permissionSetGroup);
//        fflib_QueryFactory queryFactory = newQueryFactory().selectField('Profile.Name').selectField('UserRole.Name');
//        queryFactory.setCondition('Id NOT IN :usersWithPermissionSetGroupIds AND ProfileId IN :profileIds');
//        for (fflib_QueryFactory.Ordering ordering : orderings) {
//            queryFactory.addOrdering(ordering);
//        }
//        queryFactory.setOffset(offSet);
//        queryFactory.setLimit(nrOfRows);
//        List<User> result = Database.query(queryFactory.toSOQL());
//        return result;
//    }

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
        fflib_QueryFactory queryFactory = newQueryFactory().selectField('Profile.Name').selectField('UserRole.Name').setCondition('Id IN :userIds AND ProfileId IN :profileIds');
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
        return selectSObjectsById(assigneeIds);
    }

    public List<User> selectUsersWithoutLicenseType(LicenseType licenseType, Integer offSet, Integer nrOfRows, List<fflib_QueryFactory.Ordering> orderings) {
        PermissionSet[] permissionSets = PermissionSetSelector.newInstance().selectPermissionSetsExcludingLicenseType(licenseType);
        Set<Id> permissionSetIds = (new Map<Id, PermissionSet>(permissionSets)).keySet();
        fflib_QueryFactory queryFactory = newQueryFactory().selectField('Profile.Name').selectField('UserRole.Name');
        queryFactory.setCondition('Id NOT IN :usersWithPermissionSetGroupIds AND ProfileId IN :profileIds');
        for (fflib_QueryFactory.Ordering ordering : orderings) {
            queryFactory.addOrdering(ordering);
        }
        queryFactory.setOffset(offSet);
        queryFactory.setLimit(nrOfRows);
        List<User> result = Database.query(queryFactory.toSOQL());
        return result;
    }

}