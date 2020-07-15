/**
 * Created by hugovankrimpen on 01/07/2020.
 */

@IsTest
public class SepaMatchAccountHolderInvocableTest {

    @IsTest
    public static void testHappyFlow() {
        SepaServiceImplTest.initMocks();
        System.runAs(TestUtils.getSEPAUser()){
            appsolutely.SepaMatchAccountHolderInvocable.SepaMatchAccountHolderArgument arg1 = new appsolutely.SepaMatchAccountHolderInvocable.SepaMatchAccountHolderArgument(SepaServiceImplTest.NP_NAME_MATCHED, SepaServiceImplTest.IBAN_NUMBER_SUCCESS_NP);
            appsolutely.SepaMatchAccountHolderInvocable.SepaMatchAccountHolderArgument arg2 = new appsolutely.SepaMatchAccountHolderInvocable.SepaMatchAccountHolderArgument(SepaServiceImplTest.ORG_NAME_MISTYPE, SepaServiceImplTest.IBAN_NUMBER_SUCCESS_ORG);
            List<appsolutely.SepaMatchAccountHolderInvocable.SepaMatchAccountHolderArgument> arguments = new List<appsolutely.SepaMatchAccountHolderInvocable.SepaMatchAccountHolderArgument>{arg1, arg2};

            Test.startTest();
            List<SEPA_Bank_Account__c> bankAccounts = SepaMatchAccountHolderInvocable.validateAccountHolderWithIBANNumber(arguments);
            Test.stopTest();

            System.assertEquals(2, bankAccounts.size());
        }
    }
    @IsTest
    public static void testUnhappyFlow() {
        SepaServiceImplTest.initMocks();
        System.runAs(TestUtils.getSEPAUser()){
            appsolutely.SepaMatchAccountHolderInvocable.SepaMatchAccountHolderArgument arg1 = new appsolutely.SepaMatchAccountHolderInvocable.SepaMatchAccountHolderArgument(SepaServiceImplTest.NP_NAME_NOT_MATCHED, SepaServiceImplTest.IBAN_NUMBER_ERROR);
            appsolutely.SepaMatchAccountHolderInvocable.SepaMatchAccountHolderArgument arg2 = new appsolutely.SepaMatchAccountHolderInvocable.SepaMatchAccountHolderArgument(SepaServiceImplTest.NP_NAME_MISTYPE, SepaServiceImplTest.IBAN_NUMBER_SUCCESS_NP);
            List<appsolutely.SepaMatchAccountHolderInvocable.SepaMatchAccountHolderArgument> arguments = new List<appsolutely.SepaMatchAccountHolderInvocable.SepaMatchAccountHolderArgument>{arg1, arg2};

            Test.startTest();
            List<SEPA_Bank_Account__c> bankAccounts = SepaMatchAccountHolderInvocable.validateAccountHolderWithIBANNumber(arguments);
            Test.stopTest();

            System.assertEquals(0, bankAccounts.size());
        }
    }

    @IsTest
    public static void testIncorrectInputFlow() {
        SepaServiceImplTest.initMocks();
        System.runAs(TestUtils.getSEPAUser()){
            appsolutely.SepaMatchAccountHolderInvocable.SepaMatchAccountHolderArgument arg1 = new appsolutely.SepaMatchAccountHolderInvocable.SepaMatchAccountHolderArgument(null, null);
            List<appsolutely.SepaMatchAccountHolderInvocable.SepaMatchAccountHolderArgument> arguments = new List<appsolutely.SepaMatchAccountHolderInvocable.SepaMatchAccountHolderArgument>{arg1};

            Test.startTest();
            try {
                List<SEPA_Bank_Account__c> bankAccounts = SepaMatchAccountHolderInvocable.validateAccountHolderWithIBANNumber(arguments);
                System.assert(false);
            }catch (Exception e){
                System.assert(true);
            }
            Test.stopTest();
        }
    }
    @IsTest
    public static void testNoAccessFlow() {
        SepaServiceImplTest.initMocks();
        //Run as dutch business user without SEPA permset
        System.runAs(TestUtils.getDutchBusinessUser()){
            appsolutely.SepaMatchAccountHolderInvocable.SepaMatchAccountHolderArgument arg1 = new appsolutely.SepaMatchAccountHolderInvocable.SepaMatchAccountHolderArgument(SepaServiceImplTest.NP_NAME_MATCHED, SepaServiceImplTest.IBAN_NUMBER_SUCCESS_NP);
            appsolutely.SepaMatchAccountHolderInvocable.SepaMatchAccountHolderArgument arg2 = new appsolutely.SepaMatchAccountHolderInvocable.SepaMatchAccountHolderArgument(SepaServiceImplTest.ORG_NAME_MISTYPE, SepaServiceImplTest.IBAN_NUMBER_SUCCESS_ORG);
            List<appsolutely.SepaMatchAccountHolderInvocable.SepaMatchAccountHolderArgument> arguments = new List<appsolutely.SepaMatchAccountHolderInvocable.SepaMatchAccountHolderArgument>{arg1, arg2};

            Test.startTest();
            try {
                List<SEPA_Bank_Account__c> bankAccounts = SepaMatchAccountHolderInvocable.validateAccountHolderWithIBANNumber(arguments);
                System.assert(false);
            }catch (FeatureAccessException featureAccessException){
                System.assert(true);
            }catch (Exception ex){
                System.assert(false);
            }
            Test.stopTest();
        }
    }
}