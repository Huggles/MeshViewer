/**
 * Created by jaapbranderhorst on 09/05/2020.
 */

public inherited sharing class LicenseTypeManagementCardController {

    public inherited sharing class LicenseTypeInfo {

        @AuraEnabled
        public Integer totalNrOfSeats { get; set; }

        @AuraEnabled
        public Integer availableNrOfSeats { get; set; }

        @AuraEnabled
        public String name { get; set; }
    }

    @AuraEnabled
    public static LicenseTypeInfo getLicenseTypeInfo(String licenseTypeAPIName) {
        LicenseType licenseType = LicenseManagementService.getLicenseTypeByName(licenseTypeAPIName);
        LicenseTypeInfo info = new LicenseTypeInfo();
        info.availableNrOfSeats = LicenseManagementService.getNumberOfAvailableSeats(licenseType);
        info.name = LicenseManagementService.getLicenseTypeName(licenseType);
        info.totalNrOfSeats = LicenseManagementService.getTotalNumberOfSeats(licenseType);
        return info;
    }

}