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
                User.FirstName,
                User.LastName,
                User.ProfileId,
                User.UserRoleId
        };
    }

    public List<User> selectByPermissionSetGroup(PermissionSetGroup permissionSetGroup) {
        Set<Id> ids = selectUserIdsByPermissionSetGroup(permissionSetGroup);
        return [SELECT Id, Name, Alias, FirstName, LastName, ProfileId, Profile.Name, UserRole.Name FROM User WHERE Id IN :ids]; // don't use the queryfactory. Too complex
    }

    public List<User> selectByPermissionSetGroup(PermissionSetGroup permissionSetGroup, Integer offSet, Integer nrOfRows, List<fflib_QueryFactory.Ordering> orderings) {
        List<fflib_QueryFactory.Ordering> permissionSetAssignmentOrderings = new List<fflib_QueryFactory.Ordering>();
        for (fflib_QueryFactory.Ordering ordering : orderings) {
            permissionSetAssignmentOrderings.add(new fflib_QueryFactory.Ordering('Assignee.' + ordering.getField(), ordering.getDirection(), ordering.isNullsLast()));
        }

        PermissionSetAssignment[] permissionSetAssignments = PermissionSetAssignmentSelector.newInstance().selectByPermissionSetGroup(permissionSetGroup, offSet, nrOfRows, permissionSetAssignmentOrderings);
        List<User> result = new List<User>();
        for (PermissionSetAssignment permissionSetAssignment : permissionSetAssignments) {
            result.add(permissionSetAssignment.Assignee);
        }
        return result;
    }

    public List<User> selectUsersWithoutPermissionSetGroup(PermissionSetGroup permissionSetGroup, Integer offSet, Integer nrOfRows, List<fflib_QueryFactory.Ordering> orderings) {
        Set<Id> usersWithPermissionSetGroupIds = selectUserIdsByPermissionSetGroup(permissionSetGroup);
        fflib_QueryFactory queryFactory = newQueryFactory();
        queryFactory.setCondition('Id NOT IN :usersWithPermissionSetGroupIds');
        for (fflib_QueryFactory.Ordering ordering : orderings) {
            queryFactory.addOrdering(ordering);
        }
        queryFactory.setOffset(offSet);
        queryFactory.setLimit(nrOfRows);
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