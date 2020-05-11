/**
 * Created by jaapbranderhorst on 09/05/2020.
 */

public inherited sharing class LicenseTypeManagementCardController {

    public inherited sharing class Ordering {

        @AuraEnabled
        public String fieldName {get; set;}

        @AuraEnabled
        public String sortOrder {get; set;}
    }

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
        System.debug('info ' + info);
        return info;
    }

    @AuraEnabled(Cacheable=true)
    public static User[] getAssignedUsers(String licenseTypeAPIName, Integer startRow, Integer endRow, List<Ordering> orderings) {
        System.debug('licenseTypeAPIName ' + licenseTypeAPIName);
        System.debug('startRow ' + startRow);
        System.debug('endrow ' + endRow);
        System.debug('orderings ' + orderings);
        LicenseType licenseType = LicenseManagementService.getLicenseTypeByName(licenseTypeAPIName);
        List<fflib_QueryFactory.Ordering> queryOrderings = new List<fflib_QueryFactory.Ordering>();
        for (Ordering ordering : orderings) {
            queryOrderings.add(new fflib_QueryFactory.Ordering(ordering.fieldName, ordering.sortOrder == 'asc' ? fflib_QueryFactory.SortOrder.ASCENDING : fflib_QueryFactory.SortOrder.DESCENDING, false));
        }
        return LicenseManagementService.getAssignedUsersForLicenseType(licenseType, startRow, endRow - startRow, queryOrderings);
    }

}