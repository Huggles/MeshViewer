/**
 * Created by tejaswinidandi on 19/03/2020.
 */

@IsTest
private class SearchForDutchDossiersInvocableTest {
    @IsTest
    static void testSearchForDutchDossiers() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsDutchBusiness mockWS = (IWsDutchBusiness)mocks.mock(IWsDutchBusiness.class);

        mocks.startStubbing();
        DutchBusinessWsdl.DutchBusinessEstablishmentReferencePagedResult resultPage1 = new DutchBusinessWsdl.DutchBusinessEstablishmentReferencePagedResult();
        resultPage1.paging = new DutchBusinessWsdl.ResultInfo();
        resultPage1.paging.curpage = 1;
        resultPage1.paging.numpages = 1;
        resultPage1.paging.perpage = 20;
        resultPage1.paging.numresults = 30;
        resultPage1.paging.maxresults = 500;
        resultPage1.results = new DutchBusinessWsdl.DutchBusinessEstablishmentReferenceArray();

        List<DutchBusinessWsdl.DutchBusinessEstablishmentReference> establishmentReferences= new List<DutchBusinessWsdl.DutchBusinessEstablishmentReference>();
        for (Integer i = 0; i < resultPage1.paging.numresults; i++) {
            DutchBusinessWsdl.DutchBusinessEstablishmentReference establishmentReference = new DutchBusinessWsdl.DutchBusinessEstablishmentReference();
            establishmentReference.dossier_number = 'dossier_number' + i;
            establishmentReference.indication_main_establishment = true;
            establishmentReference.trade_name = 'trade_name' + i;
            establishmentReference.legal_name = 'legal_name' + i;
            establishmentReference.correspondence_street = 'correspondence_street' + i;
            establishmentReference.correspondence_city = 'correspondence_city' + i;
            establishmentReference.establishment_street = 'establishment_street' + i;
            establishmentReference.establishment_city = 'establishment_city' + i;
            establishmentReference.match_type = 'match_type' + i;
            establishmentReference.establishment_number = 'establishment_number' + i;
            establishmentReferences.add(establishmentReference);
        }
        resultPage1.results.item = new List<DutchBusinessWsdl.DutchBusinessEstablishmentReference>();
        for (Integer i = 0; i < 20; i++) {
            resultPage1.results.item.add(establishmentReferences[i]);
        }
        mocks.when(mockWS.dutchBusinessSearch('1', 'trade_name', 'city', 'street', '1231', 1, 'a', '123123123', 'domain', true, 1)).thenReturn(resultPage1);

        mocks.stopStubbing();

        Application.Service.setMock(IWsDutchBusiness.class, mockWS);

        Test.startTest();
        List<SearchForDutchDossiersInvocable.SearchForDutchDossiersArgument> arguments = new List<SearchForDutchDossiersInvocable.SearchForDutchDossiersArgument>();
        SearchForDutchDossiersInvocable.SearchForDutchDossiersArgument argument = new SearchForDutchDossiersInvocable.SearchForDutchDossiersArgument();
        argument.street = 'street';
        argument.city = 'city';
        argument.house_number = 1;
        argument.telephone_number = '123123123';
        argument.domain_name = 'domain';
        argument.dossier_number = '1';
        argument.house_number_addition = 'a';
        argument.postcode = '1231';
        argument.strictSearch = true;
        argument.trade_name = 'trade_name';
        arguments.add(argument);
        List<List<Business_Dossier__c>> dossiers = SearchForDutchDossiersInvocable.searchForDutchDossiers(arguments);
        Test.stopTest();

        System.assert(dossiers.size() == 1);
        System.debug(dossiers[0].size());
        System.assert(dossiers[0].size() == 20);
        for (Business_Dossier__c businessDossier : dossiers[0]) {
            System.assert(businessDossier.Dossier_Number__c.startsWith('dossier_number'));
            System.assert(businessDossier.Indication_Main_Establishment__c = true);
            System.assert(businessDossier.Correspondence_Street__c.startsWith('correspondence_street'));
            System.assert(businessDossier.Correspondence_City__c.startsWith('correspondence_city'));
            System.assert(businessDossier.Establishment_Street__c.startsWith('establishment_street'));
            System.assert(businessDossier.Establishment_City__c.startsWith('establishment_city'));
            System.assert(businessDossier.Name.startsWith('legal_name'));
            System.assert(businessDossier.Trade_Name_Full__c.startsWith('trade_name'));
            System.assert(businessDossier.Establishment_Number__c.startsWith('establishment_number'));
        }
    }
}