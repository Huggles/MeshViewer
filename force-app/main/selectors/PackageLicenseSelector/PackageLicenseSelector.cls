/**
 * Created by jaapbranderhorst on 06/05/2020.
 */

public inherited sharing class PackageLicenseSelector  extends fflib_SObjectSelector implements IPackageLicenseSelector  {

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

    public PackageLicenseWrapper[] selectById(Id packageId) {
        fflib_QueryFactory queryFactory = newQueryFactory();
        List<PackageLicenseWrapper> result = new List<PackageLicenseWrapper>();
        queryFactory.setCondition('Id = :packageId');
        List<PackageLicense> packageLicenses = Database.query(queryFactory.toSOQL());
        for (PackageLicense packageLicense : packageLicenses) {
            result.add(new PackageLicenseWrapper(packageLicense));
        }
        return result;
    }



}