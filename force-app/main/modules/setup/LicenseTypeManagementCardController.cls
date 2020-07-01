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
        try {
            LicenseType licenseType = LicenseManagementService.getLicenseTypeByName(licenseTypeAPIName);
            LicenseTypeInfo info = new LicenseTypeInfo();
            info.availableNrOfSeats = LicenseManagementService.getNumberOfAvailableSeats(licenseType);
            info.name = LicenseManagementService.getLicenseTypeName(licenseType);
            info.totalNrOfSeats = LicenseManagementService.getTotalNumberOfSeats(licenseType);
            return info;
        } catch (Exception ex) {
            ErrorLogUtil.logException(ex, true);
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static User[] getAssignedUsers(String licenseTypeAPIName, Integer startRow, Integer nrOfRows, List<Ordering> orderings) {
        try {
            LicenseType licenseType = LicenseManagementService.getLicenseTypeByName(licenseTypeAPIName);
            List<fflib_QueryFactory.Ordering> queryOrderings = new List<fflib_QueryFactory.Ordering>();
            for (Ordering ordering : orderings) {
                queryOrderings.add(new fflib_QueryFactory.Ordering(ordering.fieldName, ordering.sortOrder == 'asc' ? fflib_QueryFactory.SortOrder.ASCENDING : fflib_QueryFactory.SortOrder.DESCENDING, false));
            }
            return LicenseManagementService.getAssignedUsersForLicenseType(licenseType, startRow, nrOfRows, queryOrderings);
        } catch (Exception ex) {
            ErrorLogUtil.logException(ex, true);
            throw new AuraHandledException(ex.getMessage());
        }

    }

    @AuraEnabled
    public static User[] getUnAssignedUsers(String licenseTypeAPIName, Integer startRow, Integer nrOfRows, List<Ordering> orderings) {
        try {
            LicenseType licenseType = LicenseManagementService.getLicenseTypeByName(licenseTypeAPIName);
            List<fflib_QueryFactory.Ordering> queryOrderings = new List<fflib_QueryFactory.Ordering>();
            for (Ordering ordering : orderings) {
                queryOrderings.add(new fflib_QueryFactory.Ordering(ordering.fieldName, ordering.sortOrder == 'asc' ? fflib_QueryFactory.SortOrder.ASCENDING : fflib_QueryFactory.SortOrder.DESCENDING, false));
            }
            return LicenseManagementService.getUnAssignedUsersForLicenseType(licenseType, startRow, nrOfRows, queryOrderings);
        } catch (Exception ex) {
            ErrorLogUtil.logException(ex, true);
            throw new AuraHandledException(ex.getMessage());
        }

    }

    @AuraEnabled(Cacheable=true)
    public static Integer getUnAssignedUserCount(String licenseTypeAPIName) {
        try {
            LicenseType licenseType = LicenseManagementService.getLicenseTypeByName(licenseTypeAPIName);
            return LicenseManagementService.getUnAssignedUsersForLicenseTypeCount(licenseType);
        } catch (Exception ex) {
            ErrorLogUtil.logException(ex, true);
            throw new AuraHandledException(ex.getMessage());
        }

    }

    @AuraEnabled
    public static void assignUsers(String licenseTypeAPIName, List<Id> usersToAssign) {
        try {
            LicenseType licenseType = LicenseManagementService.getLicenseTypeByName(licenseTypeAPIName);
            List<User> users = new List<User>();
            for (Id id : usersToAssign) {
                users.add(new User(Id = id));
            }
            LicenseManagementService.assignLicenseType(licenseType, users);
        } catch (Exception ex) {
            ErrorLogUtil.logException(ex, true);
            throw new AuraHandledException(ex.getMessage());
        }

    }

    @AuraEnabled
    public static void unAssignUsers(String licenseTypeAPIName, List<Id> usersToUnAssign) {
        try {
            LicenseType licenseType = LicenseManagementService.getLicenseTypeByName(licenseTypeAPIName);
            List<User> users = new List<User>();
            for (Id id : usersToUnAssign) {
                users.add(new User(Id = id));
            }
            LicenseManagementService.unassignLicenseType(licenseType, users);
        } catch (Exception ex) {
            ErrorLogUtil.logException(ex, true);
            throw new AuraHandledException(ex.getMessage());
        }

    }

}