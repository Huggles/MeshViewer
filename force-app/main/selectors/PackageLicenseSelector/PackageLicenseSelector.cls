/**
 * Created by jaapbranderhorst on 06/05/2020.
 */

public inherited sharing class PackageLicenseSelector  extends fflib_SObjectSelector implements IPackageLicenseSelector  {

    @SuppressWarnings('ApexModifierAgreement')
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                PackageLicense.Id,
                PackageLicense.UsedLicenses,
                PackageLicense.AllowedLicenses,
                PackageLicense.NamespacePrefix
        };
    }

    public SObjectType getSObjectType() {
        return PackageLicense.SObjectType;
    }

    public static IPackageLicenseSelector newInstance() {
        return (IPackageLicenseSelector) Application.Selector.newInstance(PackageLicense.SObjectType);
    }

    public PackageLicense[] selectByNamespacePrefix(String namespacePrefix) {
        fflib_QueryFactory queryFactory = newQueryFactory();
        List<PackageLicense> result = new List<PackageLicense>();
        queryFactory.setCondition('NamespacePrefix = :namespacePrefix');
        result = Database.query(queryFactory.toSOQL());
        return result;
    }

}