/**
 * Created by jaapbranderhorst on 06/05/2020.
 */

public inherited sharing class PermissionSetAssignmentSelector extends fflib_SObjectSelector implements IPermissionSetAssignmentSelector {

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
        return 'Id';
    }


    public static IPermissionSetAssignmentSelector newInstance() {
        SObjectType op = PermissionSetAssignment.SObjectType;
        System.debug(op);
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

}