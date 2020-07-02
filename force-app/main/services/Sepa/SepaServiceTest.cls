/**
 * Created by Hugo on 02/07/2020.
 */


@IsTest
public with sharing class SepaServiceTest {

    private final static String IBAN_NUMBER_SUCCESS = '123';
    private final static String IBAN_NUMBER_ERROR = '999';

    private final static String NP_NAME_MATCHED = 'Smit';
    private final static String NP_NAME_MISTYPE = 'Smi';
    private final static String NP_NAME_NOT_MATCHED = 'Bakker';

    private final static String ORG_NAME_MISTYPE = 'Appsolutel';
    private final static String ORG_NAME_SUGGESTION = 'Appsolutely';

    enum MatchingType{
        MATCHING,
        NOT_MATCHING,
        MISTYPE
    }
    enum AccountHolderType{
        NP,
        ORG,
        UNKNOWN
    }

    @IsTest
    public static  void testMatchBankAccountMatching(){
        initMocks();

        Test.startTest();
        SEPA_Bank_Account__c sepaBankAccount = SepaService.getSepaMatchAccountHolder(IBAN_NUMBER_SUCCESS, NP_NAME_MATCHED);
        Test.stopTest();

        //Match should be stored
        System.assertNotEquals(null, sepaBankAccount);
        //With the following fields:
        System.assertEquals(IBAN_NUMBER_SUCCESS, sepaBankAccount.Name);
        System.assertEquals(true, sepaBankAccount.Active__c);
        System.assertEquals(false, sepaBankAccount.Foreign__c);
    }
    @IsTest
    public static  void testMatchBankAccountNotMatching(){
        initMocks();

        Test.startTest();
        SEPA_Bank_Account__c sepaBankAccount = SepaService.getSepaMatchAccountHolder(IBAN_NUMBER_SUCCESS, NP_NAME_NOT_MATCHED);
        Test.stopTest();


        //No match is not stored
        System.assertEquals(null, sepaBankAccount);
    }
    @IsTest
    public static  void testMatchBankAccountNaturalPersonMistype(){
        initMocks();

        Test.startTest();
        SEPA_Bank_Account__c sepaBankAccount = SepaService.getSepaMatchAccountHolder(IBAN_NUMBER_SUCCESS, NP_NAME_MISTYPE);
        Test.stopTest();

        //Natural Person Mistype is not stored
        System.assertEquals(null, sepaBankAccount);
    }
    @IsTest
    public static  void testMatchBankAccountOrganizationMistype(){
        initMocks();

        Test.startTest();
        SEPA_Bank_Account__c sepaBankAccount = SepaService.getSepaMatchAccountHolder(IBAN_NUMBER_SUCCESS, ORG_NAME_MISTYPE);
        Test.stopTest();

        //Org Person Mistype is stored
        System.assertNotEquals(null, sepaBankAccount);
        //With the following fields:
        System.assertEquals(IBAN_NUMBER_SUCCESS, sepaBankAccount.Name);
    }
    @IsTest
    public static  void testMatchBankAccountIncorrectInput(){
        initMocks();

        Test.startTest();
        try {
            SEPA_Bank_Account__c sepaBankAccount = SepaService.getSepaMatchAccountHolder(null, null);
            System.assert(false);
        }catch (Exception e){
            System.assert(true);
        }
        Test.stopTest();
    }
    @IsTest
    public static  void testSaveResponse(){
        initMocks();
        Test.startTest();
        try {
            SEPA_Bank_Account__c sepaBankAccount = SepaService.getSepaMatchAccountHolder(IBAN_NUMBER_SUCCESS, NP_NAME_MATCHED);
            SepaService.saveSEPABankAccounts(new List<SEPA_Bank_Account__c>{sepaBankAccount});
            //Saving twice to cover all scenarios
            SepaService.saveSEPABankAccounts(new List<SEPA_Bank_Account__c>{sepaBankAccount});
        }
        catch (Exception e){
            System.assert(false, 'Saving SEPA response threw an error:' + e.getMessage());
        }
        Test.stopTest();
    }

    private static void initMocks(){
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsSepa mockWS = (IWsSepa)mocks.mock(IWsSepa.class);
        mocks.startStubbing();

        mocks.when(mockWS.sepaMatchAccountHolder(IBAN_NUMBER_SUCCESS, NP_NAME_MATCHED)).thenReturn(createStubObject(MatchingType.MATCHING, AccountHolderType.NP));
        mocks.when(mockWS.sepaMatchAccountHolder(IBAN_NUMBER_SUCCESS, NP_NAME_NOT_MATCHED)).thenReturn(createStubObject(MatchingType.NOT_MATCHING, AccountHolderType.NP));
        mocks.when(mockWS.sepaMatchAccountHolder(IBAN_NUMBER_SUCCESS, NP_NAME_MISTYPE)).thenReturn(createStubObject(MatchingType.MISTYPE, AccountHolderType.NP));
        mocks.when(mockWS.sepaMatchAccountHolder(IBAN_NUMBER_SUCCESS, ORG_NAME_MISTYPE)).thenReturn(createStubObject(MatchingType.MISTYPE, AccountHolderType.ORG));
        mocks.when(mockWS.sepaMatchAccountHolder(null, null)).thenThrow(new CalloutException());

        mocks.stopStubbing();

        Application.Service.setMock(IWsSepa.class, mockWS);
    }


    private static SepaWsdl.SepaMatchAccountHolderResult createStubObject(MatchingType matching_type, AccountHolderType account_holder_type){
        if(matching_type == MatchingType.MISTYPE){
            return createMistypeStubObject(matching_type,account_holder_type);
        }
        else if(matching_type == MatchingType.NOT_MATCHING){
            return createNotMatchingStubObject(matching_type);
        }
        return createMatchingStubObject(matching_type,account_holder_type);
    }
    private static SepaWsdl.SepaMatchAccountHolderResult createMatchingStubObject(MatchingType matching_type, AccountHolderType account_holder_type){
        SepaWsdl.SepaMatchAccountHolderResult result = new SepaWsdl.SepaMatchAccountHolderResult();
        result.iban = IBAN_NUMBER_SUCCESS;
        result.iban_found = true;
        result.bank_account_details = createBankAccountDetails();
        result.bank_account_holder = createBankAccountHolder(account_holder_type);
        result.name_matching_result = createMatchingResult(matching_type);
        return result;
    }
    private static SepaWsdl.SepaMatchAccountHolderResult createNotMatchingStubObject(MatchingType matching_type){
        SepaWsdl.SepaMatchAccountHolderResult result = new SepaWsdl.SepaMatchAccountHolderResult();
        result.iban = IBAN_NUMBER_ERROR;
        result.iban_found = false;
        result.bank_account_details = createBankAccountDetails();
        result.name_matching_result = createMatchingResult(matching_type);
        return result;
    }
    private static SepaWsdl.SepaMatchAccountHolderResult createMistypeStubObject(MatchingType matching_type, AccountHolderType account_holder_type){
        SepaWsdl.SepaMatchAccountHolderResult result = new SepaWsdl.SepaMatchAccountHolderResult();
        result.iban = IBAN_NUMBER_SUCCESS;
        result.iban_found = false;
        result.bank_account_details = createBankAccountDetails();
        result.bank_account_holder = createBankAccountHolder(account_holder_type);
        result.name_matching_result = createMatchingResult(matching_type);
        return result;
    }
    private static SepaWsdl.SepaMatchBankAccountHolder createBankAccountHolder(AccountHolderType account_holder_type){
        SepaWsdl.SepaMatchBankAccountHolder sepaMatchBankAccountHolder = new SepaWsdl.SepaMatchBankAccountHolder();
        sepaMatchBankAccountHolder.joint_account = false;
        sepaMatchBankAccountHolder.number_of_account_holders = 1;
        sepaMatchBankAccountHolder.type_x = String.valueOf(account_holder_type);
        if(account_holder_type == AccountHolderType.ORG){
            sepaMatchBankAccountHolder.municipality = 'a';
        }
        return sepaMatchBankAccountHolder;
    }
    private static SepaWsdl.SepaMatchBankAccountDetails createBankAccountDetails(){
        SepaWsdl.SepaMatchBankAccountDetails sepaMatchBankAccountDetails = new SepaWsdl.SepaMatchBankAccountDetails();
        sepaMatchBankAccountDetails.foreign = false;
        sepaMatchBankAccountDetails.country_code = 'NL';
        sepaMatchBankAccountDetails.status = 'ACTIVE';
        return sepaMatchBankAccountDetails;
    }
    private static SepaWsdl.SepaMatchNameMatchingResult createMatchingResult(MatchingType matching_type){
        SepaWsdl.SepaMatchNameMatchingResult sepaMatchNameMatchingResult = new SepaWsdl.SepaMatchNameMatchingResult();
        sepaMatchNameMatchingResult.type_x = String.valueOf(matching_type);
        if(matching_type == MatchingType.MISTYPE){
            sepaMatchNameMatchingResult.name_suggestion = ORG_NAME_SUGGESTION;
        }
        return sepaMatchNameMatchingResult;
    }

}