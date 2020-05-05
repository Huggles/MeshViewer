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
                User.ProfileId.Name,
                User.UserRoleId
        };
    }

    public List<User> selectByPermissionSetGroup(String permissionSetGroup, Boolean enforceFLS) {
        return null;
    }


}