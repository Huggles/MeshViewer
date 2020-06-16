/**
 * Created by jaapbranderhorst on 06/05/2020.
 */

public interface IPackageLicenseSelector extends fflib_ISObjectSelector {

    // packageLicense = [SELECT Id, UsedLicenses, AllowedLicenses FROM PackageLicense WHERE NamespacePrefix = :NAMESPACE_PREFIX];

    /**
     * Selects the PackageLicense records belonging to the namespaceprefix.
    */
    PackageLicenseWrapper[] selectByNamespacePrefix(String namespacePrefix);

}