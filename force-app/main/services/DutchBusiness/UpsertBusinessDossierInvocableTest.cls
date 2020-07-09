/**
 * Created by hugovankrimpen on 08/07/2020.
 */

@IsTest
public with sharing class UpsertBusinessDossierInvocableTest {

    @IsTest
    static void testCreateDutchDossierInvocableHappyFlow() {
        // given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsDutchBusiness dutchBusinessWsServiceMock = (IWsDutchBusiness)mocks.mock(IWsDutchBusiness.class);

        mocks.startStubbing();

        fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.newInstance();
        Account a = new Account();
        a.Name = 'abc';
        String dossierNumber1 = '5678';
        String establishmentNUmber1 = '1234';

        DutchBusinessWsdl.DutchBusinessDossierV3 dossierWSDL = new DutchBusinessWsdl.DutchBusinessDossierV3();
        dossierWSDL.dossier_number  = dossierNumber1;
        dossierWSDL.establishment_number  = establishmentNUmber1;


        mocks.when(WsDutchBusiness.dutchBusinessGetDossierV3(dossierNumber1, establishmentNUmber1)).thenReturn(dossierWSDL);
        mocks.stopStubbing();

        Application.Service.setMock(IWsDutchBusiness.class, dutchBusinessWsServiceMock);

        // when
        List<UpsertBusinessDossierInvocable.UpsertBusinessDossierArgument> arguments = new List<UpsertBusinessDossierInvocable.UpsertBusinessDossierArgument>();
        arguments.add(new UpsertBusinessDossierInvocable.UpsertBusinessDossierArgument(dossierNumber1, establishmentNUmber1, false, a));

        Test.startTest();
        List<Business_Dossier__c> dossiers = UpsertBusinessDossierInvocable.upsertBusinessDossier(arguments);
        Test.stopTest();

    }

}