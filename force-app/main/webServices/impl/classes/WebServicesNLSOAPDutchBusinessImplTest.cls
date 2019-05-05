@isTest
public with sharing class WebServicesNLSOAPDutchBusinessImplTest {

@isTest
    public static void testDutchBusinessGetDossier(){
        //DutchBusinessDto.DutchBusinessGetDossierRequest params

        Credentials__c CS = Credentials__c.getOrgDefaults();
        cs.Username__c = 'mock';
        cs.Password__c = 'mock';
        insert cs;
        Test.setMock(WebServiceMock.class, new dutchBusinessGetDossierV3SuccessMockImpl());
   
    Test.startTest();
        IWebServicesNLSOAPDutchBusiness service = WebServicesNLSOAPDutchBusiness.newInstance();
        DutchBusinessDto.DutchBusinessGetDossierResponse response = service.dutchBusinessGetDossier(new DutchBusinessDto.DutchBusinessGetDossierRequest());
        Test.stopTest();
        system.assertEquals(response.continuation_date.day(),1);

    }

@isTest
    public static void  testDutchBusinessSearchParameters(){
        //DutchBusinessDto.DutchBusinessSearchParametersResponse
        //DutchBusinessDto.DutchBusinessSearchParametersRequest

        Credentials__c CS = Credentials__c.getOrgDefaults();
        cs.Username__c = 'mock';
        cs.Password__c = 'mock';
        insert cs;
        Test.setMock(WebServiceMock.class, new dutchBusinessSearchParametersV2SuccessMockImpl());
   
    Test.startTest();
        IWebServicesNLSOAPDutchBusiness service = WebServicesNLSOAPDutchBusiness.newInstance();
        DutchBusinessDto.DutchBusinessSearchParametersResponse response = service.dutchBusinessSearchParameters(new DutchBusinessDto.DutchBusinessSearchParametersRequest());
        Test.stopTest();
        //system.assertEquals(response.continuation_date.day(),1);

    }



// mocks
public class dutchBusinessSearchParametersV2SuccessMockImpl implements WebServiceMock {
    public void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
               
            WebServicesNLSOAPDutchBusinessImplTypes.dutchBusinessSearchParametersV2ResponseType resp = new WebServicesNLSOAPDutchBusinessImplTypes.dutchBusinessSearchParametersV2ResponseType();
            resp.out = new WebServicesNLSOAPDutchBusinessImplTypes.DutchBusinessReferenceV2PagedResult();
            resp.out.paging = new WebServicesNLSOAPDutchBusinessImplTypes.ResultInfo();
            resp.out.results = new WebServicesNLSOAPDutchBusinessImplTypes.DutchBusinessReferenceV2Array();
            resp.out.results.item = new list<WebServicesNLSOAPDutchBusinessImplTypes.DutchBusinessReferenceV2>();
            resp.out.results.item.add(new WebServicesNLSOAPDutchBusinessImplTypes.DutchBusinessReferenceV2());
            response.put( 'response_x', resp);   
   }
}
public class dutchBusinessGetDossierV3SuccessMockImpl implements WebServiceMock {
    public void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
               
            WebServicesNLSOAPDutchBusinessImplTypes.dutchBusinessGetDossierV3ResponseType resp = new WebServicesNLSOAPDutchBusinessImplTypes.dutchBusinessGetDossierV3ResponseType();
            WebServicesNLSOAPDutchBusinessImplTypes.DutchBusinessDossierV3 dossier = new WebServicesNLSOAPDutchBusinessImplTypes.DutchBusinessDossierV3();
            resp.out = dossier;
            WebServicesNLSOAPDutchBusinessImplTypes.DutchBusinessDateV3 dt = new WebServicesNLSOAPDutchBusinessImplTypes.DutchBusinessDateV3();
            dt.year = 2001;
            dt.month = 1;
            dt.day = 1;
            resp.out.continuation_date = dt;
            response.put( 'response_x', resp);   
   }
}
public class CalloutFailureMockImpl implements WebServiceMock {
    public void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType) {
            CalloutException e = new CalloutException();
            throw e;
        }
}



}
