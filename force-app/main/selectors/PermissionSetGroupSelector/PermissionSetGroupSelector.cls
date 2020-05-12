/**
 * Created by jaapbranderhorst on 06/05/2020.
 */

public inherited sharing class PermissionSetGroupSelector extends fflib_SObjectSelector implements IPermissionSetGroupSelector{

    public static IPermissionSetGroupSelector newInstance() {
        return (IPermissionSetGroupSelector) Application.Selector.newInstance(PermissionSetGroup.SObjectType);
    }

    public SObjectType getSObjectType() {
        return PermissionSetGroup.SObjectType;
    }

    public PermissionSetGroup[] selectByDeveloperName(String developerName) {
        // When checking on CRUD access, the framework returns that a system admin doesn't have access. Therefore overridden the access check.
        fflib_QueryFactory queryFactory = newQueryFactory(false, false, true);
        List<PermissionSetGroup> result = new List<PermissionSetGroup>();
        queryFactory.setCondition('DeveloperName = :developerName');
        System.debug(queryFactory.toSOQL());
        result = Database.query(queryFactory.toSOQL());
        return result;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                PermissionSetGroup.Id,
                PermissionSetGroup.DeveloperName,
                PermissionSetGroup.Description
        };
    }

}