/**
 * Created by jaapbranderhorst on 17/05/2020.
 */

public without sharing class EnforceLicensesSchedulable implements Schedulable{

    private class LicenseTypeInfo {

        private LicenseType licenseType { get; set; }

        Integer totalNrOfSeats {
            get {
                if (totalNrOfSeats == null) {
                    totalNrOfSeats = LicenseManagementService.getTotalNumberOfSeats(this.licenseType);
                }
                return totalNrOfSeats;
            }
            set;
        }

        Integer assignedNrOfSeats {
            get {
                if (assignedNrOfSeats == null) {
                    assignedNrOfSeats = LicenseManagementService.getAssignedUsersForLicenseType(this.licenseType).size();
                }
                return assignedNrOfSeats;
            }
            set;
        }

        Boolean isCompliant {
            get {
                return totalNrOfSeats >= assignedNrOfSeats;
            }
        }

        LicenseTypeInfo(LicenseType licenseType) {
            this.licenseType = licenseType;
        }
    }

    @TestVisible
    private final static String ERROR_LOG_SETTING_EMAIL = 'Error_Email_Address';

    private static String supportEmailAddress {
        get {
            if (String.isEmpty(supportEmailAddress)) {
                supportEmailAddress = SettingUtils.getSetting(ERROR_LOG_SETTING_EMAIL);
            }
            return supportEmailAddress;
        }
        set;
    }

    public void execute(SchedulableContext param1) {
        doWork();
    }

    @TestVisible
    private void doWork() {
        LicenseType[] licenseTypes = LicenseType.values();
        LicenseTypeInfo[] nonCompliantLicenseTypeInfos = new List<LicenseTypeInfo>();
        for (LicenseType licenseType : licenseTypes) {
            if (!licenseType.name().startsWith('TEST')) {
                // TODO: make this bulkified. Since the number of license types is very low, this will work.
                LicenseTypeInfo licenseTypeInfo = new LicenseTypeInfo(licenseType);
                if (!licenseTypeInfo.isCompliant) {
                    nonCompliantLicenseTypeInfos.add(licenseTypeInfo);
                }
            }
        }
        if (nonCompliantLicenseTypeInfos.size() > 0) {
            sendNoncomplianceMessage(nonCompliantLicenseTypeInfos);
        }


    }

    private void sendNoncomplianceMessage(LicenseTypeInfo[] nonCompliantLicenseTypeInfos) {
        fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance(); // to make it easier to test
        List<String> messages = new List<String>();
        messages.add('Contract breach for the following license types:');
        for (LicenseTypeInfo licenseTypeInfo : nonCompliantLicenseTypeInfos) {
            messages.add(LicenseManagementService.getLicenseTypeName(licenseTypeInfo.licenseType));
            messages.add('Purchased number of seats: ' + licenseTypeInfo.totalNrOfSeats);
            messages.add('Assigned number of seats: ' + licenseTypeInfo.assignedNrOfSeats);
            messages.add('/n');
        }
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {supportEmailAddress});
        mail.setSubject('CONTRACT BREACH for Company.info in Salesforce. Org Id ' + UserInfo.getOrganizationId() + ' with Org Name ' + UserInfo.getOrganizationName());
        mail.setPlainTextBody(messages.toString());
        unitOfWork.registerEmail(mail);
        unitOfWork.commitWork();
    }


}