/**
 * Created by hugovankrimpen on 08/07/2020.
 */

@IsTest
public class InstantiateBusinessDossierInvocableTest {


    @IsTest
    public static void instantiateBusinessDossierHappyFlow(){
        string dossierNumber = '1234';
        string establishmentNumber = '5678';
        initiateMockResponse(dossierNumber, establishmentNumber);

        InstantiateBusinessDossierInvocable.InstantiateBusinessDossierArgument argument = new InstantiateBusinessDossierInvocable.InstantiateBusinessDossierArgument();
        argument.dossierNumber = dossierNumber;
        argument.establishmentNumber = establishmentNumber;

        Test.startTest();
        List<Business_Dossier__c> businessDossiers =
                InstantiateBusinessDossierInvocable.instantiateBusinessDossier(
                        new List<InstantiateBusinessDossierInvocable.InstantiateBusinessDossierArgument>{argument}
                );
        Test.stopTest();
        System.assertNotEquals(null,businessDossiers);
        System.assertEquals(1,businessDossiers.size());
        System.assertNotEquals(null,businessDossiers[0].SBIs__r);
        System.assertEquals(10,businessDossiers[0].SBIs__r.size());
    }
    @IsTest
    public static void instantiateBusinessDossierErrorFlow(){
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsDutchBusiness webserviceMock = (IWsDutchBusiness)mocks.mock(IWsDutchBusiness.class);

        string dossierNumber = '1234';
        string establishmentNumber = '5678';

        mocks.startStubbing();
        mocks.when(webserviceMock.dutchBusinessGetDossierV3(dossierNumber, establishmentNumber)).thenReturn(null);
        mocks.stopStubbing();

        Application.Service.setMock(IWsDutchBusiness.class, webserviceMock);

        InstantiateBusinessDossierInvocable.InstantiateBusinessDossierArgument argument = new InstantiateBusinessDossierInvocable.InstantiateBusinessDossierArgument();
        argument.dossierNumber = dossierNumber;
        argument.establishmentNumber = establishmentNumber;

        Test.startTest();
        try {
            List<Business_Dossier__c> businessDossiers =
                    InstantiateBusinessDossierInvocable.instantiateBusinessDossier(
                            new List<InstantiateBusinessDossierInvocable.InstantiateBusinessDossierArgument>{argument}
                    );
            System.assert(false);
        }catch (Exception e){
            System.assert(true);
        }
    }

    @TestVisible
    private static void initiateMockResponse(String dossierNumber, String establishmentNumber){
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsDutchBusiness webserviceMock = (IWsDutchBusiness)mocks.mock(IWsDutchBusiness.class);



        mocks.startStubbing();
        DutchBusinessWsdl.DutchBusinessDossierV3 dossierWSDL = DutchBusinessServiceImplTest.getDataVendorMockDossier();

        mocks.when(webserviceMock.dutchBusinessGetDossierV3(dossierNumber, establishmentNumber)).thenReturn(dossierWSDL);
        mocks.stopStubbing();

        Application.Service.setMock(IWsDutchBusiness.class, webserviceMock);
    }

}