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

        @TestVisible
        private CreditsafeReportParameters(String companyId, String language, String reason) {
            this.companyId = companyId;
            this.language = language;
            this.reason = reason;
        }
        global CreditsafeReportParameters(){}

    }

    @InvocableMethod(label='Get Creditsafe Report' description='Get Creditsafe Report by company Id' category='Company.info')
    global static List<Creditsafe_Company_Report_Full__c> getCreditsafeCompanyReportFull(List<CreditsafeReportParameters> inputParameters) {

        List<Creditsafe_Company_Report_Full__c> companyReportFulls = new List<Creditsafe_Company_Report_Full__c>();
        for (CreditsafeReportParameters parameter : inputParameters) {
            Creditsafe_Company_Report_Full__c report = CreditSafeService.getCreditsafeReportFullV2(parameter.companyId, parameter.language, parameter.reason);
            companyReportFulls.add(report);
        }
        return companyReportFulls;
    }
}