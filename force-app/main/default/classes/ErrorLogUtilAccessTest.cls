/**
 * Created by jaapbranderhorst on 02/07/2020.
 */

@IsTest
private class ErrorLogUtilAccessTest {
    @IsTest
    static void testBehavior() {
        Test.startTest();
        {
            System.runAs(CompanyInfoTestUserFactory.getDutchBusinessUser()) {
                ErrorLogUtil.logException(new CustomException('test'));
            }
        }
        Test.stopTest();
        List<Error_Log__c> errorLogs = new List<Error_Log__c>();
        errorLogs = [
                SELECT
                        Cause__c,
                        Error_Email_Address__c,
                        Line_Number__c,
                        Message__c,
                        Send_Email__c,
                        Stacktrace__c,
                        Type__c,
                        CreatedById,
                        CreatedDate,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        LastReferencedDate,
                        LastViewedDate,
                        Name,
                        OwnerId,
                        SystemModstamp
                FROM Error_Log__c];
        System.assertEquals(1, errorLogs.size());
        System.assertEquals('test', errorLogs.get(0).Message__c);
    }
}