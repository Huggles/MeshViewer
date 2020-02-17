/**
 * Created by tejaswinidandi on 11/02/2020.
 */

global with sharing class GetCreditsafeFullReportInvocable {

    global inherited sharing class CreditsafeReportParameters {
        @InvocableVariable(label = 'Company Id')
        global String companyId;
        @InvocableVariable(label = 'Language')
        global String language;
        @InvocableVariable(label = 'Reason')
        global String reason;
    }

    @InvocableMethod
    global static List<Creditsafe_Company_Report_Full__c> getCreditsafeCompanyReportFull(List<CreditsafeReportParameters> inputParameters) {
        try {
            List<Creditsafe_Company_Report_Full__c> companyReportFulls = new List<Creditsafe_Company_Report_Full__c>();
            for (CreditsafeReportParameters parameter : inputParameters) {
                Creditsafe_Company_Report_Full__c report = CreditSafeService.getCreditsafeReportFullV2(parameter.companyId, parameter.language, parameter.reason);
                companyReportFulls.add(report);
            }
            return companyReportFulls;

        }catch (Exception ex) {
            ErrorLogUtil.logException(ex);
            return null;
        }
    }
}