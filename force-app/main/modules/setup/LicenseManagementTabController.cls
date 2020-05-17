/**
 * Created by jaapbranderhorst on 17/05/2020.
 */

public inherited sharing class LicenseManagementTabController {

    @AuraEnabled(Cacheable=true)
    public static String[] getLicenseTypes() {
        LicenseType[] licenseTypes = LicenseType.values();
        List<String> returnValues = new List<String>();
        for (LicenseType licenseType : licenseTypes) {
            String name = licenseType.name();
            if (!name.startsWith('TEST')) {
                returnValues.add(name);
            }
        }
        return returnValues;
    }

}