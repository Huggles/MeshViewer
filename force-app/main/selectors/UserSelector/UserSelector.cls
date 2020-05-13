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
                User.Username
        };
    }

    public override String getOrderBy() { // no default ordering
        return null;
    }


    public List<User> selectByPermissionSetGroup(PermissionSetGroup permissionSetGroup) {
        Set<Id> ids = selectUserIdsByPermissionSetGroup(permissionSetGroup);
        return selectSObjectsById(ids);
    }

    public List<User> selectByPermissionSetGroup(PermissionSetGroup permissionSetGroup, Integer offSet, Integer nrOfRows, List<fflib_QueryFactory.Ordering> orderings) {
        List<fflib_QueryFactory.Ordering> permissionSetAssignmentOrderings = new List<fflib_QueryFactory.Ordering>();
        for (fflib_QueryFactory.Ordering ordering : orderings) {
            permissionSetAssignmentOrderings.add(new fflib_QueryFactory.Ordering('Assignee.' + ordering.getField(), ordering.getDirection(), ordering.isNullsLast()));
        }

        PermissionSetAssignment[] permissionSetAssignments = PermissionSetAssignmentSelector.newInstance().selectByPermissionSetGroup(permissionSetGroup, offSet, nrOfRows, permissionSetAssignmentOrderings);
        Set<Id> userIds = new Set<Id>();
        for (PermissionSetAssignment permissionSetAssignment : permissionSetAssignments) {
            userIds.add(permissionSetAssignment.AssigneeId);
        }
        fflib_QueryFactory queryFactory = newQueryFactory().selectField('Profile.Name').selectField('UserRole.Name').setCondition('Id IN :userIds');
        return Database.query(queryFactory.toSOQL());
    }

    public List<User> selectUsersWithoutPermissionSetGroup(PermissionSetGroup permissionSetGroup, Integer offSet, Integer nrOfRows, List<fflib_QueryFactory.Ordering> orderings) {
        Set<Id> usersWithPermissionSetGroupIds = selectUserIdsByPermissionSetGroup(permissionSetGroup);
        fflib_QueryFactory queryFactory = newQueryFactory().selectField('Profile.Name').selectField('UserRole.Name');
        queryFactory.setCondition('Id NOT IN :usersWithPermissionSetGroupIds');
        for (fflib_QueryFactory.Ordering ordering : orderings) {
            queryFactory.addOrdering(ordering);
        }
        queryFactory.setOffset(offSet);
        queryFactory.setLimit(nrOfRows);
        System.debug('******* QUery: ' + queryFactory.toSOQL());
        List<User> result = Database.query(queryFactory.toSOQL());
        return result;
    }

    /**
     * IMPLEMENTATION METHODS
    */

    private Set<Id> selectUserIdsByPermissionSetGroup(PermissionSetGroup permissionSetGroup) {
        PermissionSetAssignment[] permissionSetAssignments = PermissionSetAssignmentSelector.newInstance().selectByPermissionSetGroup(permissionSetGroup);
        Set<Id> ids = new Set<Id>();
        for (PermissionSetAssignment permissionSetAssignment : permissionSetAssignments) {
            ids.add(permissionSetAssignment.AssigneeId);
        }
        return ids;
    }




}