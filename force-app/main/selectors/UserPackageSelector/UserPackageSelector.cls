/**
 * Created by jaapbranderhorst on 06/05/2020.
 */

public inherited sharing class UserPackageSelector extends fflib_SObjectSelector implements IUserPackageSelector{
    
    // UserPackageLicense[] userPackageLicenses = [SELECT Id FROM UserPackageLicense WHERE PackageLicenseId = :packageLicense.Id AND UserId IN :usersByIds.keySet()];

    public static IUserPackageSelector newInstance() {
        return (IUserPackageSelector) Application.Selector.newInstance(UserPackageLicense.SObjectType);
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                UserPackageLicense.Id,
                UserPackageLicense.UserId,
                UserPackageLicense.PackageLicenseId
        };
    }

    public SObjectType getSObjectType() {
        return UserPackageLicense.SObjectType;
    }

    public UserPackageLicense[] selectByPackageLicenseAndUsers(PackageLicenseWrapper packageLicense, User[] users) {
        fflib_QueryFactory queryFactory = newQueryFactory();
        List<UserPackageLicense> result = new List<UserPackageLicense>();
        String packageLicenseId = packageLicense.Id;
        Set<Id> userIds = (new Map<Id, User>(users)).keySet();
        queryFactory.setCondition('PackageLicenseId = :packageLicenseId AND UserId IN :userIds');
        result = Database.query(queryFactory.toSOQL());
        return result;
    }

}