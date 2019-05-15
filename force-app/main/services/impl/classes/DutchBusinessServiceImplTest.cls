@isTest
public with sharing class DutchBusinessServiceImplTest {
    
@isTest
public static void testGetDossierAccount(){
    fflib_ApexMocks mocks = new fflib_ApexMocks();
    //fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);
    //IWebServicesNLSOAPDutchBusiness mockWS = (IWebServicesNLSOAPDutchBusiness)mocks.mock(IWebServicesNLSOAPDutchBusiness.class);
    IDutchBusinessDossierSelector selectorMockDossier = (IDutchBusinessDossierSelector)mocks.mock(IDutchBusinessDossierSelector.class);// new Mocks.DutchBusinessDossierSelector(mocks);
    IAccountSelector selectorMockAccount = (IAccountSelector)mocks.mock(IAccountSelector.class); //new Mocks.DutchBusinessDossierSelector(mocks);
// Given
    mocks.startStubbing();
    Integer dossierNumber = 40000000;
    Account acc = new Account(
            Name = 'Test',
            Id = fflib_IDGenerator.generate(Account.SObjectType)
        );
        List<Dutch_Business_Dossier__c> dossierList = new List<Dutch_Business_Dossier__c> {
            new Dutch_Business_Dossier__c(
                Id = fflib_IDGenerator.generate(Dutch_Business_Dossier__c.SObjectType),
                Name = 'Test',
                Dossier_Number__c = dossierNumber,
                Account__c = acc.Id
            )
        };
        mocks.when(selectorMockDossier.sObjectType()).thenReturn(Dutch_Business_Dossier__c.SObjectType);
        mocks.when(selectorMockDossier.selectByDossierNumber(new set<Integer>{dossierNumber})).thenReturn(dossierList);
        mocks.when(selectorMockAccount.sObjectType()).thenReturn(Account.SObjectType);
        mocks.when(selectorMockAccount.selectById(new set<Id>{acc.Id})).thenReturn(new list<Account>{acc});
        mocks.stopStubbing();
        //Application.UnitOfWork.setMock(uowMock);
        Application.Selector.setMock(selectorMockAccount);
        Application.Selector.setMock(selectorMockDossier);
        //Application.service.setMock(IWebServicesNLSOAPDutchBusiness.class, mockWS);
        test.startTest();
        //IDutchBusinessService service = DutchBusinessService.newInstance();
        Account result = DutchBusinessService.getDossierAccount(String.valueOf(dossierNumber));
        system.assertEquals(acc.Id, result.Id);
}


}
