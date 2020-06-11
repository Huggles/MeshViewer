/**
 * Created by jaapbranderhorst on 07/05/2020.
 */

/**
 * Wrapper around PackageLicense to make PackageLicense testable
*/

public with sharing class PackageLicenseWrapper {

    public Integer usedLicenses {
        get;
        set;
    }

    public Id id {
        get;
        set;
    }

    public Integer allowedLicenses {
        get;
        set;
    }

    public String namespacePrefix {
        get;
        set;
    }

    public PackageLicenseWrapper(PackageLicense packageLicense) {
        this.usedLicenses = packageLicense.UsedLicenses;
        this.id = packageLicense.Id;
        this.allowedLicenses = packageLicense.AllowedLicenses;
        this.namespacePrefix = packageLicense.NamespacePrefix;
    }

    public PackageLicenseWrapper(Id packageLicenseId, Integer usedLicenses, Integer allowedLicenses, String namespacePrefix) {
        this.usedLicenses = usedLicenses;
        this.id = packageLicenseId;
        this.allowedLicenses = allowedLicenses;
        this.namespacePrefix = namespacePrefix;
    }

}