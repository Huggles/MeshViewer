/**
 * Created by jaapbranderhorst on 2019-07-03.
 */

@IsTest
public class CreditSafeServiceImplTest {

    @IsTest
    static void testSearchForCreditSafeDossiersNoCountries() {
        Boolean exceptionThrown = false;
        Test.startTest();
        {
            try {
                CreditSafeService.searchForCreditSafeDossiers(null, null, null, null, null, null, null, null, null, null, null);
            } catch (Exception ex) {
                System.assert(ex instanceof CCInputException);
                exceptionThrown = true;
            }

        }
        Test.stopTest();
        System.assert(exceptionThrown);
    }

    @IsTest
    static void testSearchForCreditSafeDossiersForNL() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsCreditsafe wsCreditsafeService = (IWsCreditsafe)mocks.mock(IWsCreditsafe.class);

        CreditsafeWsdl.CreditsafeSearchResultV2 searchResultV2 = new CreditsafeWsdl.CreditsafeSearchResultV2();
        searchResultV2.companies = new CreditsafeWsdl.CreditsafeCompanyV2Array();
        searchResultV2.companies.item = new List<CreditsafeWsdl.CreditsafeCompanyV2>();
        for (Integer i = 0; i < 5; i++) {
            CreditsafeWsdl.CreditsafeCompanyV2 company  = new CreditsafeWsdl.CreditsafeCompanyV2();
            company.country = 'NL';
            company.name = '' + i;
            company.registration_number = '123' + i;
            company.address = new CreditsafeWsdl.CreditsafeAddressV2();
            company.address.city = 'Utrecht';
            company.address.street = 'Braillelaan';
            company.address.telephone = '' + i;
            company.address.postal_code = '123' + i;
            company.status = 'status';
            company.trade_names = new CreditsafeWsdl.stringArray();
            company.trade_names.item = new List<String>();
            for (Integer i2 = 0; i2 < 3; i2++) {
                company.trade_names.item.add('' + i + '_' + i2);
            }
            company.id = '' + i;
            company.date_last_account = Datetime.now();
            company.date_last_change = Datetime.now();
            company.office_type = 'Headoffice';
            company.creditsafe_number = '' + i;
            company.vat_numbers = new CreditsafeWsdl.stringArray();
            company.vat_numbers.item = new List<String>();
            for (Integer i3 = 0; i3 < 3; i3++) {
                company.vat_numbers.item.add('' + i + '_' + i3);
            }
            searchResultV2.companies.item.add(company);
        }

        mocks.startStubbing();
        mocks.when(wsCreditsafeService.creditsafeSearchV2(
                (CreditsafeWsdl.stringArray)fflib_Match.anyObject(),
                fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyString(),
                fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyString()
                ,fflib_Match.anyString(),fflib_Match.anyString())).thenReturn(searchResultV2);
        mocks.stopStubbing();

        Application.Service.setMock(IWsCreditsafe.class, wsCreditsafeService);

        Test.startTest();
        {
            List<Business_Dossier__c> dossiers = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'NL'}, 'id', 'status', 'regnr', 'type', 'vat', 'province', 'city', 'street', 'postal_code', 'name');
            System.assert(dossiers.size() == 15);
            for (Business_Dossier__c dossier : dossiers) {
                System.assert(dossier.Name.isNumeric());
                System.assert(dossier.Dossier_Number__c.startsWith('123'));
                System.assert(dossier.Country__c == 'NL');
                System.assert(dossier.Street__c == 'Braillelaan');
                System.assert(dossier.City__c == 'Utrecht');
                System.assert(dossier.Date_of_Last_Account__c != null && dossier.Date_of_Last_Account__c < Datetime.now());
                System.assert(dossier.Date_of_Last_Change__c != null && dossier.Date_of_Last_Change__c < Datetime.now());
                System.assert(dossier.Office_Type__c == 'Headoffice');
                System.assert(dossier.Trade_Names__c != null);
                System.assert(dossier.Telephone_Number__c.isNumeric());
            }

            //test for NLWithCompanyId
            List<Business_Dossier__c> dossiers1 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'NL'}, 'id', '', '', '', '', '', '', '', '', '');
            System.assert(dossiers1.size() == 5);
            for (Business_Dossier__c dossier : dossiers1) {
                System.assert(dossier.Company_Id__c.isNumeric());
            }

            //test for NLWithRegistrationNumber
            List<Business_Dossier__c> dossiers2 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'NL'}, '', '', 'registration_number', '', '', '', '', '', '', '');
            System.assertEquals(dossiers2.size() , 5);
            for (Business_Dossier__c dossier : dossiers2) {
                System.assert(dossier.Dossier_Number__c.startsWith('123'));
            }


            //test for NLWith name, status, street, city, postalcode
            List<Business_Dossier__c> dossiers4 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'NL'}, '', 'status', '', '', '', '', 'city', 'street', 'postal_code', 'name');
            System.assertEquals(dossiers4.size() , 5);
            for (Business_Dossier__c dossier : dossiers4) {
                System.assert(dossier.Name.isNumeric());
                System.assert(dossier.Street__c == 'Braillelaan');
                System.assert(dossier.City__c == 'Utrecht');
            }
        }
        Test.stopTest();
    }

    @IsTest
    static void testSearchForCreditSafeDossiersForBE() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsCreditsafe wsCreditsafeService = (IWsCreditsafe)mocks.mock(IWsCreditsafe.class);

        CreditsafeWsdl.CreditsafeSearchResultV2 searchResultV2 = new CreditsafeWsdl.CreditsafeSearchResultV2();
        searchResultV2.companies = new CreditsafeWsdl.CreditsafeCompanyV2Array();
        searchResultV2.companies.item = new List<CreditsafeWsdl.CreditsafeCompanyV2>();
        for (Integer i = 0; i < 5; i++) {
            CreditsafeWsdl.CreditsafeCompanyV2 company  = new CreditsafeWsdl.CreditsafeCompanyV2();
            company.country = 'BE';
            company.name = '' + i;
            company.registration_number = '123' + i;
            company.address = new CreditsafeWsdl.CreditsafeAddressV2();
            company.address.city = 'Utrecht';
            company.address.street = 'Braillelaan';
            company.address.telephone = '' + i;
            company.address.postal_code = '123' + i;
            company.status = 'status';
            company.trade_names = new CreditsafeWsdl.stringArray();
            company.trade_names.item = new List<String>();
            for (Integer i2 = 0; i2 < 3; i2++) {
                company.trade_names.item.add('' + i + '_' + i2);
            }
            company.id = '' + i;
            company.date_last_account = Datetime.now();
            company.date_last_change = Datetime.now();
            company.office_type = 'Headoffice';
            company.creditsafe_number = '' + i;
            company.vat_numbers = new CreditsafeWsdl.stringArray();
            company.vat_numbers.item = new List<String>();
            for (Integer i3 = 0; i3 < 3; i3++) {
                company.vat_numbers.item.add('' + i + '_' + i3);
            }
            searchResultV2.companies.item.add(company);
        }

        mocks.startStubbing();
        mocks.when(wsCreditsafeService.creditsafeSearchV2(
                (CreditsafeWsdl.stringArray)fflib_Match.anyObject(),
                fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyString(),
                fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyString()
                ,fflib_Match.anyString(),fflib_Match.anyString())).thenReturn(searchResultV2);
        mocks.stopStubbing();

        Application.Service.setMock(IWsCreditsafe.class, wsCreditsafeService);

        Test.startTest();
        {
            List<Business_Dossier__c> dossiers = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'BE'}, 'id', 'status', 'regnr', 'type', 'vat', 'province', 'city', 'street', 'postal_code', 'name');
            System.assert(dossiers.size() == 20);
            for (Business_Dossier__c dossier : dossiers) {
                System.assert(dossier.Name.isNumeric());
                System.assert(dossier.Dossier_Number__c.startsWith('123'));
                System.assert(dossier.Country__c == 'BE');
                System.assert(dossier.Street__c == 'Braillelaan');
                System.assert(dossier.City__c == 'Utrecht');
                System.assert(dossier.Date_of_Last_Account__c != null && dossier.Date_of_Last_Account__c < Datetime.now());
                System.assert(dossier.Date_of_Last_Change__c != null && dossier.Date_of_Last_Change__c < Datetime.now());
                System.assert(dossier.Office_Type__c == 'Headoffice');
                System.assert(dossier.Trade_Names__c != null);
                System.assert(dossier.Telephone_Number__c.isNumeric());
            }

            //test for BEWithCompanyId
            List<Business_Dossier__c> dossiers1 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'BE'}, 'id', '', '', '', '', '', '', '', '', '');
            System.assert(dossiers1.size() == 5);
            for (Business_Dossier__c dossier : dossiers1) {
                System.assert(dossier.Company_Id__c.isNumeric());
            }

            //test for BEWithRegistrationNumber
            List<Business_Dossier__c> dossiers2 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'BE'}, '', '', 'registration_number', '', '', '', '', '', '', '');
            System.assertEquals(dossiers2.size() , 5);
            for (Business_Dossier__c dossier : dossiers2) {
                System.assert(dossier.Dossier_Number__c.startsWith('123'));
            }

            //test for BEWithVATNumber
            List<Business_Dossier__c> dossiers3 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'BE'}, '', '', '', '', 'vat', '', '', '', '', '');
            System.assertEquals(dossiers3.size() , 5);
            for (Business_Dossier__c dossier : dossiers3) {
                System.assert(dossier.VAT_Number__c != null);
            }

            //test for BEWith name, status, street, city, postalcode
            List<Business_Dossier__c> dossiers4 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'BE'}, '', 'status', '', '', '', '', 'city', 'street', 'postal_code', 'name');
            System.assertEquals(dossiers4.size() , 5);
            for (Business_Dossier__c dossier : dossiers4) {
                System.assert(dossier.Name.isNumeric());
                System.assert(dossier.Street__c == 'Braillelaan');
                System.assert(dossier.City__c == 'Utrecht');
            }
        }
        Test.stopTest();
    }
    @IsTest
    static void testSearchForCreditSafeDossiersForDE() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsCreditsafe wsCreditsafeService = (IWsCreditsafe)mocks.mock(IWsCreditsafe.class);

        CreditsafeWsdl.CreditsafeSearchResultV2 searchResultV2 = new CreditsafeWsdl.CreditsafeSearchResultV2();
        searchResultV2.companies = new CreditsafeWsdl.CreditsafeCompanyV2Array();
        searchResultV2.companies.item = new List<CreditsafeWsdl.CreditsafeCompanyV2>();
        for (Integer i = 0; i < 5; i++) {
            CreditsafeWsdl.CreditsafeCompanyV2 company  = new CreditsafeWsdl.CreditsafeCompanyV2();
            company.country = 'DE';
            company.name = '' + i;
            company.registration_number = '123' + i;
            company.address = new CreditsafeWsdl.CreditsafeAddressV2();
            company.address.city = 'Utrecht';
            company.address.street = 'Braillelaan';
            company.address.telephone = '' + i;
            company.address.postal_code = '123' + i;
            company.status = 'status';
            company.trade_names = new CreditsafeWsdl.stringArray();
            company.trade_names.item = new List<String>();
            for (Integer i2 = 0; i2 < 3; i2++) {
                company.trade_names.item.add('' + i + '_' + i2);
            }
            company.id = '' + i;
            company.date_last_account = Datetime.now();
            company.date_last_change = Datetime.now();
            company.office_type = 'Headoffice';
            company.creditsafe_number = '' + i;
            company.vat_numbers = new CreditsafeWsdl.stringArray();
            company.vat_numbers.item = new List<String>();
            for (Integer i3 = 0; i3 < 3; i3++) {
                company.vat_numbers.item.add('' + i + '_' + i3);
            }
            searchResultV2.companies.item.add(company);
        }

        mocks.startStubbing();
        mocks.when(wsCreditsafeService.creditsafeSearchV2(
                (CreditsafeWsdl.stringArray)fflib_Match.anyObject(),
                fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyString(),
                fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyString()
                ,fflib_Match.anyString(),fflib_Match.anyString())).thenReturn(searchResultV2);
        mocks.stopStubbing();

        Application.Service.setMock(IWsCreditsafe.class, wsCreditsafeService);

        Test.startTest();
        {
            List<Business_Dossier__c> dossiers = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'DE'}, 'id', 'status', 'regnr', 'type', 'vat', 'province', 'city', 'street', 'postal_code', 'name');
            System.assert(dossiers.size() == 20);
            for (Business_Dossier__c dossier : dossiers) {
                System.assert(dossier.Name.isNumeric());
                System.assert(dossier.Dossier_Number__c.startsWith('123'));
                System.assert(dossier.Country__c == 'DE');
                System.assert(dossier.Street__c == 'Braillelaan');
                System.assert(dossier.City__c == 'Utrecht');
                System.assert(dossier.Date_of_Last_Account__c != null && dossier.Date_of_Last_Account__c < Datetime.now());
                System.assert(dossier.Date_of_Last_Change__c != null && dossier.Date_of_Last_Change__c < Datetime.now());
                System.assert(dossier.Office_Type__c == 'Headoffice');
                System.assert(dossier.Trade_Names__c != null);
                System.assert(dossier.Telephone_Number__c.isNumeric());
            }

            //test for DEWithCompanyId
            List<Business_Dossier__c> dossiers1 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'DE'}, 'id', '', '', '', '', '', '', '', '', '');
            System.assert(dossiers1.size() == 5);
            for (Business_Dossier__c dossier : dossiers1) {
                System.assert(dossier.Company_Id__c.isNumeric());
            }

            //test for DEWithRegistrationNumber, registration_type, city
            List<Business_Dossier__c> dossiers2 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'DE'}, '', '', 'registration_number', 'registration_type', '', '', 'city', '', '', '');
            System.assertEquals(dossiers2.size() , 10);
            for (Business_Dossier__c dossier : dossiers2) {
                System.assert(dossier.Dossier_Number__c.startsWith('123'));
                System.assert(dossier.City__c == 'Utrecht');
            }

            //test for DEWithVATNumber
            List<Business_Dossier__c> dossiers3 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'DE'}, '', '', '', '', 'vat', '', '', '', '', '');
            System.assertEquals(dossiers3.size() , 5);
            for (Business_Dossier__c dossier : dossiers3) {
                System.assert(dossier.VAT_Number__c != null);
            }

            //test for DEWith name, status, registration_type, street, city, postalcode
            List<Business_Dossier__c> dossiers4 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'DE'}, '', 'status', '', 'registration_type', '', '', 'city', 'street', 'postal_code', 'name');
            System.assertEquals(dossiers4.size() , 5);
            for (Business_Dossier__c dossier : dossiers4) {
                System.assert(dossier.Name.isNumeric());
                System.assert(dossier.Street__c == 'Braillelaan');
                System.assert(dossier.City__c == 'Utrecht');
            }
        }
        Test.stopTest();
    }
    @IsTest
    static void testSearchForCreditSafeDossiersForFR() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsCreditsafe wsCreditsafeService = (IWsCreditsafe)mocks.mock(IWsCreditsafe.class);

        CreditsafeWsdl.CreditsafeSearchResultV2 searchResultV2 = new CreditsafeWsdl.CreditsafeSearchResultV2();
        searchResultV2.companies = new CreditsafeWsdl.CreditsafeCompanyV2Array();
        searchResultV2.companies.item = new List<CreditsafeWsdl.CreditsafeCompanyV2>();
        for (Integer i = 0; i < 5; i++) {
            CreditsafeWsdl.CreditsafeCompanyV2 company  = new CreditsafeWsdl.CreditsafeCompanyV2();
            company.country = 'FR';
            company.name = '' + i;
            company.registration_number = '123' + i;
            company.address = new CreditsafeWsdl.CreditsafeAddressV2();
            company.address.city = 'Utrecht';
            company.address.street = 'Braillelaan';
            company.address.telephone = '' + i;
            company.address.postal_code = '123' + i;
            company.status = 'status';
            company.trade_names = new CreditsafeWsdl.stringArray();
            company.trade_names.item = new List<String>();
            for (Integer i2 = 0; i2 < 3; i2++) {
                company.trade_names.item.add('' + i + '_' + i2);
            }
            company.id = '' + i;
            company.date_last_account = Datetime.now();
            company.date_last_change = Datetime.now();
            company.office_type = 'Headoffice';
            company.creditsafe_number = '' + i;
            company.vat_numbers = new CreditsafeWsdl.stringArray();
            company.vat_numbers.item = new List<String>();
            for (Integer i3 = 0; i3 < 3; i3++) {
                company.vat_numbers.item.add('' + i + '_' + i3);
            }
            searchResultV2.companies.item.add(company);
        }

        mocks.startStubbing();
        mocks.when(wsCreditsafeService.creditsafeSearchV2(
                (CreditsafeWsdl.stringArray)fflib_Match.anyObject(),
                fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyString(),
                fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyString()
                ,fflib_Match.anyString(),fflib_Match.anyString())).thenReturn(searchResultV2);
        mocks.stopStubbing();

        Application.Service.setMock(IWsCreditsafe.class, wsCreditsafeService);

        Test.startTest();
        {
            List<Business_Dossier__c> dossiers = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'FR'}, 'id', 'status', 'regnr', 'type', 'vat', 'province', 'city', 'street', 'postal_code', 'name');
            System.assert(dossiers.size() == 20);
            for (Business_Dossier__c dossier : dossiers) {
                System.assert(dossier.Name.isNumeric());
                System.assert(dossier.Dossier_Number__c.startsWith('123'));
                System.assert(dossier.Country__c == 'FR');
                System.assert(dossier.Street__c == 'Braillelaan');
                System.assert(dossier.City__c == 'Utrecht');
                System.assert(dossier.Date_of_Last_Account__c != null && dossier.Date_of_Last_Account__c < Datetime.now());
                System.assert(dossier.Date_of_Last_Change__c != null && dossier.Date_of_Last_Change__c < Datetime.now());
                System.assert(dossier.Office_Type__c == 'Headoffice');
                System.assert(dossier.Trade_Names__c != null);
                System.assert(dossier.Telephone_Number__c.isNumeric());
            }

            //test for FRWithCompanyId
            List<Business_Dossier__c> dossiers1 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'FR'}, 'id', '', '', '', '', '', '', '', '', '');
            System.assert(dossiers1.size() == 5);
            for (Business_Dossier__c dossier : dossiers1) {
                System.assert(dossier.Company_Id__c.isNumeric());
            }

            //test for FRWithRegistrationNumber, status, postalcode
            List<Business_Dossier__c> dossiers2 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'FR'}, '', 'status', 'registration_number', '', '', '', '', '', 'postal_code', '');
            System.assertEquals(dossiers2.size() , 10);
            for (Business_Dossier__c dossier : dossiers2) {
                System.assert(dossier.Dossier_Number__c.startsWith('123'));
                System.assert(dossier.Postal_Code__c.startsWith('123'));
                System.assert(dossier.Status__c == 'status');
            }

            //test for FRWithVATNumber
            List<Business_Dossier__c> dossiers3 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'FR'}, '', '', '', '', 'vat', '', '', '', '', '');
            System.assertEquals(dossiers3.size() , 5);
            for (Business_Dossier__c dossier : dossiers3) {
                System.assert(dossier.VAT_Number__c != null);
            }

            //test for FRWith name, status, street, city, postalcode
            List<Business_Dossier__c> dossiers4 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'FR'}, '', 'status', '', '', '', '', 'city', 'street', 'postal_code', 'name');
            System.assertEquals(dossiers4.size() , 5);
            for (Business_Dossier__c dossier : dossiers4) {
                System.assert(dossier.Postal_Code__c.startsWith('123'));
                System.assert(dossier.Status__c == 'status');
            }
        }
        Test.stopTest();
    }
    @IsTest
    static void testSearchForCreditSafeDossiersForGB() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsCreditsafe wsCreditsafeService = (IWsCreditsafe)mocks.mock(IWsCreditsafe.class);

        CreditsafeWsdl.CreditsafeSearchResultV2 searchResultV2 = new CreditsafeWsdl.CreditsafeSearchResultV2();
        searchResultV2.companies = new CreditsafeWsdl.CreditsafeCompanyV2Array();
        searchResultV2.companies.item = new List<CreditsafeWsdl.CreditsafeCompanyV2>();
        for (Integer i = 0; i < 5; i++) {
            CreditsafeWsdl.CreditsafeCompanyV2 company  = new CreditsafeWsdl.CreditsafeCompanyV2();
            company.country = 'GB';
            company.name = '' + i;
            company.registration_number = '123' + i;
            company.address = new CreditsafeWsdl.CreditsafeAddressV2();
            company.address.city = 'Utrecht';
            company.address.street = 'Braillelaan';
            company.address.telephone = '' + i;
            company.address.postal_code = '123' + i;
            company.status = 'status';
            company.trade_names = new CreditsafeWsdl.stringArray();
            company.trade_names.item = new List<String>();
            for (Integer i2 = 0; i2 < 3; i2++) {
                company.trade_names.item.add('' + i + '_' + i2);
            }
            company.id = '' + i;
            company.date_last_account = Datetime.now();
            company.date_last_change = Datetime.now();
            company.office_type = 'Headoffice';
            company.creditsafe_number = '' + i;
            company.vat_numbers = new CreditsafeWsdl.stringArray();
            company.vat_numbers.item = new List<String>();
            for (Integer i3 = 0; i3 < 3; i3++) {
                company.vat_numbers.item.add('' + i + '_' + i3);
            }
            searchResultV2.companies.item.add(company);
        }

        mocks.startStubbing();
        mocks.when(wsCreditsafeService.creditsafeSearchV2(
                (CreditsafeWsdl.stringArray)fflib_Match.anyObject(),
                fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyString(),
                fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyString()
                ,fflib_Match.anyString(),fflib_Match.anyString())).thenReturn(searchResultV2);
        mocks.stopStubbing();

        Application.Service.setMock(IWsCreditsafe.class, wsCreditsafeService);

        Test.startTest();
        {
            List<Business_Dossier__c> dossiers = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'GB'}, 'id', 'status', 'regnr', 'type', 'vat', 'province', 'city', 'street', 'postal_code', 'name');
            System.assert(dossiers.size() == 20);
            for (Business_Dossier__c dossier : dossiers) {
                System.assert(dossier.Name.isNumeric());
                System.assert(dossier.Dossier_Number__c.startsWith('123'));
                System.assert(dossier.Country__c == 'GB');
                System.assert(dossier.Street__c == 'Braillelaan');
                System.assert(dossier.City__c == 'Utrecht');
                System.assert(dossier.Date_of_Last_Account__c != null && dossier.Date_of_Last_Account__c < Datetime.now());
                System.assert(dossier.Date_of_Last_Change__c != null && dossier.Date_of_Last_Change__c < Datetime.now());
                System.assert(dossier.Office_Type__c == 'Headoffice');
                System.assert(dossier.Trade_Names__c != null);
                System.assert(dossier.Telephone_Number__c.isNumeric());
            }

            //test for GBWithCompanyId
            List<Business_Dossier__c> dossiers1 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'GB'}, 'id', '', '', '', '', '', '', '', '', '');
            System.assert(dossiers1.size() == 5);
            for (Business_Dossier__c dossier : dossiers1) {
                System.assert(dossier.Company_Id__c.isNumeric());
            }

            //test for GBWithRegistrationNumber
            List<Business_Dossier__c> dossiers2 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'GB'}, '', '', 'registration_number', '', '', '', '', '', '', '');
            System.assertEquals(dossiers2.size() , 5);
            for (Business_Dossier__c dossier : dossiers2) {
                System.assert(dossier.Dossier_Number__c.startsWith('123'));
            }

            //test for GBWithVATNumber
            List<Business_Dossier__c> dossiers3 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'GB'}, '', '', '', '', 'vat', '', '', '', '', '');
            System.assertEquals(dossiers3.size() , 5);
            for (Business_Dossier__c dossier : dossiers3) {
                System.assert(dossier.VAT_Number__c != null);
            }

            //test for GBWith name, registration_type,status, street, city, postalcode
            List<Business_Dossier__c> dossiers4 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'GB'}, '', 'status', '', 'registration_type', '', '', 'city', 'street', 'postal_code', 'name');
            System.assertEquals(dossiers4.size() , 5);
            for (Business_Dossier__c dossier : dossiers4) {
                System.assert(dossier.Name.isNumeric());
                System.assert(dossier.Postal_Code__c.startsWith('123'));
                System.assert(dossier.Status__c == 'status');
            }
        }
        Test.stopTest();
    }

    @IsTest
    static void testSearchForCreditSafeDossiersForIE() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsCreditsafe wsCreditsafeService = (IWsCreditsafe)mocks.mock(IWsCreditsafe.class);

        CreditsafeWsdl.CreditsafeSearchResultV2 searchResultV2 = new CreditsafeWsdl.CreditsafeSearchResultV2();
        searchResultV2.companies = new CreditsafeWsdl.CreditsafeCompanyV2Array();
        searchResultV2.companies.item = new List<CreditsafeWsdl.CreditsafeCompanyV2>();
        for (Integer i = 0; i < 5; i++) {
            CreditsafeWsdl.CreditsafeCompanyV2 company  = new CreditsafeWsdl.CreditsafeCompanyV2();
            company.country = 'IE';
            company.name = '' + i;
            company.registration_number = '123' + i;
            company.address = new CreditsafeWsdl.CreditsafeAddressV2();
            company.address.city = 'Utrecht';
            company.address.street = 'Braillelaan';
            company.address.telephone = '' + i;
            company.address.postal_code = '123' + i;
            company.status = 'status';
            company.trade_names = new CreditsafeWsdl.stringArray();
            company.trade_names.item = new List<String>();
            for (Integer i2 = 0; i2 < 3; i2++) {
                company.trade_names.item.add('' + i + '_' + i2);
            }
            company.id = '' + i;
            company.date_last_account = Datetime.now();
            company.date_last_change = Datetime.now();
            company.office_type = 'Headoffice';
            company.creditsafe_number = '' + i;
            company.vat_numbers = new CreditsafeWsdl.stringArray();
            company.vat_numbers.item = new List<String>();
            for (Integer i3 = 0; i3 < 3; i3++) {
                company.vat_numbers.item.add('' + i + '_' + i3);
            }
            searchResultV2.companies.item.add(company);
        }

        mocks.startStubbing();
        mocks.when(wsCreditsafeService.creditsafeSearchV2(
                (CreditsafeWsdl.stringArray)fflib_Match.anyObject(),
                fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyString(),
                fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyString()
                ,fflib_Match.anyString(),fflib_Match.anyString())).thenReturn(searchResultV2);
        mocks.stopStubbing();

        Application.Service.setMock(IWsCreditsafe.class, wsCreditsafeService);

        Test.startTest();
        {
            List<Business_Dossier__c> dossiers = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'IE'}, 'id', 'status', 'regnr', 'type', 'vat', 'province', 'city', 'street', 'postal_code', 'name');
            System.assert(dossiers.size() == 15);
            for (Business_Dossier__c dossier : dossiers) {
                System.assert(dossier.Name.isNumeric());
                System.assert(dossier.Dossier_Number__c.startsWith('123'));
                System.assert(dossier.Country__c == 'IE');
                System.assert(dossier.Street__c == 'Braillelaan');
                System.assert(dossier.City__c == 'Utrecht');
                System.assert(dossier.Date_of_Last_Account__c != null && dossier.Date_of_Last_Account__c < Datetime.now());
                System.assert(dossier.Date_of_Last_Change__c != null && dossier.Date_of_Last_Change__c < Datetime.now());
                System.assert(dossier.Office_Type__c == 'Headoffice');
                System.assert(dossier.Trade_Names__c != null);
                System.assert(dossier.Telephone_Number__c.isNumeric());
            }

            //test for IEWithCompanyId
            List<Business_Dossier__c> dossiers1 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'IE'}, 'id', '', '', '', '', '', '', '', '', '');
            System.assert(dossiers1.size() == 5);
            for (Business_Dossier__c dossier : dossiers1) {
                System.assert(dossier.Company_Id__c.isNumeric());
            }

            //test for IEWithRegistrationNumber
            List<Business_Dossier__c> dossiers2 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'IE'}, '', '', 'registration_number', '', '', '', '', '', '', '');
            System.assertEquals(dossiers2.size() , 5);
            for (Business_Dossier__c dossier : dossiers2) {
                System.assert(dossier.Dossier_Number__c.startsWith('123'));
            }

            //test for IEWith name, status, registration_type, street, city, postalcode
            List<Business_Dossier__c> dossiers4 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'IE'}, '', 'status', '', 'registration_type', '', '', 'city', 'street', 'postal_code', 'name');
            System.assertEquals(dossiers4.size() , 5);
            for (Business_Dossier__c dossier : dossiers4) {
                System.assert(dossier.Name.isNumeric());
                System.assert(dossier.Postal_Code__c.startsWith('123'));
                System.assert(dossier.Status__c == 'status');
            }
        }
        Test.stopTest();
    }

    @IsTest
    static void testSearchForCreditSafeDossiersForSE() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsCreditsafe wsCreditsafeService = (IWsCreditsafe)mocks.mock(IWsCreditsafe.class);

        CreditsafeWsdl.CreditsafeSearchResultV2 searchResultV2 = new CreditsafeWsdl.CreditsafeSearchResultV2();
        searchResultV2.companies = new CreditsafeWsdl.CreditsafeCompanyV2Array();
        searchResultV2.companies.item = new List<CreditsafeWsdl.CreditsafeCompanyV2>();
        for (Integer i = 0; i < 5; i++) {
            CreditsafeWsdl.CreditsafeCompanyV2 company  = new CreditsafeWsdl.CreditsafeCompanyV2();
            company.country = 'SE';
            company.name = '' + i;
            company.registration_number = '123' + i;
            company.address = new CreditsafeWsdl.CreditsafeAddressV2();
            company.address.city = 'Utrecht';
            company.address.street = 'Braillelaan';
            company.address.telephone = '' + i;
            company.address.postal_code = '123' + i;
            company.status = 'status';
            company.trade_names = new CreditsafeWsdl.stringArray();
            company.trade_names.item = new List<String>();
            for (Integer i2 = 0; i2 < 3; i2++) {
                company.trade_names.item.add('' + i + '_' + i2);
            }
            company.id = '' + i;
            company.date_last_account = Datetime.now();
            company.date_last_change = Datetime.now();
            company.office_type = 'Headoffice';
            company.creditsafe_number = '' + i;
            company.vat_numbers = new CreditsafeWsdl.stringArray();
            company.vat_numbers.item = new List<String>();
            for (Integer i3 = 0; i3 < 3; i3++) {
                company.vat_numbers.item.add('' + i + '_' + i3);
            }
            searchResultV2.companies.item.add(company);
        }

        mocks.startStubbing();
        mocks.when(wsCreditsafeService.creditsafeSearchV2(
                (CreditsafeWsdl.stringArray)fflib_Match.anyObject(),
                fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyString(),
                fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyString(),fflib_Match.anyString()
                ,fflib_Match.anyString(),fflib_Match.anyString())).thenReturn(searchResultV2);
        mocks.stopStubbing();

        Application.Service.setMock(IWsCreditsafe.class, wsCreditsafeService);

        Test.startTest();
        {
            List<Business_Dossier__c> dossiers = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'SE'}, 'id', 'status', 'regnr', 'type', 'vat', 'province', 'city', 'street', 'postal_code', 'name');
            System.assert(dossiers.size() == 15);
            for (Business_Dossier__c dossier : dossiers) {
                System.assert(dossier.Name.isNumeric());
                System.assert(dossier.Dossier_Number__c.startsWith('123'));
                System.assert(dossier.Country__c == 'SE');
                System.assert(dossier.Street__c == 'Braillelaan');
                System.assert(dossier.City__c == 'Utrecht');
                System.assert(dossier.Date_of_Last_Account__c != null && dossier.Date_of_Last_Account__c < Datetime.now());
                System.assert(dossier.Date_of_Last_Change__c != null && dossier.Date_of_Last_Change__c < Datetime.now());
                System.assert(dossier.Office_Type__c == 'Headoffice');
                System.assert(dossier.Trade_Names__c != null);
                System.assert(dossier.Telephone_Number__c.isNumeric());
            }

            //test for IEWithCompanyId
            List<Business_Dossier__c> dossiers1 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'SE'}, 'id', '', '', '', '', '', '', '', '', '');
            System.assert(dossiers1.size() == 5);
            for (Business_Dossier__c dossier : dossiers1) {
                System.assert(dossier.Company_Id__c.isNumeric());
            }

            //test for IEWithRegistrationNumber, registration_type
            List<Business_Dossier__c> dossiers2 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'SE'}, '', '', 'registration_number', 'registration_type', '', '', '', '', '', '');
            System.assertEquals(dossiers2.size() , 10);
            for (Business_Dossier__c dossier : dossiers2) {
                System.assert(dossier.Dossier_Number__c.startsWith('123'));
            }

            //test for IEWith name, status, registration_type, street, city, postalcode
            List<Business_Dossier__c> dossiers4 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'SE'}, '', 'status', '', 'registration_type', '', '', 'city', 'street', 'postal_code', 'name');
            System.assertEquals(dossiers4.size() , 5);
            for (Business_Dossier__c dossier : dossiers4) {
                System.assert(dossier.Name.isNumeric());
                System.assert(dossier.Postal_Code__c.startsWith('123'));
                System.assert(dossier.Status__c == 'status');
            }
        }
        Test.stopTest();
    }


    @IsTest
    static void testGetCreditSafeReportFullHappyFlow() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsCreditsafe wsCreditsafeService = (IWsCreditsafe)mocks.mock(IWsCreditsafe.class);

        CreditsafeWsdl.CreditsafeCompanyReportFullV2 reportFullV2 = createCompanyReportFullV2Mock();

        mocks.startStubbing();
        mocks.when(wsCreditsafeService.creditsafeGetReportFullV2(fflib_Match.anyString(), fflib_Match.anyString(),fflib_Match.anyString())).thenReturn(reportFullV2);
        mocks.stopStubbing();

        Application.Service.setMock(IWsCreditsafe.class, wsCreditsafeService);
        Creditsafe_Company_Report_Full__c reportFull;
        Test.startTest();
        {
            reportFull = CreditSafeService.getCreditsafeReportFullV2('BE-X-831382050', 'EN', '');
        }
        Test.stopTest();
        System.assert(reportFull != null);
        reportFull = [
                SELECT
                        CreatedById,
                        CreatedDate,
                        Beneficiary_Owners_City__c,
                        Beneficiary_Owners_Country__c,
                        Beneficiary_Owners_Name__c,
                        Beneficiary_Owners_Postal_Code__c,
                        Beneficiary_Owners_Share_Percent__c,
                        Branch_Number__c,
                        Business_Name__c,
                        Business_Purpose__c,
                        Commercial_Register_City__c,
                        Commercial_Register_Zip__c,
                        Company_Id__c,
                        Company_Registration_Number__c,
                        Company_Status__c,
                        Company_Status_Description__c,
                        Company_Type__c,
                        Complementary_Company__c,
                        Country__c,
                        Credit_Rating_Common_Description__c,
                        Credit_Rating_Common_Value__c,
                        Credit_Rating_Limit__c,
                        Credit_Rating_Provider_Description__c,
                        Credit_Rating_Provider_Value__c,
                        Credit_Rating_Provider_Value_Max__c,
                        Credit_Rating_Provider_Value_Min__c,
                        Current_CR_Common_Description__c,
                        Current_CR_Common_Value__c,
                        Current_CR_Limit__c,
                        Current_CR_Provider_Description__c,
                        Current_CR_Provider_Value__c,
                        Current_CR_Provider_Value_Max__c,
                        Current_CR_Provider_Value_Min__c,
                        Current_Rating_Max_Value__c,
                        Current_Rating_Min_Value__c,
                        Current_Rating_Value__c,
                        Date_Of_Cessation_Trading__c,
                        Date_Of_Insolvency__c,
                        Date_Of_Legal_Form__c,
                        Dateof_Company_Registration__c,
                        Dateof_Starting_Operations__c,
                        Day_Sales_Outstanding__c,
                        Day_Sales_Outstanding_Lower__c,
                        Day_Sales_Outstanding_Median__c,
                        Day_Sales_Outstanding_Upper__c,
                        DE_Negative_Rating__c,
                        Exporter__c,
                        Fax_Number__c,
                        Financials_Quality__c,
                        Has_Bankruptcy__c,
                        Image_Account_Document_Type__c,
                        Image_Account_End_Date__c,
                        Image_Account_Financials_Type__c,
                        Image_Account_Published_Date__c,
                        Image_Account_Serial_Number__c,
                        Image_Account_Start_Date__c,
                        Importer__c,
                        Industry_Average_Credit_Limit__c,
                        Industry_Average_Credit_Rating__c,
                        Industry_Average_Day_Sales_Outstanding__c,
                        Industry_Average_Payment_Expectation_Day__c,
                        Issued_Share_Capital__c,
                        Language__c,
                        Latest_Shareholders_Equity_Figure__c,
                        Latest_Turnover_Figure__c,
                        Legal_Form_Code__c,
                        Legal_Form_Description__c,
                        Legal_Form_Value__c,
                        Main_Activity_Classification__c,
                        Main_Activity_Code__c,
                        Main_Activity_Description__c,
                        Miscellaneous_Turnover_Range__c,
                        NL_Negative_Rating__c,
                        Nominal_Share_Capital__c,
                        Number__c,
                        Order_Number__c,
                        Payment_Expectation_Days__c,
                        Payment_Expectation_Days_Lower__c,
                        Payment_Expectation_Days_Median__c,
                        Payment_Expectation_Days_Upper__c,
                        Premise_Type__c,
                        Previous_CR_Common_Description__c,
                        Previous_CR_Common_Value__c,
                        Previous_CR_Limit__c,
                        Previous_CR_Provider_Description__c,
                        Previous_CR_Provider_Value__c,
                        Previous_CR_Provider_Value_Max__c,
                        Previous_CR_Provider_Value_Min__c,
                        Previous_Rating_Max_Value__c,
                        Previous_Rating_Min_Value__c,
                        Previous_Rating_Value__c,
                        Principal_Activity_Code__c,
                        Principal_Activity_Description__c,
                        Principal_Activity_Value__c,
                        Registered_Company_Name__c,
                        Rsin_Number__c,
                        Small_Office__c,
                        Suspension_Of_Payments_Mora__c,
                        Trustee_City__c,
                        Trustee_Code__c,
                        Trustee_Email_Address__c,
                        Trustee_Fax_Number__c,
                        Trustee_First_Name__c,
                        Trustee_Last_Name__c,
                        Trustee_Name__c,
                        Trustee_Telephone_Number__c,
                        Trustee_Title__c,
                        Turnover_Range_Year__c,
                        Turnover_Ranges__c,
                        VAT_Registration_Number__c,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        LastViewedDate,
                        Name,
                        OwnerId,
                        SystemModstamp
                FROM Creditsafe_Company_Report_Full__c LIMIT 1];

        System.assert(reportFull.Beneficiary_Owners_City__c == 'beneficiary_owners_city');
        System.assert(reportFull.Beneficiary_Owners_Country__c == 'beneficiary_owners_country');
        System.assert(reportFull.Beneficiary_Owners_Name__c ==  'beneficiary_owners_name');
        System.assert(reportFull.Beneficiary_Owners_Postal_Code__c == 'beneficiary_owners_postal_code');
        System.assert(reportFull.Beneficiary_Owners_Share_Percent__c == '10');
        System.assert(reportFull.Branch_Number__c == '10');
        System.assert(reportFull.Business_Name__c == 'business_name');
        System.assert(reportFull.Business_Purpose__c == 'business_purpose');
        System.assert(reportFull.Commercial_Register_City__c == 'commercial_register_city');
        System.assert(reportFull.Commercial_Register_Zip__c == '123');
        System.assert(reportFull.Company_Id__c == '1212');
        System.assert(reportFull.Company_Registration_Number__c == '202020');
        System.assert(reportFull.Company_Status__c == 'company_status.status');
        System.assert(reportFull.Company_Status_Description__c == 'company_status.description');
        System.assert(reportFull.Company_Type__c == 'company_type');
        System.assert(reportFull.Complementary_Company__c == 'complementary_company');
        System.assert(reportFull.Country__c == 'country');
        System.assert(reportFull.Credit_Rating_Common_Description__c == 'credit_rating.common_description');
        System.assert(reportFull.Credit_Rating_Common_Value__c == 'credit_rating.common_value');
        System.assert(reportFull.Credit_Rating_Limit__c == '100');
        System.assert(reportFull.Credit_Rating_Provider_Description__c == 'credit_rating.provider_description');
        System.assert(reportFull.Credit_Rating_Provider_Value__c == '10');
        System.assert(reportFull.Credit_Rating_Provider_Value_Max__c == '20');
        System.assert(reportFull.Credit_Rating_Provider_Value_Min__c == '0');
        System.assert(reportFull.Current_CR_Common_Description__c == 'current_credit_rating.common_description');
        System.assert(reportFull.Current_CR_Common_Value__c == 'current_credit_rating.common_value');
        System.assert(reportFull.Current_CR_Limit__c == '1000');
        System.assert(reportFull.Current_CR_Provider_Description__c == 'current_credit_rating.provider_description');
        System.assert(reportFull.Current_CR_Provider_Value__c == '100');
        System.assert(reportFull.Current_CR_Provider_Value_Max__c == '200');
        System.assert(reportFull.Current_CR_Provider_Value_Min__c == '0');
        System.assert(reportFull.Current_Rating_Max_Value__c == '5');
        System.assert(reportFull.Current_Rating_Min_Value__c == '0');
        System.assert(reportFull.Current_Rating_Value__c == '1');
        System.assert(reportFull.Date_Of_Cessation_Trading__c == Datetime.newInstance(2020, 1, 2).date());
        System.assert(reportFull.Date_Of_Insolvency__c == 'Today');
        System.assert(reportFull.Date_Of_Legal_Form__c  == Datetime.newInstance(2020, 2, 2).date());
        System.assert(reportFull.Dateof_Company_Registration__c == Datetime.newInstance(2010, 1,1));
        System.assert(reportFull.Dateof_Starting_Operations__c == Datetime.newInstance(2010, 1,1));
        System.assert(reportFull.Day_Sales_Outstanding__c == 20);
        System.assert(reportFull.Day_Sales_Outstanding_Lower__c == 0.0);
        System.assert(reportFull.Day_Sales_Outstanding_Median__c == 5.0);
        System.assert(reportFull.Day_Sales_Outstanding_Upper__c == 10.0);
        System.assert(reportFull.DE_Negative_Rating__c == 12);
        System.assert(reportFull.Exporter__c == '13');
        System.assert(reportFull.Fax_Number__c == '1');
        System.assert(reportFull.Financials_Quality__c == '2');
        System.assert(reportFull.Has_Bankruptcy__c == 'yes');
        System.assert(reportFull.Image_Account_Document_Type__c == 'document_type');
        System.assert(reportFull.Image_Account_End_Date__c == Datetime.newInstance(2020, 12, 31).date());
        System.assert(reportFull.Image_Account_Financials_Type__c == 'financials_type');
        System.assert(reportFull.Image_Account_Published_Date__c == Datetime.newInstance(2020, 02, 14).date());
        System.assert(reportFull.Image_Account_Serial_Number__c == '123123');
        System.assert(reportFull.Image_Account_Start_Date__c == Datetime.newInstance(2020, 02, 13 ).date());
        System.assert(reportFull.Importer__c == '12');
        System.assert(reportFull.Industry_Average_Credit_Limit__c == 5.0);
        System.assert(reportFull.Industry_Average_Credit_Rating__c == 2.0);
        System.assert(reportFull.Industry_Average_Day_Sales_Outstanding__c == 21);
        System.assert(reportFull.Industry_Average_Payment_Expectation_Day__c == 25);
        System.assert(reportFull.Issued_Share_Capital__c == 'issued_share_capital');
        System.assert(reportFull.Language__c == 'lang');
        System.assert(reportFull.Latest_Shareholders_Equity_Figure__c == 3);
        System.assert(reportFull.Latest_Turnover_Figure__c == 2);
        System.assert(reportFull.Legal_Form_Code__c == 'legal_form.code');
        System.assert(reportFull.Legal_Form_Description__c == 'legal_form.description');
        System.assert(reportFull.Legal_Form_Value__c == 'legal_form.value');
        System.assert(reportFull.Main_Activity_Classification__c == 'classification');
        System.assert(reportFull.Main_Activity_Code__c == '1212');
        System.assert(reportFull.Main_Activity_Description__c == 'activity_description');
        System.assert(reportFull.Miscellaneous_Turnover_Range__c == '1234');
        System.assert(reportFull.NL_Negative_Rating__c == 0);
        System.assert(reportFull.Nominal_Share_Capital__c == 'nominal_share_capital');
        System.assert(reportFull.Number__c == '9');
        System.assert(reportFull.Order_Number__c == '1212');
        System.assert(reportFull.Payment_Expectation_Days__c == 10);
        System.assert(reportFull.Payment_Expectation_Days_Lower__c == 0.0);
        System.assert(reportFull.Payment_Expectation_Days_Median__c == 5.0);
        System.assert(reportFull.Payment_Expectation_Days_Upper__c == 10.0);
        System.assert(reportFull.Premise_Type__c == 'premise');
        System.assert(reportFull.Previous_CR_Common_Description__c == 'previous_credit_rating.common_description');
        System.assert(reportFull.Previous_CR_Common_Value__c == 'previous_credit_rating.common_value');
        System.assert(reportFull.Previous_CR_Limit__c == '1000');
        System.assert(reportFull.Previous_CR_Provider_Description__c == 'previous_credit_rating.provider_description');
        System.assert(reportFull.Previous_CR_Provider_Value__c == '101');
        System.assert(reportFull.Previous_CR_Provider_Value_Max__c == '201');
        System.assert(reportFull.Previous_CR_Provider_Value_Min__c == '0');
        System.assert(reportFull.Previous_Rating_Max_Value__c == '5');
        System.assert(reportFull.Previous_Rating_Min_Value__c == '0');
        System.assert(reportFull.Previous_Rating_Value__c == '0');
        System.assert(reportFull.Principal_Activity_Code__c == 'principal_activity.code');
        System.assert(reportFull.Principal_Activity_Description__c == 'principal_activity.description');
        System.assert(reportFull.Principal_Activity_Value__c == 'principal_activity.value');
        System.assert(reportFull.Registered_Company_Name__c == 'registered_company_name');
        System.assert(reportFull.Rsin_Number__c == '11');
        System.assert(reportFull.Small_Office__c == 'small');
        System.assert(reportFull.Suspension_Of_Payments_Mora__c == 'mora');
        System.assert(reportFull.Trustee_City__c == 'trustee.city');
        System.assert(reportFull.Trustee_Code__c == 'trustee.code');
        System.assert(reportFull.Trustee_Email_Address__c == 'trustee@gmail.com');
        System.assert(reportFull.Trustee_Fax_Number__c == '12');
        System.assert(reportFull.Trustee_First_Name__c == 'trustee.first_name');
        System.assert(reportFull.Trustee_Last_Name__c == 'trustee.last_name');
        System.assert(reportFull.Trustee_Name__c == 'trustee.name');
        System.assert(reportFull.Trustee_Telephone_Number__c == '12');
        System.assert(reportFull.Trustee_Title__c == 'trustee.title');
        System.assert(reportFull.Turnover_Range_Year__c == '2020');
        System.assert(reportFull.Turnover_Ranges__c == '1000-5000');
        System.assert(reportFull.VAT_Registration_Number__c == '1212');

        List<Additional_Info_NL_Letter_Of_Liability__c> additionalInfoNLLetterOfLiabilities = [
                SELECT
                        CreatedById,
                        CreatedDate,
                        Company_Name__c,
                        Company_Number__c,
                        Creditsafe_Company_Report_Full__c,
                        Date_Submitted__c,
                        Financial_Year__c,
                        Liability1_Removal_Date__c,
                        Liability1_Removal_Date_Parent2__c,
                        Liability1_Removal_Submitted__c,
                        Liability1_Removal_Submitted_Parent2__c,
                        Liability1_Start_Date__c,
                        Liability1_Start_Date_Parent2__c,
                        Liability1_Submitted_Date__c,
                        Liability1_Submitted_Date_Parent2__c,
                        Liability2_Removal_Date__c,
                        Liability2_Removal_Date_Parent2__c,
                        Liability2_Removal_Submitted__c,
                        Liability2_Removal_Submitted_Parent2__c,
                        Liability2_Start_Date__c,
                        Liability2_Start_Date_Parent2__c,
                        Liability2_Submitted_Date__c,
                        Liability2_Submitted_Date_Parent2__c,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        Name,
                        SystemModstamp
                FROM Additional_Info_NL_Letter_Of_Liability__c WHERE Creditsafe_Company_Report_Full__c = :reportFull.Id];

        System.assert(additionalInfoNLLetterOfLiabilities.size() == 2);
        System.assert(additionalInfoNLLetterOfLiabilities[0].Company_Name__c == 'company_name' + '0');
        System.assert(additionalInfoNLLetterOfLiabilities[0].Company_Number__c == '12' + '0');
        System.assert(additionalInfoNLLetterOfLiabilities[0].Date_Submitted__c == Datetime.newInstance(2020, 1, 1).date());
        System.assert(additionalInfoNLLetterOfLiabilities[0].Financial_Year__c == '2020');
        System.assert(additionalInfoNLLetterOfLiabilities[0].Liability1_Removal_Date__c == Datetime.newInstance(2020, 1, 8).date());
        System.assert(additionalInfoNLLetterOfLiabilities[0].Liability1_Removal_Date_Parent2__c == Datetime.newInstance(2020, 1, 9).date());
        System.assert(additionalInfoNLLetterOfLiabilities[0].Liability1_Removal_Submitted__c == Datetime.newInstance(2020, 1, 3).date());
        System.assert(additionalInfoNLLetterOfLiabilities[0].Liability1_Removal_Submitted_Parent2__c == Datetime.newInstance(2020, 1, 2).date());
        System.assert(additionalInfoNLLetterOfLiabilities[0].Liability1_Start_Date__c == Datetime.newInstance(2020, 1, 7).date());
        System.assert(additionalInfoNLLetterOfLiabilities[0].Liability1_Start_Date_Parent2__c == Datetime.newInstance(2020, 1, 6).date());
        System.assert(additionalInfoNLLetterOfLiabilities[0].Liability1_Submitted_Date__c == Datetime.newInstance(2020, 1, 5).date());
        System.assert(additionalInfoNLLetterOfLiabilities[0].Liability1_Submitted_Date_Parent2__c == Datetime.newInstance(2020, 1, 4).date());
        System.assert(additionalInfoNLLetterOfLiabilities[0].Liability2_Removal_Date__c == Datetime.newInstance(2020, 1, 10).date());
        System.assert(additionalInfoNLLetterOfLiabilities[0].Liability2_Removal_Date_Parent2__c == Datetime.newInstance(2020, 1, 11).date());
        System.assert(additionalInfoNLLetterOfLiabilities[0].Liability2_Removal_Submitted__c == Datetime.newInstance(2020, 1, 16).date());
        System.assert(additionalInfoNLLetterOfLiabilities[0].Liability2_Removal_Submitted_Parent2__c == Datetime.newInstance(2020, 1, 12).date());
        System.assert(additionalInfoNLLetterOfLiabilities[0].Liability2_Start_Date__c == Datetime.newInstance(2020, 1, 13).date());
        System.assert(additionalInfoNLLetterOfLiabilities[0].Liability2_Start_Date_Parent2__c == Datetime.newInstance(2020, 1, 14).date());
        System.assert(additionalInfoNLLetterOfLiabilities[0].Liability2_Submitted_Date__c == Datetime.newInstance(2020, 1, 17).date());
        System.assert(additionalInfoNLLetterOfLiabilities[0].Liability2_Submitted_Date_Parent2__c == Datetime.newInstance(2020, 1, 15).date());
        System.assert(additionalInfoNLLetterOfLiabilities[1].Company_Name__c == 'company_name' + '1');
        System.assert(additionalInfoNLLetterOfLiabilities[1].Company_Number__c == '12' + '1');
        System.assert(additionalInfoNLLetterOfLiabilities[1].Date_Submitted__c == Datetime.newInstance(2020, 1, 1).date());
        System.assert(additionalInfoNLLetterOfLiabilities[1].Financial_Year__c == '2020');
        System.assert(additionalInfoNLLetterOfLiabilities[1].Liability1_Removal_Date__c == Datetime.newInstance(2020, 1, 8).date());
        System.assert(additionalInfoNLLetterOfLiabilities[1].Liability1_Removal_Date_Parent2__c == Datetime.newInstance(2020, 1, 9).date());
        System.assert(additionalInfoNLLetterOfLiabilities[1].Liability1_Removal_Submitted__c == Datetime.newInstance(2020, 1, 3).date());
        System.assert(additionalInfoNLLetterOfLiabilities[1].Liability1_Removal_Submitted_Parent2__c == Datetime.newInstance(2020, 1, 2).date());
        System.assert(additionalInfoNLLetterOfLiabilities[1].Liability1_Start_Date__c == Datetime.newInstance(2020, 1, 7).date());
        System.assert(additionalInfoNLLetterOfLiabilities[1].Liability1_Start_Date_Parent2__c == Datetime.newInstance(2020, 1, 6).date());
        System.assert(additionalInfoNLLetterOfLiabilities[1].Liability1_Submitted_Date__c == Datetime.newInstance(2020, 1, 5).date());
        System.assert(additionalInfoNLLetterOfLiabilities[1].Liability1_Submitted_Date_Parent2__c == Datetime.newInstance(2020, 1, 4).date());
        System.assert(additionalInfoNLLetterOfLiabilities[1].Liability2_Removal_Date__c == Datetime.newInstance(2020, 1, 10).date());
        System.assert(additionalInfoNLLetterOfLiabilities[1].Liability2_Removal_Date_Parent2__c == Datetime.newInstance(2020, 1, 11).date());
        System.assert(additionalInfoNLLetterOfLiabilities[1].Liability2_Removal_Submitted__c == Datetime.newInstance(2020, 1, 16).date());
        System.assert(additionalInfoNLLetterOfLiabilities[1].Liability2_Removal_Submitted_Parent2__c == Datetime.newInstance(2020, 1, 12).date());
        System.assert(additionalInfoNLLetterOfLiabilities[1].Liability2_Start_Date__c == Datetime.newInstance(2020, 1, 13).date());
        System.assert(additionalInfoNLLetterOfLiabilities[1].Liability2_Start_Date_Parent2__c == Datetime.newInstance(2020, 1, 14).date());
        System.assert(additionalInfoNLLetterOfLiabilities[1].Liability2_Submitted_Date__c == Datetime.newInstance(2020, 1, 17).date());
        System.assert(additionalInfoNLLetterOfLiabilities[1].Liability2_Submitted_Date_Parent2__c == Datetime.newInstance(2020, 1, 15).date());

        List<Additional_Information_NL_Kvk_Filing__c> kvkFilings = [
                SELECT
                        CreatedById,
                        CreatedDate,
                        Creditsafe_Company_Report_Full__c,
                        Date__c,
                        Event__c,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        Name,
                        SystemModstamp
                FROM Additional_Information_NL_Kvk_Filing__c WHERE Creditsafe_Company_Report_Full__c = :reportFull.Id];
        System.assert(kvkFilings.size() == 2);
        System.assert(kvkFilings[0].Date__c == Datetime.newInstance(2020, 1, 11).date());
        System.assert(kvkFilings[0].Event__c == 'event');
        System.assert(kvkFilings[1].Date__c == Datetime.newInstance(2020, 1, 11).date());
        System.assert(kvkFilings[1].Event__c == 'event');

        List<Additional_Information_NL_Financial_Item__c> financialItems = [
                SELECT
                        CreatedById,
                        CreatedDate,
                        Consolidated_Subsidiaries__c,
                        Creditsafe_Company_Report_Full__c,
                        Date_Year_End__c,
                        Judgement__c,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        Name,
                        SystemModstamp
                FROM Additional_Information_NL_Financial_Item__c WHERE Creditsafe_Company_Report_Full__c = :reportFull.Id];

        System.assert(financialItems.size() == 2);
        System.assert(financialItems[0].Consolidated_Subsidiaries__c == 'consolidated_subsidiaries' + 0);
        System.assert(financialItems[0].Date_Year_End__c == Datetime.newInstance(2020, 5, 5).date());
        System.assert(financialItems[0].Judgement__c == 'judgement' + 0);
        System.assert(financialItems[1].Consolidated_Subsidiaries__c == 'consolidated_subsidiaries' + 1);
        System.assert(financialItems[1].Date_Year_End__c == Datetime.newInstance(2020, 5, 5).date());
        System.assert(financialItems[1].Judgement__c == 'judgement' + 1);

        List<Additional_Information_Historical_Event__c> historicalEvents = [
                SELECT
                        CreatedById,
                        CreatedDate,
                        Creditsafe_Company_Report_Full__c,
                        Current_Value__c,
                        Date__c,
                        Description__c,
                        Previous_Value__c,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        Name,
                        SystemModstamp
                FROM Additional_Information_Historical_Event__c WHERE Creditsafe_Company_Report_Full__c = :reportFull.Id];
        System.assert(historicalEvents.size() == 4);
        System.assert(historicalEvents[0].Description__c == 'description');
        System.assert(historicalEvents[0].Date__c == Datetime.newInstance(2020, 1, 1).date());
        System.assert(historicalEvents[0].Current_Value__c == 'current_value');
        System.assert(historicalEvents[0].Previous_Value__c == 'previous_value');
        System.assert(historicalEvents[1].Description__c == 'description');
        System.assert(historicalEvents[1].Date__c == Datetime.newInstance(2020, 1, 1).date());
        System.assert(historicalEvents[1].Current_Value__c == 'current_value');
        System.assert(historicalEvents[1].Previous_Value__c == 'previous_value');

        Creditsafe_Comp_Activity_Classifications__c activityClassifications = [
                SELECT
                        CreatedById,
                        CreatedDate,
                        Classification__c,
                        Creditsafe_Company_Report_Full__c,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        Name,
                        SystemModstamp
                FROM Creditsafe_Comp_Activity_Classifications__c WHERE Creditsafe_Company_Report_Full__c = :reportFull.Id];
        System.assert(activityClassifications.Classification__c == 'classification');

        Creditsafe_Company_Activity__c activity = [
                SELECT
                        CreatedById,
                        CreatedDate,
                        Activity_Code__c,
                        Activity_Description__c,
                        Classification__c,
                        Creditsafe_Comp_Activity_Classification__c,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        Name,
                        SystemModstamp
                FROM Creditsafe_Company_Activity__c WHERE Creditsafe_Comp_Activity_Classification__c = :activityClassifications.Id];
        System.assert(activity.Classification__c == 'classification');
        System.assert(activity.Activity_Description__c == 'activity_description');
        System.assert(activity.Activity_Code__c == 'activity_code');

        List<Creditsafe_Address__c> addresses = [
                SELECT
                        CreatedById,
                        CreatedDate,
                        City__c,
                        Country__c,
                        Creditsafe_Company_Report_Full__c,
                        Full_Address__c,
                        House_Number__c,
                        House_Number_Addition__c,
                        Postcode__c,
                        Street__c,
                        Telephone__c,
                        Type__c,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        Name,
                        SystemModstamp
                FROM Creditsafe_Address__c WHERE Creditsafe_Company_Report_Full__c = :reportFull.Id];
        System.assert(addresses.size() == 2);
        System.assert(addresses[0].Country__c == 'country');
        System.assert(addresses[0].House_Number__c == '1');
        System.assert(addresses[0].Full_Address__c == 'full_address');
        System.assert(addresses[0].Telephone__c == '987654321');
        System.assert(addresses[0].Street__c == 'street');
        System.assert(addresses[0].City__c == 'city');
        System.assert(addresses[0].Postcode__c == '1212');
        System.assert(addresses[1].Country__c == 'country');
        System.assert(addresses[1].House_Number__c == '1');
        System.assert(addresses[1].Full_Address__c == 'full_address');
        System.assert(addresses[1].Telephone__c == '987654321');
        System.assert(addresses[1].Street__c == 'street');
        System.assert(addresses[1].City__c == 'city');
        System.assert(addresses[1].Postcode__c == '1212');

        Id currentId = Schema.SObjectType.Creditsafe_Person_Director__c.getRecordTypeInfosByDeveloperName().get('Current_Director').getRecordTypeId();
        Creditsafe_Person_Director__c personDirectors = [
                SELECT
                        CreatedById,
                        CreatedDate,
                        Creditsafe_Company_Report_Full__c,
                        Date_of_Birth__c,
                        Director_Id__c,
                        Director_Type__c,
                        Gender__c,
                        Resignation_Date__c,
                        City__c,
                        Country__c,
                        Full_Address__c,
                        House_Number__c,
                        House_Number_Addition__c,
                        Postcode__c,
                        Street__c,
                        Telephone__c,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        Name,
                        RecordTypeId,
                        SystemModstamp
                FROM Creditsafe_Person_Director__c WHERE Creditsafe_Company_Report_Full__c = :reportFull.Id AND RecordTypeId = :currentId];
        System.assert(personDirectors.Name == 'cr name');
        System.assert(personDirectors.Director_Id__c == 'cr id');
        System.assert(personDirectors.Gender__c == 'cr gender');
        System.assert(personDirectors.Date_of_Birth__c == Datetime.newInstance(1970, 2, 1).date());
        System.assert(personDirectors.Director_Type__c == 'ceo');
        System.assert(personDirectors.City__c == 'cr city');
        System.assert(personDirectors.Country__c == 'cr country');
        System.assert(personDirectors.Full_Address__c == 'cr full_address');
        System.assert(personDirectors.House_Number__c == '1');
        System.assert(personDirectors.Postcode__c == '1212');
        System.assert(personDirectors.Street__c == 'cr street');
        System.assert(personDirectors.Telephone__c == '987654321');

        Creditsafe_Person_Position__c position = [
                SELECT
                        CreatedById,
                        CreatedDate,
                        Creditsafe_Person_Director__c,
                        Date_Appointed__c,
                        Position_Name__c,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        Name,
                        SystemModstamp
                FROM Creditsafe_Person_Position__c WHERE Creditsafe_Person_Director__c = :personDirectors.Id];
        System.assert(position.Position_Name__c == 'current dir');
        System.assert(position.Date_Appointed__c == Datetime.newInstance(2001, 1,1).date());

        Id prevId = Schema.SObjectType.Creditsafe_Person_Director__c.getRecordTypeInfosByDeveloperName().get('Previous_Director').getRecordTypeId();
        Creditsafe_Person_Director__c personDirectors1 = [
                SELECT
                        CreatedById,
                        CreatedDate,
                        Creditsafe_Company_Report_Full__c,
                        Date_of_Birth__c,
                        Director_Id__c,
                        Director_Type__c,
                        Gender__c,
                        Resignation_Date__c,
                        City__c,
                        Country__c,
                        Full_Address__c,
                        House_Number__c,
                        House_Number_Addition__c,
                        Postcode__c,
                        Street__c,
                        Telephone__c,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        Name,
                        RecordTypeId,
                        SystemModstamp
                FROM Creditsafe_Person_Director__c WHERE Creditsafe_Company_Report_Full__c = :reportFull.Id AND RecordTypeId = :prevId];
        System.assert(personDirectors1.Name == 'pr name');
        System.assert(personDirectors1.Director_Id__c == 'pr id');
        System.assert(personDirectors1.Gender__c == 'pr gender');
        System.assert(personDirectors1.Date_of_Birth__c == Datetime.newInstance(1970, 2, 1).date());
        System.assert(personDirectors1.Director_Type__c == 'cto');
        System.assert(personDirectors1.City__c == 'pr city');
        System.assert(personDirectors1.Country__c == 'pr country');
        System.assert(personDirectors1.Full_Address__c == 'pr full_address');
        System.assert(personDirectors1.House_Number__c == '1');
        System.assert(personDirectors1.Postcode__c == '1212');
        System.assert(personDirectors1.Street__c == 'pr street');
        System.assert(personDirectors1.Telephone__c == '987654321');

        Creditsafe_Company__c ucompany = [
                SELECT
                        CreatedById,
                        CreatedDate,
                        Company_Id__c,
                        Company_Type__c,
                        Country__c,
                        Creditsafe_Company_Report_Full__c,
                        Creditsafe_Number__c,
                        Date_Last_Account__c,
                        Date_Last_Change__c,
                        Name__c,
                        Office_Type__c,
                        Registration_Number__c,
                        Status__c,
                        Trade_Names__c,
                        Type__c,
                        VAT_Numbers__c,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        Name,
                        SystemModstamp
                FROM Creditsafe_Company__c WHERE Creditsafe_Company_Report_Full__c = : reportFull.Id AND Company_Type__c = 'Ultimate_Parent'];
        System.assert(ucompany.Company_Id__c == '12');
        System.assert(ucompany.Country__c == 'country');
        System.assert(ucompany.Creditsafe_Number__c == '12');
        System.assert(ucompany.Date_Last_Account__c == Datetime.newInstance(2020,3,23).date());
        System.assert(ucompany.Date_Last_Change__c == Datetime.newInstance(2020,1,23).date());
        System.assert(ucompany.Office_Type__c == 'office');
        System.assert(ucompany.Registration_Number__c == '1');
        System.assert(ucompany.Status__c == 'status');
        System.assert(ucompany.Trade_Names__c == 'trade names');
        System.assert(ucompany.VAT_Numbers__c == '1');

        Creditsafe_Company__c icompany = [
                SELECT
                        CreatedById,
                        CreatedDate,
                        Company_Id__c,
                        Country__c,
                        Creditsafe_Company_Report_Full__c,
                        Creditsafe_Number__c,
                        Date_Last_Account__c,
                        Date_Last_Change__c,
                        Name__c,
                        Office_Type__c,
                        Registration_Number__c,
                        Status__c,
                        Trade_Names__c,
                        Type__c,
                        VAT_Numbers__c,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        Name,
                        Company_Type__c,
                        SystemModstamp
                FROM Creditsafe_Company__c WHERE Creditsafe_Company_Report_Full__c = : reportFull.Id AND Company_Type__c = 'Immediate_Parent'];
        System.assert(icompany.Company_Id__c == '12');
        System.assert(icompany.Country__c == 'country');
        System.assert(icompany.Creditsafe_Number__c == '12');
        System.assert(icompany.Date_Last_Account__c == Datetime.newInstance(2020,3,23).date());
        System.assert(icompany.Date_Last_Change__c == Datetime.newInstance(2020,1,23).date());
        System.assert(icompany.Office_Type__c == 'office');
        System.assert(icompany.Registration_Number__c == '1');
        System.assert(icompany.Status__c == 'status');
        System.assert(icompany.Trade_Names__c == 'trade names');
        System.assert(icompany.VAT_Numbers__c == '1');

        Creditsafe_Company__c scompany = [
                SELECT
                        CreatedById,
                        CreatedDate,
                        Company_Id__c,
                        Country__c,
                        Creditsafe_Company_Report_Full__c,
                        Creditsafe_Number__c,
                        Date_Last_Account__c,
                        Date_Last_Change__c,
                        Name__c,
                        Office_Type__c,
                        Registration_Number__c,
                        Status__c,
                        Trade_Names__c,
                        Type__c,
                        VAT_Numbers__c,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        Name,
                        Company_Type__c,
                        SystemModstamp
                FROM Creditsafe_Company__c WHERE Creditsafe_Company_Report_Full__c = : reportFull.Id AND Company_Type__c = 'Subsidiary_Companies'];
        System.assert(scompany.Company_Id__c == '12');
        System.assert(scompany.Country__c == 'country');
        System.assert(scompany.Creditsafe_Number__c == '12');
        System.assert(scompany.Date_Last_Account__c == Datetime.newInstance(2020,3,23).date());
        System.assert(scompany.Date_Last_Change__c == Datetime.newInstance(2020,1,23).date());
        System.assert(scompany.Office_Type__c == 'office');
        System.assert(scompany.Registration_Number__c == '1');
        System.assert(scompany.Status__c == 'status');
        System.assert(scompany.Trade_Names__c == 'trade names');
        System.assert(scompany.VAT_Numbers__c == '1');

        Creditsafe_Company__c acompany = [
                SELECT
                        CreatedById,
                        CreatedDate,
                        Company_Id__c,
                        Country__c,
                        Creditsafe_Company_Report_Full__c,
                        Creditsafe_Number__c,
                        Date_Last_Account__c,
                        Date_Last_Change__c,
                        Name__c,
                        Office_Type__c,
                        Registration_Number__c,
                        Status__c,
                        Trade_Names__c,
                        Type__c,
                        VAT_Numbers__c,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        Name,
                        Company_Type__c,
                        SystemModstamp
                FROM Creditsafe_Company__c WHERE Creditsafe_Company_Report_Full__c = : reportFull.Id AND Company_Type__c = 'Affiliated_Companies'];
        System.assert(acompany.Company_Id__c == '12');
        System.assert(acompany.Country__c == 'country');
        System.assert(acompany.Creditsafe_Number__c == '12');
        System.assert(acompany.Date_Last_Account__c == Datetime.newInstance(2020,3,23).date());
        System.assert(acompany.Date_Last_Change__c == Datetime.newInstance(2020,1,23).date());
        System.assert(acompany.Office_Type__c == 'office');
        System.assert(acompany.Registration_Number__c == '1');
        System.assert(acompany.Status__c == 'status');
        System.assert(acompany.Trade_Names__c == 'trade names');
        System.assert(acompany.VAT_Numbers__c == '1');

        Creditsafe_Company_Financial_Statement__c financialStatement = [
                SELECT
                        CreatedById,
                        CreatedDate,
                        Balance_Sheets_Consolidated_Accounts__c,
                        Bank_Liabilities__c,
                        Bank_Liabilities_Due_After1year__c,
                        Called_Up_Share_Capital__c,
                        Cash__c,
                        Consolidated_Accounts__c,
                        Creditor_Days__c,
                        Creditsafe_Company_Report_Full__c,
                        Currency__c,
                        Current_Debt_Ratio__c,
                        Current_Ratio__c,
                        Debtor_Days__c,
                        Depreciation__c,
                        Dividends__c,
                        Equity_In_Percentage__c,
                        Financial_Expenses__c,
                        Financial_Income__c,
                        Finished_Goods__c,
                        Gearing__c,
                        Goodwill__c,
                        Group_Payables__c,
                        Group_Payables_Due_After1year__c,
                        Group_Receivables__c,
                        Investments__c,
                        Land_And_Buildings__c,
                        Liquidity_Ratio_Or_Acid_Test__c,
                        Loans_To_Group__c,
                        Miscellaneous_Fixed_Assets__c,
                        Miscellaneous_Liabilities__c,
                        Miscellaneous_Liabilities_Due_After1year__c,
                        Miscellaneous_Receivables__c,
                        Net_Worth__c,
                        Number_Of_Weeks__c,
                        Operating_Costs__c,
                        Operating_Profit__c,
                        Other_Appropriations__c,
                        Other_Current_Assets__c,
                        Other_Intangible_Assets__c,
                        Other_Inventories__c,
                        Other_Loans__c,
                        Other_Loans_Or_Finance__c,
                        Other_Loans_Or_Finance_Due_After1year__c,
                        Other_Reserves__c,
                        Other_Tangible_Assets__c,
                        Pension_Costs__c,
                        Plant_And_Machinery__c,
                        Pre_Tax_Profit_Margin__c,
                        Profit_After_Tax__c,
                        Profit_Before_Tax__c,
                        Raw_Materials__c,
                        Receivables_Due_After1year__c,
                        Retained_Profit__c,
                        Return_On_Capital_Employed__c,
                        Return_On_Net_Assets_Employed__c,
                        Return_On_Total_Assets_Employed__c,
                        Revenue__c,
                        Revenue_Reserves__c,
                        Sales_Or_Net_Working_Capital__c,
                        Share_Premium__c,
                        Stock_Turnover_Ratio__c,
                        Tax__c,
                        Total_Assets__c,
                        Total_Current_Assets__c,
                        Total_Current_Liabilities__c,
                        Total_Debt_Ratio__c,
                        Total_Fixed_Assets__c,
                        Total_Intangible_Assets__c,
                        Total_Inventories__c,
                        Total_Liabilities__c,
                        Total_Long_Term_Liabilities__c,
                        Total_Other_Fixed_Assets__c,
                        Total_Receivables__c,
                        Total_Shareholders_Equity__c,
                        Total_Tangible_Assets__c,
                        Trade_Payables__c,
                        Trade_Payables_Due_After1year__c,
                        Trade_Receivables__c,
                        Type__c,
                        Wages_And_Salaries__c,
                        Work_In_Progress__c,
                        Working_Capital__c,
                        Year_End_Date__c,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        Name,
                        SystemModstamp
                FROM Creditsafe_Company_Financial_Statement__c WHERE Creditsafe_Company_Report_Full__c = :reportFull.Id AND Type__c = 'fin'];
        System.assert(financialStatement.Balance_Sheets_Consolidated_Accounts__c == 5);
        System.assert(financialStatement.Bank_Liabilities__c == 1);
        System.assert(financialStatement.Bank_Liabilities_Due_After1year__c == 2);
        System.assert(financialStatement.Called_Up_Share_Capital__c == 3);
        System.assert(financialStatement.Cash__c  ==  4);
        System.assert(financialStatement.Consolidated_Accounts__c  ==  true);
        System.assert(financialStatement.Creditor_Days__c  ==  1.0);
        System.assert(financialStatement.Currency__c  ==  '12');
        System.assert(financialStatement.Current_Debt_Ratio__c  ==  2.0);
        System.assert(financialStatement.Current_Ratio__c  ==  3.0);
        System.assert(financialStatement.Debtor_Days__c  ==  4.0);
        System.assert(financialStatement.Depreciation__c  == 1);
        System.assert(financialStatement.Dividends__c  == 2);
        System.assert(financialStatement.Equity_In_Percentage__c  == 5.0);
        System.assert(financialStatement.Financial_Expenses__c  == 3);
        System.assert(financialStatement.Financial_Income__c  == 4);
        System.assert(financialStatement.Finished_Goods__c  == 6);
        System.assert(financialStatement.Gearing__c  == 6.0);
        System.assert(financialStatement.Goodwill__c  == 7);
        System.assert(financialStatement.Group_Payables__c  == 8);
        System.assert(financialStatement.Group_Payables_Due_After1year__c  == 9);
        System.assert(financialStatement.Group_Receivables__c  == 10);
        System.assert(financialStatement.Investments__c  == 11);
        System.assert(financialStatement.Land_And_Buildings__c  == 12);
        System.assert(financialStatement.Liquidity_Ratio_Or_Acid_Test__c  == 7.0);
        System.assert(financialStatement.Loans_To_Group__c  == 13);
        System.assert(financialStatement.Miscellaneous_Fixed_Assets__c  == 14);
        System.assert(financialStatement.Miscellaneous_Liabilities__c  == 15);
        System.assert(financialStatement.Miscellaneous_Liabilities_Due_After1year__c  == 16);
        System.assert(financialStatement.Miscellaneous_Receivables__c  == 17);
        System.assert(financialStatement.Net_Worth__c  == 2);
        System.assert(financialStatement.Number_Of_Weeks__c  == 3);
        System.assert(financialStatement.Operating_Costs__c  == 5);
        System.assert(financialStatement.Operating_Profit__c  == 6);
        System.assert(financialStatement.Other_Appropriations__c  == 7);
        System.assert(financialStatement.Other_Current_Assets__c  == 18);
        System.assert(financialStatement.Other_Intangible_Assets__c  == 19);
        System.assert(financialStatement.Other_Inventories__c  == 20);
        System.assert(financialStatement.Other_Loans__c  == 21);
        System.assert(financialStatement.Other_Loans_Or_Finance__c  == 22);
        System.assert(financialStatement.Other_Loans_Or_Finance_Due_After1year__c  == 23);
        System.assert(financialStatement.Other_Reserves__c  == 24);
        System.assert(financialStatement.Other_Tangible_Assets__c  == 25);
        System.assert(financialStatement.Pension_Costs__c  == 8);
        System.assert(financialStatement.Plant_And_Machinery__c  == 26);
        System.assert(financialStatement.Pre_Tax_Profit_Margin__c  == 8.0);
        System.assert(financialStatement.Profit_After_Tax__c  == 9);
        System.assert(financialStatement.Profit_Before_Tax__c  == 10);
        System.assert(financialStatement.Raw_Materials__c  == 27);
        System.assert(financialStatement.Receivables_Due_After1year__c  == 28);
        System.assert(financialStatement.Retained_Profit__c  == 11);
        System.assert(financialStatement.Return_On_Capital_Employed__c  == 9.0);
        System.assert(financialStatement.Return_On_Net_Assets_Employed__c  == 10.0);
        System.assert(financialStatement.Return_On_Total_Assets_Employed__c  == 11.0);
        System.assert(financialStatement.Revenue__c  == 12);
        System.assert(financialStatement.Revenue_Reserves__c  == 29);
        System.assert(financialStatement.Sales_Or_Net_Working_Capital__c  == 12.0);
        System.assert(financialStatement.Share_Premium__c  == 30);
        System.assert(financialStatement.Stock_Turnover_Ratio__c  == 13.0);
        System.assert(financialStatement.Tax__c  == 13);
        System.assert(financialStatement.Total_Assets__c  == 31);
        System.assert(financialStatement.Total_Current_Assets__c  == 32);
        System.assert(financialStatement.Total_Current_Liabilities__c  == 33);
        System.assert(financialStatement.Total_Debt_Ratio__c  == 15.0);
        System.assert(financialStatement.Total_Fixed_Assets__c  == 34);
        System.assert(financialStatement.Total_Intangible_Assets__c  == 35);
        System.assert(financialStatement.Total_Inventories__c  == 36);
        System.assert(financialStatement.Total_Liabilities__c  == 37);
        System.assert(financialStatement.Total_Long_Term_Liabilities__c  == 38);
        System.assert(financialStatement.Total_Other_Fixed_Assets__c  == 39);
        System.assert(financialStatement.Total_Receivables__c  == 40);
        System.assert(financialStatement.Total_Shareholders_Equity__c  == 41);
        System.assert(financialStatement.Total_Tangible_Assets__c  == 42);
        System.assert(financialStatement.Trade_Payables__c  == 43);
        System.assert(financialStatement.Trade_Payables_Due_After1year__c  == 44);
        System.assert(financialStatement.Trade_Receivables__c  == 45);
        System.assert(financialStatement.Wages_And_Salaries__c  == 14);
        System.assert(financialStatement.Work_In_Progress__c  == 46);
        System.assert(financialStatement.Working_Capital__c  == 1);
        System.assert(financialStatement.Year_End_Date__c  ==  Datetime.newInstance(2002, 12, 9).date());

        Creditsafe_Company_Financial_Statement__c lfinancialStatement = [
                SELECT
                        CreatedById,
                        CreatedDate,
                        Balance_Sheets_Consolidated_Accounts__c,
                        Bank_Liabilities__c,
                        Bank_Liabilities_Due_After1year__c,
                        Called_Up_Share_Capital__c,
                        Cash__c,
                        Consolidated_Accounts__c,
                        Creditor_Days__c,
                        Creditsafe_Company_Report_Full__c,
                        Currency__c,
                        Current_Debt_Ratio__c,
                        Current_Ratio__c,
                        Debtor_Days__c,
                        Depreciation__c,
                        Dividends__c,
                        Equity_In_Percentage__c,
                        Financial_Expenses__c,
                        Financial_Income__c,
                        Finished_Goods__c,
                        Gearing__c,
                        Goodwill__c,
                        Group_Payables__c,
                        Group_Payables_Due_After1year__c,
                        Group_Receivables__c,
                        Investments__c,
                        Land_And_Buildings__c,
                        Liquidity_Ratio_Or_Acid_Test__c,
                        Loans_To_Group__c,
                        Miscellaneous_Fixed_Assets__c,
                        Miscellaneous_Liabilities__c,
                        Miscellaneous_Liabilities_Due_After1year__c,
                        Miscellaneous_Receivables__c,
                        Net_Worth__c,
                        Number_Of_Weeks__c,
                        Operating_Costs__c,
                        Operating_Profit__c,
                        Other_Appropriations__c,
                        Other_Current_Assets__c,
                        Other_Intangible_Assets__c,
                        Other_Inventories__c,
                        Other_Loans__c,
                        Other_Loans_Or_Finance__c,
                        Other_Loans_Or_Finance_Due_After1year__c,
                        Other_Reserves__c,
                        Other_Tangible_Assets__c,
                        Pension_Costs__c,
                        Plant_And_Machinery__c,
                        Pre_Tax_Profit_Margin__c,
                        Profit_After_Tax__c,
                        Profit_Before_Tax__c,
                        Raw_Materials__c,
                        Receivables_Due_After1year__c,
                        Retained_Profit__c,
                        Return_On_Capital_Employed__c,
                        Return_On_Net_Assets_Employed__c,
                        Return_On_Total_Assets_Employed__c,
                        Revenue__c,
                        Revenue_Reserves__c,
                        Sales_Or_Net_Working_Capital__c,
                        Share_Premium__c,
                        Stock_Turnover_Ratio__c,
                        Tax__c,
                        Total_Assets__c,
                        Total_Current_Assets__c,
                        Total_Current_Liabilities__c,
                        Total_Debt_Ratio__c,
                        Total_Fixed_Assets__c,
                        Total_Intangible_Assets__c,
                        Total_Inventories__c,
                        Total_Liabilities__c,
                        Total_Long_Term_Liabilities__c,
                        Total_Other_Fixed_Assets__c,
                        Total_Receivables__c,
                        Total_Shareholders_Equity__c,
                        Total_Tangible_Assets__c,
                        Trade_Payables__c,
                        Trade_Payables_Due_After1year__c,
                        Trade_Receivables__c,
                        Type__c,
                        Wages_And_Salaries__c,
                        Work_In_Progress__c,
                        Working_Capital__c,
                        Year_End_Date__c,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        Name,
                        SystemModstamp
                FROM Creditsafe_Company_Financial_Statement__c WHERE Creditsafe_Company_Report_Full__c = :reportFull.Id AND Type__c = 'loc'];
        System.assert(lfinancialStatement.Balance_Sheets_Consolidated_Accounts__c == 5);
        System.assert(lfinancialStatement.Bank_Liabilities__c == 1);
        System.assert(lfinancialStatement.Bank_Liabilities_Due_After1year__c == 2);
        System.assert(lfinancialStatement.Called_Up_Share_Capital__c == 3);
        System.assert(lfinancialStatement.Cash__c  == 4);
        System.assert(lfinancialStatement.Consolidated_Accounts__c  ==  true);
        System.assert(lfinancialStatement.Creditor_Days__c  == 1.0);
        System.assert(lfinancialStatement.Currency__c  ==  '12');
        System.assert(lfinancialStatement.Current_Debt_Ratio__c  == 2.0);
        System.assert(lfinancialStatement.Current_Ratio__c  == 3.0);
        System.assert(lfinancialStatement.Debtor_Days__c  == 4.0);
        System.assert(lfinancialStatement.Depreciation__c  == 1);
        System.assert(lfinancialStatement.Dividends__c  == 2);
        System.assert(lfinancialStatement.Equity_In_Percentage__c  == 5.0);
        System.assert(lfinancialStatement.Financial_Expenses__c  == 3);
        System.assert(lfinancialStatement.Financial_Income__c  == 4);
        System.assert(lfinancialStatement.Finished_Goods__c  == 6);
        System.assert(lfinancialStatement.Gearing__c  == 6.0);
        System.assert(lfinancialStatement.Goodwill__c  == 7);
        System.assert(lfinancialStatement.Group_Payables__c  == 8);
        System.assert(lfinancialStatement.Group_Payables_Due_After1year__c  == 9);
        System.assert(lfinancialStatement.Group_Receivables__c  == 10);
        System.assert(lfinancialStatement.Investments__c  == 11);
        System.assert(lfinancialStatement.Land_And_Buildings__c  == 12);
        System.assert(lfinancialStatement.Liquidity_Ratio_Or_Acid_Test__c  == 7.0);
        System.assert(lfinancialStatement.Loans_To_Group__c  == 13);
        System.assert(lfinancialStatement.Miscellaneous_Fixed_Assets__c  == 14);
        System.assert(lfinancialStatement.Miscellaneous_Liabilities__c  == 15);
        System.assert(lfinancialStatement.Miscellaneous_Liabilities_Due_After1year__c  == 16);
        System.assert(lfinancialStatement.Miscellaneous_Receivables__c  == 17);
        System.assert(lfinancialStatement.Net_Worth__c  == 2);
        System.assert(lfinancialStatement.Number_Of_Weeks__c  == 3);
        System.assert(lfinancialStatement.Operating_Costs__c  == 5);
        System.assert(lfinancialStatement.Operating_Profit__c  == 6);
        System.assert(lfinancialStatement.Other_Appropriations__c  == 7);
        System.assert(lfinancialStatement.Other_Current_Assets__c  == 18);
        System.assert(lfinancialStatement.Other_Intangible_Assets__c  == 19);
        System.assert(lfinancialStatement.Other_Inventories__c  == 20);
        System.assert(lfinancialStatement.Other_Loans__c  == 21);
        System.assert(lfinancialStatement.Other_Loans_Or_Finance__c  == 22);
        System.assert(lfinancialStatement.Other_Loans_Or_Finance_Due_After1year__c  == 23);
        System.assert(lfinancialStatement.Other_Reserves__c  == 24);
        System.assert(lfinancialStatement.Other_Tangible_Assets__c  == 25);
        System.assert(lfinancialStatement.Pension_Costs__c  == 8);
        System.assert(lfinancialStatement.Plant_And_Machinery__c  == 26);
        System.assert(lfinancialStatement.Pre_Tax_Profit_Margin__c  == 8.0);
        System.assert(lfinancialStatement.Profit_After_Tax__c  == 9);
        System.assert(lfinancialStatement.Profit_Before_Tax__c  == 10);
        System.assert(lfinancialStatement.Raw_Materials__c  == 27);
        System.assert(lfinancialStatement.Receivables_Due_After1year__c  == 28);
        System.assert(lfinancialStatement.Retained_Profit__c  == 11);
        System.assert(lfinancialStatement.Return_On_Capital_Employed__c  == 9.0);
        System.assert(lfinancialStatement.Return_On_Net_Assets_Employed__c  == 10.0);
        System.assert(lfinancialStatement.Return_On_Total_Assets_Employed__c  == 11.0);
        System.assert(lfinancialStatement.Revenue__c  == 12);
        System.assert(lfinancialStatement.Revenue_Reserves__c  == 29);
        System.assert(lfinancialStatement.Sales_Or_Net_Working_Capital__c  == 12.0);
        System.assert(lfinancialStatement.Share_Premium__c  == 30);
        System.assert(lfinancialStatement.Stock_Turnover_Ratio__c  == 13.0);
        System.assert(lfinancialStatement.Tax__c  == 13);
        System.assert(lfinancialStatement.Total_Assets__c  == 31);
        System.assert(lfinancialStatement.Total_Current_Assets__c  == 32);
        System.assert(lfinancialStatement.Total_Current_Liabilities__c  == 33);
        System.assert(lfinancialStatement.Total_Debt_Ratio__c  == 15.0);
        System.assert(lfinancialStatement.Total_Fixed_Assets__c  == 34);
        System.assert(lfinancialStatement.Total_Intangible_Assets__c  == 35);
        System.assert(lfinancialStatement.Total_Inventories__c  == 36);
        System.assert(lfinancialStatement.Total_Liabilities__c  == 37);
        System.assert(lfinancialStatement.Total_Long_Term_Liabilities__c  == 38);
        System.assert(lfinancialStatement.Total_Other_Fixed_Assets__c  == 39);
        System.assert(lfinancialStatement.Total_Receivables__c  == 40);
        System.assert(lfinancialStatement.Total_Shareholders_Equity__c  == 41);
        System.assert(lfinancialStatement.Total_Tangible_Assets__c  == 42);
        System.assert(lfinancialStatement.Trade_Payables__c  == 43);
        System.assert(lfinancialStatement.Trade_Payables_Due_After1year__c  == 44);
        System.assert(lfinancialStatement.Trade_Receivables__c  == 45);
        System.assert(lfinancialStatement.Wages_And_Salaries__c  == 14);
        System.assert(lfinancialStatement.Work_In_Progress__c  == 46);
        System.assert(lfinancialStatement.Working_Capital__c  == 1);
        System.assert(lfinancialStatement.Year_End_Date__c  ==  Datetime.newInstance(2002, 12, 9).date());

        List<Creditsafe_Company_Key_Value__c> keyValue = [
                SELECT
                        CreatedById,
                        CreatedDate,
                        Creditsafe_Company_Report_Full__c,
                        Key__c,
                        Value__c,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        Name,
                        SystemModstamp
                FROM Creditsafe_Company_Key_Value__c WHERE Creditsafe_Company_Report_Full__c = :reportFull.Id];
        System.assert(keyValue.size() == 6);
        System.assert(keyValue[0].Key__c.startsWith('key') == true);
        System.assert(keyValue[0].Value__c.startsWith('value') == true);
        System.assert(keyValue[1].Key__c.startsWith('key') == true);
        System.assert(keyValue[1].Value__c.startsWith('value') == true);
        System.assert(keyValue[2].Key__c.startsWith('key') == true);
        System.assert(keyValue[2].Value__c.startsWith('value') == true);

        Creditsafe_Company_Share_Holder__c shareHolder = [
                SELECT
                        CreatedById,
                        CreatedDate,
                        Creditsafe_Company_Report_Full__c,
                        Name__c,
                        Share_Percent__c,
                        City__c,
                        Country__c,
                        Full_Address__c,
                        House_Number__c,
                        House_Number_Addition__c,
                        Postcode__c,
                        Street__c,
                        Telephone__c,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        Name,
                        SystemModstamp
                FROM Creditsafe_Company_Share_Holder__c WHERE Creditsafe_Company_Report_Full__c = :reportFull.Id];
        System.assert(shareHolder.Name__c == 'shareholder');
        System.assert(shareHolder.Share_Percent__c == 100);
        System.assert(shareHolder.City__c == 'shareholder city');
        System.assert(shareHolder.Country__c == 'shareholder country');
        System.assert(shareHolder.Full_Address__c == 'shareholder full_address');
        System.assert(shareHolder.House_Number__c == '1');
        System.assert(shareHolder.Postcode__c == '1212');
        System.assert(shareHolder.Street__c == 'shareholder street');
        System.assert(shareHolder.Telephone__c == '987654321');

        Negative_Information_DE_Director_Event__c directorEvent = [
                SELECT
                        CreatedById,
                        CreatedDate,
                        Code__c,
                        Creditsafe_Company_Report_Full__c,
                        Date__c,
                        Description__c,
                        Name__c,
                        Type__c,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        Name,
                        SystemModstamp
                FROM Negative_Information_DE_Director_Event__c WHERE Creditsafe_Company_Report_Full__c = :reportFull.Id];
        System.assert(directorEvent.Name__c == 'name');
        System.assert(directorEvent.Type__c == 'type');
        System.assert(directorEvent.Date__c == Datetime.newInstance(2020,1,1).date());
        System.assert(directorEvent.Description__c == 'description');
        System.assert(directorEvent.Code__c == 'code');

        Negative_Information_DE_Insolvency_Event__c insolvencyEvent = [
                SELECT
                        CreatedById,
                        CreatedDate,
                        Created_At__c,
                        Creditsafe_Company_Report_Full__c,
                        Reference_Number_Court__c,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        Name,
                        SystemModstamp
                FROM Negative_Information_DE_Insolvency_Event__c WHERE Creditsafe_Company_Report_Full__c = :reportFull.Id];
        System.assert(insolvencyEvent.Created_At__c == Datetime.newInstance(2020, 2,12).date());
        System.assert(insolvencyEvent.Reference_Number_Court__c == 'court');

        Creditsafe_Company_Advisor__c advisor = [
                SELECT
                        CreatedById,
                        CreatedDate,
                        Auditor_Name__c,
                        Creditsafe_Company_Report_Full__c,
                        Solicitor_Name__c,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        Name,
                        SystemModstamp
                FROM Creditsafe_Company_Advisor__c WHERE Creditsafe_Company_Report_Full__c = :reportFull.Id];
        System.assert(advisor.Auditor_Name__c == 'auditor_name');
        System.assert(advisor.Solicitor_Name__c == 'solicitor_name');

        Creditsafe_Company_Banker__c banker = [
                SELECT
                        CreatedById,
                        CreatedDate,
                        Bank_Code__c,
                        Creditsafe_Company_Report_Full__c,
                        Name__c,
                        City__c,
                        Country__c,
                        Full_Address__c,
                        House_Number__c,
                        House_Number_Addition__c,
                        Postcode__c,
                        Street__c,
                        Telephone__c,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        Name,
                        SystemModstamp
                FROM Creditsafe_Company_Banker__c WHERE Creditsafe_Company_Report_Full__c = :reportFull.Id];
        System.assert(banker.Bank_Code__c == '1212');
        System.assert(banker.Name__c == 'bank');
        System.assert(banker.Country__c == 'bank country');
        System.assert(banker.House_Number__c == '1');
        System.assert(banker.Full_Address__c == 'bank full_address');
        System.assert(banker.Telephone__c == '987654321');
        System.assert(banker.Street__c == 'bank street');
        System.assert(banker.City__c == 'bank city');
        System.assert(banker.Postcode__c == '1212');

        Creditsafe_Company_Negative_Info_NL__c negativeInfoNL = [
                SELECT
                        CreatedById,
                        CreatedDate,
                        Address__c,
                        Court_Action__c,
                        Creditsafe_Company_Report_Full__c,
                        Date_Of_Bankruptcy__c,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        Name,
                        SystemModstamp
                FROM Creditsafe_Company_Negative_Info_NL__c WHERE Creditsafe_Company_Report_Full__c = :reportFull.Id];
        System.assert(negativeInfoNL.Address__c == 'address');
        System.assert(negativeInfoNL.Court_Action__c == 'action');
        System.assert(negativeInfoNL.Date_Of_Bankruptcy__c == Datetime.newInstance(2020,1,1).date());

        Creditsafe_Company_Employee_Information__c employeeInformation = [
                SELECT
                        CreatedById,
                        CreatedDate,
                        Creditsafe_Company_Report_Full__c,
                        Number_Of_Employees__c,
                        Year__c,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        Name,
                        SystemModstamp
                FROM Creditsafe_Company_Employee_Information__c WHERE Creditsafe_Company_Report_Full__c = :reportFull.Id];
        System.assert(employeeInformation.Number_Of_Employees__c == 21);
        System.assert(employeeInformation.Year__c == 2020);

    }

    @TestVisible
    private static CreditsafeWsdl.CreditsafeCompanyReportFullV2 createCompanyReportFullV2Mock() {
        CreditsafeWsdl.CreditsafeCompanyReportFullV2 reportFullV2 = new CreditsafeWsdl.CreditsafeCompanyReportFullV2();
        reportFullV2.additional_information = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationV2();
        reportFullV2.additional_information.de = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationDEAdditionalInformationV2();

        reportFullV2.additional_information.de.miscellaneous = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationDEMiscellaneousV2();
        reportFullV2.additional_information.de.miscellaneous.fax_number = '1';
        reportFullV2.additional_information.de.miscellaneous.negative_rating = '12';
        reportFullV2.additional_information.de.miscellaneous.business_purpose = 'business_purpose';
        reportFullV2.additional_information.de.miscellaneous.complementary_company = 'complementary_company';
        reportFullV2.additional_information.de.miscellaneous.company_type = 'company_type';
        reportFullV2.additional_information.de.miscellaneous.small_office = 'small';
        reportFullV2.additional_information.de.miscellaneous.financials_quality = '2';
        reportFullV2.additional_information.de.miscellaneous.commercial_register_zip = '123';
        reportFullV2.additional_information.de.miscellaneous.commercial_register_city = 'commercial_register_city';
        reportFullV2.additional_information.de.miscellaneous.turnover_range = '1234';
        reportFullV2.additional_information.de.miscellaneous.current_rating = new CreditsafeWsdl.CreditsafeValueV2();
        reportFullV2.additional_information.de.miscellaneous.current_rating.value = '1';
        reportFullV2.additional_information.de.miscellaneous.current_rating.min_value = '0';
        reportFullV2.additional_information.de.miscellaneous.current_rating.max_value = '5';
        reportFullV2.additional_information.de.miscellaneous.previous_rating = new CreditsafeWsdl.CreditsafeValueV2();
        reportFullV2.additional_information.de.miscellaneous.previous_rating.value = '0';
        reportFullV2.additional_information.de.miscellaneous.previous_rating.min_value = '0';
        reportFullV2.additional_information.de.miscellaneous.previous_rating.max_value = '5';
        reportFullV2.additional_information.de.miscellaneous.premise_type = 'premise';

        reportFullV2.additional_information.de.image_accounts = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationDEImageAccountV2();
        reportFullV2.additional_information.de.image_accounts.start_date = Datetime.newInstance(2020, 02, 13 );
        reportFullV2.additional_information.de.image_accounts.published_date = Datetime.newInstance(2020, 02, 14);
        reportFullV2.additional_information.de.image_accounts.financials_type = 'financials_type';
        reportFullV2.additional_information.de.image_accounts.end_date = Datetime.newInstance(2020, 12, 31);
        reportFullV2.additional_information.de.image_accounts.document_type = 'document_type';
        reportFullV2.additional_information.de.image_accounts.serial_number = '123123';

        reportFullV2.additional_information.de.beneficiary_owners = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationDEOwnerV2();
        reportFullV2.additional_information.de.beneficiary_owners.share_percent = '10';
        reportFullV2.additional_information.de.beneficiary_owners.name = 'beneficiary_owners_name';
        reportFullV2.additional_information.de.beneficiary_owners.city = 'beneficiary_owners_city';
        reportFullV2.additional_information.de.beneficiary_owners.country = 'beneficiary_owners_country';
        reportFullV2.additional_information.de.beneficiary_owners.postal_code = 'beneficiary_owners_postal_code';

        reportFullV2.additional_information.de.turnover_ranges = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationDETurnoverRangeV2();
        reportFullV2.additional_information.de.turnover_ranges.year = 2020;
        reportFullV2.additional_information.de.turnover_ranges.range = '1000-5000';

        reportFullV2.additional_information.de.comments = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationCommentV2Array();
        reportFullV2.additional_information.de.comments.item = new List<CreditsafeWsdl.CreditsafeCompanyAdditionalInformationCommentV2>();
        for (Integer i = 0; i < 2; i++) {
            CreditsafeWsdl.CreditsafeCompanyAdditionalInformationCommentV2 commentV2 = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationCommentV2();
            commentV2.sentiment = 'sentiment' + i;
            commentV2.text = 'text' + i;
            reportFullV2.additional_information.de.comments.item.add(commentV2);
        }

        reportFullV2.additional_information.de.historical_events = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationHistoricalEventV2Array();
        reportFullV2.additional_information.de.historical_events.item = new List<CreditsafeWsdl.CreditsafeCompanyAdditionalInformationHistoricalEventV2>();
        for (Integer i = 0; i < 2; i++) {
            CreditsafeWsdl.CreditsafeCompanyAdditionalInformationHistoricalEventV2 historicalEventV2 = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationHistoricalEventV2();
            historicalEventV2.description = 'description';
            historicalEventV2.date_x = Datetime.newInstance(2020, 1, 1);
            historicalEventV2.current_value = 'current_value';
            historicalEventV2.previous_value = 'previous_value';
            reportFullV2.additional_information.de.historical_events.item.add(historicalEventV2);
        }

        reportFullV2.additional_information.nl = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLAdditionalInformationV2();
        reportFullV2.additional_information.nl.payment_expectations_summary = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLPaymentExpectationsSummaryV2();
        reportFullV2.additional_information.nl.payment_expectations_summary.day_sales_outstanding = 20;
        reportFullV2.additional_information.nl.payment_expectations_summary.payment_expectation_days = 10;
        reportFullV2.additional_information.nl.payment_expectations_summary.industry_average_day_sales_outstanding = 21;
        reportFullV2.additional_information.nl.payment_expectations_summary.industry_average_payment_expectation_days = 25;
        reportFullV2.additional_information.nl.payment_expectations_summary.suspension_of_payments_mora = 'mora';

        reportFullV2.additional_information.nl.miscellaneous = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLMiscellaneousV2();
        reportFullV2.additional_information.nl.miscellaneous.negative_rating = 0;
        reportFullV2.additional_information.nl.miscellaneous.branch_number = '10';
        reportFullV2.additional_information.nl.miscellaneous.rsin_number = '11';
        reportFullV2.additional_information.nl.miscellaneous.importer = '12';
        reportFullV2.additional_information.nl.miscellaneous.exporter = '13';
        reportFullV2.additional_information.nl.miscellaneous.date_of_cessation_trading = Datetime.newInstance(2020, 1, 2);
        reportFullV2.additional_information.nl.miscellaneous.date_of_legal_form = Datetime.newInstance(2020, 2, 2);

        reportFullV2.additional_information.nl.industy_comparison = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLIndustryComparisonV2();
        reportFullV2.additional_information.nl.industy_comparison.industry_average_credit_rating = 2;
        reportFullV2.additional_information.nl.industy_comparison.industry_average_credit_limit = 5;

        reportFullV2.additional_information.nl.industry_quartile_analysis = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLIndustryQuartileAnalysisV2();
        reportFullV2.additional_information.nl.industry_quartile_analysis.payment_expectation_days = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLIndustryQuartileAnalysisDayV2();
        reportFullV2.additional_information.nl.industry_quartile_analysis.payment_expectation_days.upper = 10;
        reportFullV2.additional_information.nl.industry_quartile_analysis.payment_expectation_days.median = 5;
        reportFullV2.additional_information.nl.industry_quartile_analysis.payment_expectation_days.lower = 0;
        reportFullV2.additional_information.nl.industry_quartile_analysis.day_sales_outstanding = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLIndustryQuartileAnalysisDayV2();
        reportFullV2.additional_information.nl.industry_quartile_analysis.day_sales_outstanding.upper = 10;
        reportFullV2.additional_information.nl.industry_quartile_analysis.day_sales_outstanding.median = 5;
        reportFullV2.additional_information.nl.industry_quartile_analysis.day_sales_outstanding.lower = 0;

        reportFullV2.additional_information.nl.comments = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationCommentV2Array();
        reportFullV2.additional_information.nl.comments.item = new List<CreditsafeWsdl.CreditsafeCompanyAdditionalInformationCommentV2>();
        for (Integer i = 0; i < 2; i++) {
            CreditsafeWsdl.CreditsafeCompanyAdditionalInformationCommentV2 commentV2 = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationCommentV2();
            commentV2.sentiment = 'sentiment' + i;
            commentV2.text = 'text' + i;
            reportFullV2.additional_information.nl.comments.item.add(commentV2);
        }

        reportFullV2.additional_information.nl.historical_events = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationHistoricalEventV2Array();
        reportFullV2.additional_information.nl.historical_events.item = new List<CreditsafeWsdl.CreditsafeCompanyAdditionalInformationHistoricalEventV2>();
        for (Integer i = 0; i < 2; i++) {
            CreditsafeWsdl.CreditsafeCompanyAdditionalInformationHistoricalEventV2 historicalEventV2 = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationHistoricalEventV2();
            historicalEventV2.description = 'description';
            historicalEventV2.date_x = Datetime.newInstance(2020, 1, 1);
            historicalEventV2.current_value = 'current_value';
            historicalEventV2.previous_value = 'previous_value';
            reportFullV2.additional_information.nl.historical_events.item.add(historicalEventV2);
        }

        reportFullV2.additional_information.nl.financial_items = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLFinancialItemV2Array();
        reportFullV2.additional_information.nl.financial_items.item = new List<CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLFinancialItemV2>();
        for (Integer i = 0; i < 2; i++) {
            CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLFinancialItemV2 financialItemV2 = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLFinancialItemV2();
            financialItemV2.consolidated_subsidiaries = 'consolidated_subsidiaries' + i;
            financialItemV2.judgement = 'judgement' + i;
            financialItemV2.date_year_end = Datetime.newInstance(2020, 5, 5);
            reportFullV2.additional_information.nl.financial_items.item.add(financialItemV2);
        }

        reportFullV2.additional_information.nl.kvk_filings = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLKvkFilingV2Array();
        reportFullV2.additional_information.nl.kvk_filings.item = new List<CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLKvkFilingV2>();
        for (Integer i = 0; i < 2; i++) {
            CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLKvkFilingV2 kvkFilingV2 = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLKvkFilingV2();
            kvkFilingV2.date_x = Datetime.newInstance(2020, 1, 11);
            kvkFilingV2.event = 'event';
            reportFullV2.additional_information.nl.kvk_filings.item.add(kvkFilingV2);
        }

        reportFullV2.additional_information.nl.letters_of_liablility_information403 = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLLetterOfLiabilityInformation403V2Array();
        reportFullV2.additional_information.nl.letters_of_liablility_information403.item = new List<CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLLetterOfLiabilityInformation403V2>();
        for (Integer i = 0; i < 2; i++) {
            CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLLetterOfLiabilityInformation403V2 liabilityInformation403V2 = new CreditsafeWsdl.CreditsafeCompanyAdditionalInformationNLLetterOfLiabilityInformation403V2();
            liabilityInformation403V2.financial_year = 2020;
            liabilityInformation403V2.date_submitted = Datetime.newInstance(2020, 1, 1);
            liabilityInformation403V2.company_number = '12' + i;
            liabilityInformation403V2.company_name = 'company_name' + i;
            liabilityInformation403V2.letter_of_liability1_removal_submitted_parent2 = Datetime.newInstance(2020, 1, 2);
            liabilityInformation403V2.letter_of_liability1_removal_submitted = Datetime.newInstance(2020, 1, 3);
            liabilityInformation403V2.letter_of_liability1_submitted_date_parent2 = Datetime.newInstance(2020, 1, 4);
            liabilityInformation403V2.letter_of_liability1_submitted_date = Datetime.newInstance(2020, 1, 5);
            liabilityInformation403V2.letter_of_liability1_start_date_parent2 = Datetime.newInstance(2020, 1, 6);
            liabilityInformation403V2.letter_of_liability1_start_date = Datetime.newInstance(2020, 1, 7);
            liabilityInformation403V2.letter_of_liability1_removal_date = Datetime.newInstance(2020, 1, 8);
            liabilityInformation403V2.letter_of_liability1_removal_date_parent2 = Datetime.newInstance(2020, 1, 9);
            liabilityInformation403V2.letter_of_liability2_removal_date = Datetime.newInstance(2020, 1, 10);
            liabilityInformation403V2.letter_of_liability2_removal_date_parent2 = Datetime.newInstance(2020, 1, 11);
            liabilityInformation403V2.letter_of_liability2_removal_submitted_parent2 = Datetime.newInstance(2020, 1, 12);
            liabilityInformation403V2.letter_of_liability2_start_date = Datetime.newInstance(2020, 1, 13);
            liabilityInformation403V2.letter_of_liability2_start_date_parent2 = Datetime.newInstance(2020, 1, 14);
            liabilityInformation403V2.letter_of_liability2_submitted_date_parent2 = Datetime.newInstance(2020, 1, 15);
            liabilityInformation403V2.letter_of_liability2_removal_submitted = Datetime.newInstance(2020, 1, 16);
            liabilityInformation403V2.letter_of_liability2_submitted_date = Datetime.newInstance(2020, 1, 17);
            reportFullV2.additional_information.nl.letters_of_liablility_information403.item.add(liabilityInformation403V2);
        }

        reportFullV2.additional_information.generic = new CreditsafeWsdl.CreditsafeCompanyKeyValueV2Array();
        reportFullV2.additional_information.generic.item = new List<CreditsafeWsdl.CreditsafeCompanyKeyValueV2>();
        for (Integer i = 0; i < 2; i++) {
            CreditsafeWsdl.CreditsafeCompanyKeyValueV2 keyValueV2 = new CreditsafeWsdl.CreditsafeCompanyKeyValueV2();
            keyValueV2.value = 'value'+ i;
            keyValueV2.key = 'key' + i;
            reportFullV2.additional_information.generic.item.add(keyValueV2);
        }

        reportFullV2.company_identification = new CreditsafeWsdl.CreditsafeCompanyIdentificationV2();
        reportFullV2.company_identification.basic_information = new CreditsafeWsdl.CreditsafeCompanyBasicInformationV2();
        reportFullV2.company_identification.basic_information.country = 'country';
        reportFullV2.company_identification.basic_information.business_name = 'business_name';
        reportFullV2.company_identification.basic_information.company_registration_number = '111';
        reportFullV2.company_identification.basic_information.dateof_company_registration = Datetime.newInstance(2010, 1,1);
        reportFullV2.company_identification.basic_information.vat_registration_number = '1212';
        reportFullV2.company_identification.basic_information.registered_company_name = 'registered_company_name';
        reportFullV2.company_identification.basic_information.dateof_starting_operations = Datetime.newInstance(2010, 1,1);
        reportFullV2.company_identification.basic_information.company_status = new CreditsafeWsdl.CreditsafeCompanyStatusV2();
        reportFullV2.company_identification.basic_information.company_status.description = 'company_status.description';
        reportFullV2.company_identification.basic_information.company_status.status = 'company_status.status';
        reportFullV2.company_identification.basic_information.principal_activity = new CreditsafeWsdl.CreditsafeDescriptionV2();
        reportFullV2.company_identification.basic_information.principal_activity.description = 'principal_activity.description';
        reportFullV2.company_identification.basic_information.principal_activity.value = 'principal_activity.value';
        reportFullV2.company_identification.basic_information.principal_activity.code = 'principal_activity.code';
        reportFullV2.company_identification.basic_information.contact_address = new CreditsafeWsdl.CreditsafeAddressV2();
        reportFullV2.company_identification.basic_information.contact_address.country = 'contact_address.country';
        reportFullV2.company_identification.basic_information.contact_address.postal_code = 'contact_address.postal_code';
        reportFullV2.company_identification.basic_information.contact_address.city = 'contact_address.city';
        reportFullV2.company_identification.basic_information.contact_address.street = 'contact_address.street';
        reportFullV2.company_identification.basic_information.contact_address.telephone = '121212121212';
        reportFullV2.company_identification.basic_information.contact_address.full_address = 'contact_address.full_address';
        reportFullV2.company_identification.basic_information.contact_address.house_number = '123';
        reportFullV2.company_identification.basic_information.legal_form = new  CreditsafeWsdl.CreditsafeDescriptionV2();
        reportFullV2.company_identification.basic_information.legal_form.code = 'legal_form.code';
        reportFullV2.company_identification.basic_information.legal_form.value = 'legal_form.value';
        reportFullV2.company_identification.basic_information.legal_form.description = 'legal_form.description';

        reportFullV2.company_identification.activity_classifications = new CreditsafeWsdl.CreditsafeCompanyActivityClassificationV2Array();
        reportFullV2.company_identification.activity_classifications.item = new List<CreditsafeWsdl.CreditsafeCompanyActivityClassificationV2>();
        CreditsafeWsdl.CreditsafeCompanyActivityClassificationV2 activityClassificationV2 = new CreditsafeWsdl.CreditsafeCompanyActivityClassificationV2();
        activityClassificationV2.classification = 'classification';
        activityClassificationV2.activities = new CreditsafeWsdl.CreditsafeCompanyActivityV2Array();
        activityClassificationV2.activities.item = new List<CreditsafeWsdl.CreditsafeCompanyActivityV2>();
        CreditsafeWsdl.CreditsafeCompanyActivityV2 companyActivityV2 = new CreditsafeWsdl.CreditsafeCompanyActivityV2();
        companyActivityV2.classification = 'classification';
        companyActivityV2.activity_description = 'activity_description';
        companyActivityV2.activity_code = 'activity_code';
        activityClassificationV2.activities.item.add(companyActivityV2);
        reportFullV2.company_identification.activity_classifications.item.add(activityClassificationV2);

        reportFullV2.company_summary = new CreditsafeWsdl.CreditsafeCompanySummaryV2();
        reportFullV2.company_summary.company_status = new CreditsafeWsdl.CreditsafeCompanyStatusV2();
        reportFullV2.company_summary.company_status.description = 'company_status.description';
        reportFullV2.company_summary.company_status.status = 'company_status.status';
        reportFullV2.company_summary.credit_rating = new CreditsafeWsdl.CreditsafeCompanyCreditRatingV2();
        reportFullV2.company_summary.credit_rating.credit_limit = '100';
        reportFullV2.company_summary.credit_rating.common_description = 'credit_rating.common_description';
        reportFullV2.company_summary.credit_rating.common_value = 'credit_rating.common_value';
        reportFullV2.company_summary.credit_rating.provider_description = 'credit_rating.provider_description';
        reportFullV2.company_summary.credit_rating.provider_value = new CreditsafeWsdl.CreditsafeValueV2();
        reportFullV2.company_summary.credit_rating.provider_value.value = '10';
        reportFullV2.company_summary.credit_rating.provider_value.max_value = '20';
        reportFullV2.company_summary.credit_rating.provider_value.min_value = '0';
        reportFullV2.company_summary.main_activity = new CreditsafeWsdl.CreditsafeCompanyActivityV2();
        reportFullV2.company_summary.main_activity.activity_code = '1212';
        reportFullV2.company_summary.main_activity.activity_description = 'activity_description';
        reportFullV2.company_summary.main_activity.classification = 'classification';
        reportFullV2.company_summary.country = 'country';
        reportFullV2.company_summary.company_registration_number = '202020';
        reportFullV2.company_summary.latest_turnover_figure = 2;
        reportFullV2.company_summary.latest_shareholders_equity_figure = 3;
        reportFullV2.company_summary.number_x = '9';
        reportFullV2.company_summary.business_name = 'business_name';

        reportFullV2.contact_information = new CreditsafeWsdl.CreditsafeCompanyContactInformationV2();
        reportFullV2.contact_information.main_address = new CreditsafeWsdl.CreditsafeAddressV2();
        reportFullV2.contact_information.main_address.country = 'country';
        reportFullV2.contact_information.main_address.house_number = '1';
        reportFullV2.contact_information.main_address.full_address = 'full_address';
        reportFullV2.contact_information.main_address.telephone = '987654321';
        reportFullV2.contact_information.main_address.street = 'street';
        reportFullV2.contact_information.main_address.city = 'city';
        reportFullV2.contact_information.main_address.postal_code = '1212';
        reportFullV2.contact_information.other_addresses = new CreditsafeWsdl.CreditsafeAddressV2Array();
        reportFullV2.contact_information.other_addresses.item = new List<CreditsafeWsdl.CreditsafeAddressV2>();
        CreditsafeWsdl.CreditsafeAddressV2 addressV2 = new CreditsafeWsdl.CreditsafeAddressV2();
        addressV2.country = 'country';
        addressV2.house_number = '1';
        addressV2.full_address = 'full_address';
        addressV2.telephone = '987654321';
        addressV2.street = 'street';
        addressV2.city = 'city';
        addressV2.postal_code = '1212';
        reportFullV2.contact_information.other_addresses.item.add(addressV2);

        reportFullV2.credit_score = new CreditsafeWsdl.CreditsafeCompanyCreditScoreV2();
        reportFullV2.credit_score.current_credit_rating = new CreditsafeWsdl.CreditsafeCompanyCreditRatingV2();
        reportFullV2.credit_score.current_credit_rating.credit_limit = '1000';
        reportFullV2.credit_score.current_credit_rating.common_description = 'current_credit_rating.common_description';
        reportFullV2.credit_score.current_credit_rating.common_value = 'current_credit_rating.common_value';
        reportFullV2.credit_score.current_credit_rating.provider_description = 'current_credit_rating.provider_description';
        reportFullV2.credit_score.current_credit_rating.provider_value = new CreditsafeWsdl.CreditsafeValueV2();
        reportFullV2.credit_score.current_credit_rating.provider_value.value = '100';
        reportFullV2.credit_score.current_credit_rating.provider_value.max_value = '200';
        reportFullV2.credit_score.current_credit_rating.provider_value.min_value = '0';
        reportFullV2.credit_score.previous_credit_rating = new CreditsafeWsdl.CreditsafeCompanyCreditRatingV2();
        reportFullV2.credit_score.previous_credit_rating.credit_limit = '1000';
        reportFullV2.credit_score.previous_credit_rating.common_description = 'previous_credit_rating.common_description';
        reportFullV2.credit_score.previous_credit_rating.common_value = 'previous_credit_rating.common_value';
        reportFullV2.credit_score.previous_credit_rating.provider_description = 'previous_credit_rating.provider_description';
        reportFullV2.credit_score.previous_credit_rating.provider_value = new CreditsafeWsdl.CreditsafeValueV2();
        reportFullV2.credit_score.previous_credit_rating.provider_value.value = '101';
        reportFullV2.credit_score.previous_credit_rating.provider_value.max_value = '201';
        reportFullV2.credit_score.previous_credit_rating.provider_value.min_value = '0';

        reportFullV2.directors = new CreditsafeWsdl.CreditsafePersonDirectorsV2();
        reportFullV2.directors.current_directors = new CreditsafeWsdl.CreditsafePersonDirectorV2Array();
        reportFullV2.directors.current_directors.item = new List<CreditsafeWsdl.CreditsafePersonDirectorV2>();
        CreditsafeWsdl.CreditsafePersonDirectorV2 currentDirectorV2 = new CreditsafeWsdl.CreditsafePersonDirectorV2();
        currentDirectorV2.name = 'cr name';
        currentDirectorV2.id = 'cr id';
        currentDirectorV2.gender = 'cr gender';
        currentDirectorV2.date_of_birth = Datetime.newInstance(1970, 2, 1);
        currentDirectorV2.director_type = 'ceo';
        currentDirectorV2.address = new CreditsafeWsdl.CreditsafeAddressV2();
        currentDirectorV2.address.country = 'cr country';
        currentDirectorV2.address.house_number = '1';
        currentDirectorV2.address.full_address = 'cr full_address';
        currentDirectorV2.address.telephone = '987654321';
        currentDirectorV2.address.street = 'cr street';
        currentDirectorV2.address.city = 'cr city';
        currentDirectorV2.address.postal_code = '1212';
        currentDirectorV2.positions = new CreditsafeWsdl.CreditsafePersonPositionV2Array();
        currentDirectorV2.positions.item = new List<CreditsafeWsdl.CreditsafePersonPositionV2>();
        CreditsafeWsdl.CreditsafePersonPositionV2 positionV2 = new CreditsafeWsdl.CreditsafePersonPositionV2();
        positionV2.name = 'current dir';
        positionV2.date_appointed = Datetime.newInstance(2001, 1,1);
        currentDirectorV2.positions.item.add(positionV2);
        reportFullV2.directors.current_directors.item.add(currentDirectorV2);

        reportFullV2.directors.previous_directors = new CreditsafeWsdl.CreditsafePersonPreviousDirectorV2Array();
        reportFullV2.directors.previous_directors.item = new List<CreditsafeWsdl.CreditsafePersonPreviousDirectorV2>();
        CreditsafeWsdl.CreditsafePersonPreviousDirectorV2 previousDirectorV2 = new CreditsafeWsdl.CreditsafePersonPreviousDirectorV2();
        previousDirectorV2.name = 'pr name';
        previousDirectorV2.id = 'pr id';
        previousDirectorV2.gender = 'pr gender';
        previousDirectorV2.date_of_birth = Datetime.newInstance(1970, 2, 1);
        previousDirectorV2.director_type = 'cto';
        previousDirectorV2.address = new CreditsafeWsdl.CreditsafeAddressV2();
        previousDirectorV2.address.country = 'pr country';
        previousDirectorV2.address.house_number = '1';
        previousDirectorV2.address.full_address = 'pr full_address';
        previousDirectorV2.address.telephone = '987654321';
        previousDirectorV2.address.street = 'pr street';
        previousDirectorV2.address.city = 'pr city';
        previousDirectorV2.address.postal_code = '1212';
        previousDirectorV2.positions = new CreditsafeWsdl.CreditsafePersonPositionV2Array();
        previousDirectorV2.positions.item = new List<CreditsafeWsdl.CreditsafePersonPositionV2>();
        CreditsafeWsdl.CreditsafePersonPositionV2 positionV21 = new CreditsafeWsdl.CreditsafePersonPositionV2();
        positionV21.name = 'prev dir';
        positionV21.date_appointed = Datetime.newInstance(2001, 1,1);
        previousDirectorV2.positions.item.add(positionV21);
        reportFullV2.directors.previous_directors.item.add(previousDirectorV2);

        reportFullV2.financial_statements = new CreditsafeWsdl.CreditsafeCompanyFinancialStatementV2Array();
        reportFullV2.financial_statements.item = new List<CreditsafeWsdl.CreditsafeCompanyFinancialStatementV2>();
        CreditsafeWsdl.CreditsafeCompanyFinancialStatementV2 financialStatementV2 = new CreditsafeWsdl.CreditsafeCompanyFinancialStatementV2();
        financialStatementV2.type_x = 'fin';
        financialStatementV2.year_end_date = Datetime.newInstance(2002, 12, 9);
        financialStatementV2.ratios = new CreditsafeWsdl.CreditsafeCompanyRatiosV2();
        financialStatementV2.ratios.creditor_days = 1;
        financialStatementV2.ratios.current_debt_ratio = 2;
        financialStatementV2.ratios.current_ratio = 3;
        financialStatementV2.ratios.debtor_days = 4;
        financialStatementV2.ratios.equity_in_percentage = 5;
        financialStatementV2.ratios.gearing = 6;
        financialStatementV2.ratios.liquidity_ratio_or_acid_test = 7;
        financialStatementV2.ratios.pre_tax_profit_margin = 8;
        financialStatementV2.ratios.return_on_capital_employed = 9;
        financialStatementV2.ratios.return_on_net_assets_employed = 10;
        financialStatementV2.ratios.return_on_total_assets_employed = 11;
        financialStatementV2.ratios.sales_or_net_working_capital = 12;
        financialStatementV2.ratios.stock_turnover_ratio = 13;
        financialStatementV2.ratios.total_debt_ratio = 15;
        financialStatementV2.profit_and_loss = new CreditsafeWsdl.CreditsafeCompanyProfitAndLossV2();
        financialStatementV2.profit_and_loss.depreciation = 1;
        financialStatementV2.profit_and_loss.dividends = 2;
        financialStatementV2.profit_and_loss.financial_expenses = 3;
        financialStatementV2.profit_and_loss.financial_income = 4;
        financialStatementV2.profit_and_loss.operating_costs = 5;
        financialStatementV2.profit_and_loss.operating_profit = 6;
        financialStatementV2.profit_and_loss.other_appropriations = 7;
        financialStatementV2.profit_and_loss.pension_costs = 8;
        financialStatementV2.profit_and_loss.profit_after_tax = 9;
        financialStatementV2.profit_and_loss.profit_before_tax = 10;
        financialStatementV2.profit_and_loss.retained_profit = 11;
        financialStatementV2.profit_and_loss.revenue = 12;
        financialStatementV2.profit_and_loss.tax = 13;
        financialStatementV2.profit_and_loss.wages_and_salaries = 14;
        financialStatementV2.balance_sheet = new CreditsafeWsdl.CreditsafeCompanyBalanceSheetV2();
        financialStatementV2.balance_sheet.bank_liabilities = 1;
        financialStatementV2.balance_sheet.bank_liabilities_due_after1year = 2;
        financialStatementV2.balance_sheet.called_up_share_capital = 3;
        financialStatementV2.balance_sheet.cash = 4;
        financialStatementV2.balance_sheet.consolidated_accounts = 5;
        financialStatementV2.balance_sheet.finished_goods = 6;
        financialStatementV2.balance_sheet.goodwill = 7;
        financialStatementV2.balance_sheet.group_payables = 8;
        financialStatementV2.balance_sheet.group_payables_due_after1year = 9;
        financialStatementV2.balance_sheet.group_receivables = 10;
        financialStatementV2.balance_sheet.investments = 11;
        financialStatementV2.balance_sheet.land_and_buildings = 12;
        financialStatementV2.balance_sheet.loans_to_group = 13;
        financialStatementV2.balance_sheet.miscellaneous_fixed_assets = 14;
        financialStatementV2.balance_sheet.miscellaneous_liabilities = 15;
        financialStatementV2.balance_sheet.miscellaneous_liabilities_due_after1_year = 16;
        financialStatementV2.balance_sheet.miscellaneous_receivables = 17;
        financialStatementV2.balance_sheet.other_current_assets = 18;
        financialStatementV2.balance_sheet.other_intangible_assets = 19;
        financialStatementV2.balance_sheet.other_inventories = 20;
        financialStatementV2.balance_sheet.other_loans = 21;
        financialStatementV2.balance_sheet.other_loans_or_finance = 22;
        financialStatementV2.balance_sheet.other_loans_or_finance_due_after1_year = 23;
        financialStatementV2.balance_sheet.other_reserves = 24;
        financialStatementV2.balance_sheet.other_tangible_assets = 25;
        financialStatementV2.balance_sheet.plant_and_machinery = 26;
        financialStatementV2.balance_sheet.raw_materials = 27;
        financialStatementV2.balance_sheet.receivables_due_after1year = 28;
        financialStatementV2.balance_sheet.revenue_reserves = 29;
        financialStatementV2.balance_sheet.share_premium = 30;
        financialStatementV2.balance_sheet.total_assets = 31;
        financialStatementV2.balance_sheet.total_current_assets = 32;
        financialStatementV2.balance_sheet.total_current_liabilities = 33;
        financialStatementV2.balance_sheet.total_fixed_assets = 34;
        financialStatementV2.balance_sheet.total_intangible_assets = 35;
        financialStatementV2.balance_sheet.total_inventories = 36;
        financialStatementV2.balance_sheet.total_liabilities = 37;
        financialStatementV2.balance_sheet.total_long_term_liabilities = 38;
        financialStatementV2.balance_sheet.total_other_fixed_assets = 39;
        financialStatementV2.balance_sheet.total_receivables = 40;
        financialStatementV2.balance_sheet.total_shareholders_equity = 41;
        financialStatementV2.balance_sheet.total_tangible_assets = 42;
        financialStatementV2.balance_sheet.trade_payables = 43;
        financialStatementV2.balance_sheet.trade_payables_due_after1year = 44;
        financialStatementV2.balance_sheet.trade_receivables = 45;
        financialStatementV2.balance_sheet.work_in_progress = 46;
        financialStatementV2.other_financials = new CreditsafeWsdl.CreditsafeCompanyOtherFinancialsV2();
        financialStatementV2.other_financials.working_capital = 1;
        financialStatementV2.other_financials.net_worth = 2;
        financialStatementV2.consolidated_accounts = true;
        financialStatementV2.number_of_weeks = 3;
        financialStatementV2.currency_x = '12';
        reportFullV2.financial_statements.item.add(financialStatementV2);

        reportFullV2.group_structure = new CreditsafeWsdl.CreditsafeCompanyGroupStructureV2();
        reportFullV2.group_structure.ultimate_parent = new CreditsafeWsdl.CreditsafeCompanyCompanyV2();
        reportFullV2.group_structure.ultimate_parent.address = new CreditsafeWsdl.CreditsafeAddressV2();
        reportFullV2.group_structure.ultimate_parent.address.country = 'up country';
        reportFullV2.group_structure.ultimate_parent.address.house_number = '1';
        reportFullV2.group_structure.ultimate_parent.address.full_address = 'up full_address';
        reportFullV2.group_structure.ultimate_parent.address.telephone = '987654321';
        reportFullV2.group_structure.ultimate_parent.address.street = 'up street';
        reportFullV2.group_structure.ultimate_parent.address.city = 'up city';
        reportFullV2.group_structure.ultimate_parent.address.postal_code = '1212';
        reportFullV2.group_structure.ultimate_parent.creditsafe_number = '12';
        reportFullV2.group_structure.ultimate_parent.date_last_account = Datetime.newInstance(2020,3,23);
        reportFullV2.group_structure.ultimate_parent.date_last_change = Datetime.newInstance(2020,1,23);
        reportFullV2.group_structure.ultimate_parent.trade_names = new CreditsafeWsdl.stringArray();
        reportFullV2.group_structure.ultimate_parent.trade_names.item = new List<String>();
        reportFullV2.group_structure.ultimate_parent.trade_names.item.add('trade names');
        reportFullV2.group_structure.ultimate_parent.vat_numbers = new CreditsafeWsdl.stringArray();
        reportFullV2.group_structure.ultimate_parent.vat_numbers.item = new List<String>();
        reportFullV2.group_structure.ultimate_parent.vat_numbers.item.add('1');
        reportFullV2.group_structure.ultimate_parent.country = 'country';
        reportFullV2.group_structure.ultimate_parent.registration_number = '1';
        reportFullV2.group_structure.ultimate_parent.name = 'name';
        reportFullV2.group_structure.ultimate_parent.id = '12';
        reportFullV2.group_structure.ultimate_parent.type_x = 'parent';
        reportFullV2.group_structure.ultimate_parent.status = 'status';
        reportFullV2.group_structure.ultimate_parent.office_type = 'office';

        reportFullV2.group_structure.immediate_parent = new CreditsafeWsdl.CreditsafeCompanyCompanyV2();
        reportFullV2.group_structure.immediate_parent.address = new CreditsafeWsdl.CreditsafeAddressV2();
        reportFullV2.group_structure.immediate_parent.address.country = 'ip country';
        reportFullV2.group_structure.immediate_parent.address.house_number = '1';
        reportFullV2.group_structure.immediate_parent.address.full_address = 'ip full_address';
        reportFullV2.group_structure.immediate_parent.address.telephone = '987654321';
        reportFullV2.group_structure.immediate_parent.address.street = 'ip street';
        reportFullV2.group_structure.immediate_parent.address.city = 'ip city';
        reportFullV2.group_structure.immediate_parent.address.postal_code = '1212';
        reportFullV2.group_structure.immediate_parent.creditsafe_number = '12';
        reportFullV2.group_structure.immediate_parent.date_last_account = Datetime.newInstance(2020,3,23);
        reportFullV2.group_structure.immediate_parent.date_last_change = Datetime.newInstance(2020,1,23);
        reportFullV2.group_structure.immediate_parent.trade_names = new CreditsafeWsdl.stringArray();
        reportFullV2.group_structure.immediate_parent.trade_names.item = new List<String>();
        reportFullV2.group_structure.immediate_parent.trade_names.item.add('trade names');
        reportFullV2.group_structure.immediate_parent.vat_numbers = new CreditsafeWsdl.stringArray();
        reportFullV2.group_structure.immediate_parent.vat_numbers.item = new List<String>();
        reportFullV2.group_structure.immediate_parent.vat_numbers.item.add('1');
        reportFullV2.group_structure.immediate_parent.country = 'country';
        reportFullV2.group_structure.immediate_parent.registration_number = '1';
        reportFullV2.group_structure.immediate_parent.name = 'name';
        reportFullV2.group_structure.immediate_parent.id = '12';
        reportFullV2.group_structure.immediate_parent.type_x = 'parent';
        reportFullV2.group_structure.immediate_parent.status = 'status';
        reportFullV2.group_structure.immediate_parent.office_type = 'office';

        reportFullV2.group_structure.subsidiary_companies = new CreditsafeWsdl.CreditsafeCompanyCompanyV2Array();
        reportFullV2.group_structure.subsidiary_companies.item = new List<CreditsafeWsdl.CreditsafeCompanyCompanyV2>();
        CreditsafeWsdl.CreditsafeCompanyCompanyV2 subsidiaryCompanyV2 = new CreditsafeWsdl.CreditsafeCompanyCompanyV2();
        subsidiaryCompanyV2.address = new CreditsafeWsdl.CreditsafeAddressV2();
        subsidiaryCompanyV2.address.country = 'sub country';
        subsidiaryCompanyV2.address.house_number = '1';
        subsidiaryCompanyV2.address.full_address = 'sub full_address';
        subsidiaryCompanyV2.address.telephone = '987654321';
        subsidiaryCompanyV2.address.street = 'sub street';
        subsidiaryCompanyV2.address.city = 'sub city';
        subsidiaryCompanyV2.address.postal_code = '1212';
        subsidiaryCompanyV2.creditsafe_number = '12';
        subsidiaryCompanyV2.date_last_account = Datetime.newInstance(2020,3,23);
        subsidiaryCompanyV2.date_last_change = Datetime.newInstance(2020,1,23);
        subsidiaryCompanyV2.trade_names = new CreditsafeWsdl.stringArray();
        subsidiaryCompanyV2.trade_names.item = new List<String>();
        subsidiaryCompanyV2.trade_names.item.add('trade names');
        subsidiaryCompanyV2.vat_numbers = new CreditsafeWsdl.stringArray();
        subsidiaryCompanyV2.vat_numbers.item = new List<String>();
        subsidiaryCompanyV2.vat_numbers.item.add('1');
        subsidiaryCompanyV2.country = 'country';
        subsidiaryCompanyV2.registration_number = '1';
        subsidiaryCompanyV2.name = 'name';
        subsidiaryCompanyV2.id = '12';
        subsidiaryCompanyV2.type_x = 'parent';
        subsidiaryCompanyV2.status = 'status';
        subsidiaryCompanyV2.office_type = 'office';
        reportFullV2.group_structure.subsidiary_companies.item.add(subsidiaryCompanyV2);

        reportFullV2.group_structure.affiliated_companies = new CreditsafeWsdl.CreditsafeCompanyCompanyV2Array();
        reportFullV2.group_structure.affiliated_companies.item = new List<CreditsafeWsdl.CreditsafeCompanyCompanyV2>();
        CreditsafeWsdl.CreditsafeCompanyCompanyV2 affiliatedCompanyV2= new CreditsafeWsdl.CreditsafeCompanyCompanyV2();
        affiliatedCompanyV2.address = new CreditsafeWsdl.CreditsafeAddressV2();
        affiliatedCompanyV2.address.country = 'sub country';
        affiliatedCompanyV2.address.house_number = '1';
        affiliatedCompanyV2.address.full_address = 'sub full_address';
        affiliatedCompanyV2.address.telephone = '987654321';
        affiliatedCompanyV2.address.street = 'sub street';
        affiliatedCompanyV2.address.city = 'sub city';
        affiliatedCompanyV2.address.postal_code = '1212';
        affiliatedCompanyV2.creditsafe_number = '12';
        affiliatedCompanyV2.date_last_account = Datetime.newInstance(2020,3,23);
        affiliatedCompanyV2.date_last_change = Datetime.newInstance(2020,1,23);
        affiliatedCompanyV2.trade_names = new CreditsafeWsdl.stringArray();
        affiliatedCompanyV2.trade_names.item = new List<String>();
        affiliatedCompanyV2.trade_names.item.add('trade names');
        affiliatedCompanyV2.vat_numbers = new CreditsafeWsdl.stringArray();
        affiliatedCompanyV2.vat_numbers.item = new List<String>();
        affiliatedCompanyV2.vat_numbers.item.add('1');
        affiliatedCompanyV2.country = 'country';
        affiliatedCompanyV2.registration_number = '1';
        affiliatedCompanyV2.name = 'name';
        affiliatedCompanyV2.id = '12';
        affiliatedCompanyV2.type_x = 'parent';
        affiliatedCompanyV2.status = 'status';
        affiliatedCompanyV2.office_type = 'office';
        reportFullV2.group_structure.affiliated_companies.item.add(affiliatedCompanyV2);

        reportFullV2.local_financial_statements = new CreditsafeWsdl.CreditsafeCompanyFinancialStatementV2Array();
        reportFullV2.local_financial_statements.item = new List<CreditsafeWsdl.CreditsafeCompanyFinancialStatementV2>();
        CreditsafeWsdl.CreditsafeCompanyFinancialStatementV2 localFinancialStatementV2 = new CreditsafeWsdl.CreditsafeCompanyFinancialStatementV2();
        localFinancialStatementV2.type_x = 'loc';
        localFinancialStatementV2.year_end_date = Datetime.newInstance(2002, 12, 9);
        localFinancialStatementV2.ratios = new CreditsafeWsdl.CreditsafeCompanyRatiosV2();
        localFinancialStatementV2.ratios.creditor_days = 1;
        localFinancialStatementV2.ratios.current_debt_ratio = 2;
        localFinancialStatementV2.ratios.current_ratio = 3;
        localFinancialStatementV2.ratios.debtor_days = 4;
        localFinancialStatementV2.ratios.equity_in_percentage = 5;
        localFinancialStatementV2.ratios.gearing = 6;
        localFinancialStatementV2.ratios.liquidity_ratio_or_acid_test = 7;
        localFinancialStatementV2.ratios.pre_tax_profit_margin = 8;
        localFinancialStatementV2.ratios.return_on_capital_employed = 9;
        localFinancialStatementV2.ratios.return_on_net_assets_employed = 10;
        localFinancialStatementV2.ratios.return_on_total_assets_employed = 11;
        localFinancialStatementV2.ratios.sales_or_net_working_capital = 12;
        localFinancialStatementV2.ratios.stock_turnover_ratio = 13;
        localFinancialStatementV2.ratios.total_debt_ratio = 15;
        localFinancialStatementV2.profit_and_loss = new CreditsafeWsdl.CreditsafeCompanyProfitAndLossV2();
        localFinancialStatementV2.profit_and_loss.depreciation = 1;
        localFinancialStatementV2.profit_and_loss.dividends = 2;
        localFinancialStatementV2.profit_and_loss.financial_expenses = 3;
        localFinancialStatementV2.profit_and_loss.financial_income = 4;
        localFinancialStatementV2.profit_and_loss.operating_costs = 5;
        localFinancialStatementV2.profit_and_loss.operating_profit = 6;
        localFinancialStatementV2.profit_and_loss.other_appropriations = 7;
        localFinancialStatementV2.profit_and_loss.pension_costs = 8;
        localFinancialStatementV2.profit_and_loss.profit_after_tax = 9;
        localFinancialStatementV2.profit_and_loss.profit_before_tax = 10;
        localFinancialStatementV2.profit_and_loss.retained_profit = 11;
        localFinancialStatementV2.profit_and_loss.revenue = 12;
        localFinancialStatementV2.profit_and_loss.tax = 13;
        localFinancialStatementV2.profit_and_loss.wages_and_salaries = 14;
        localFinancialStatementV2.balance_sheet = new CreditsafeWsdl.CreditsafeCompanyBalanceSheetV2();
        localFinancialStatementV2.balance_sheet.bank_liabilities = 1;
        localFinancialStatementV2.balance_sheet.bank_liabilities_due_after1year = 2;
        localFinancialStatementV2.balance_sheet.called_up_share_capital = 3;
        localFinancialStatementV2.balance_sheet.cash = 4;
        localFinancialStatementV2.balance_sheet.consolidated_accounts = 5;
        localFinancialStatementV2.balance_sheet.finished_goods = 6;
        localFinancialStatementV2.balance_sheet.goodwill = 7;
        localFinancialStatementV2.balance_sheet.group_payables = 8;
        localFinancialStatementV2.balance_sheet.group_payables_due_after1year = 9;
        localFinancialStatementV2.balance_sheet.group_receivables = 10;
        localFinancialStatementV2.balance_sheet.investments = 11;
        localFinancialStatementV2.balance_sheet.land_and_buildings = 12;
        localFinancialStatementV2.balance_sheet.loans_to_group = 13;
        localFinancialStatementV2.balance_sheet.miscellaneous_fixed_assets = 14;
        localFinancialStatementV2.balance_sheet.miscellaneous_liabilities = 15;
        localFinancialStatementV2.balance_sheet.miscellaneous_liabilities_due_after1_year = 16;
        localFinancialStatementV2.balance_sheet.miscellaneous_receivables = 17;
        localFinancialStatementV2.balance_sheet.other_current_assets = 18;
        localFinancialStatementV2.balance_sheet.other_intangible_assets = 19;
        localFinancialStatementV2.balance_sheet.other_inventories = 20;
        localFinancialStatementV2.balance_sheet.other_loans = 21;
        localFinancialStatementV2.balance_sheet.other_loans_or_finance = 22;
        localFinancialStatementV2.balance_sheet.other_loans_or_finance_due_after1_year = 23;
        localFinancialStatementV2.balance_sheet.other_reserves = 24;
        localFinancialStatementV2.balance_sheet.other_tangible_assets = 25;
        localFinancialStatementV2.balance_sheet.plant_and_machinery = 26;
        localFinancialStatementV2.balance_sheet.raw_materials = 27;
        localFinancialStatementV2.balance_sheet.receivables_due_after1year = 28;
        localFinancialStatementV2.balance_sheet.revenue_reserves = 29;
        localFinancialStatementV2.balance_sheet.share_premium = 30;
        localFinancialStatementV2.balance_sheet.total_assets = 31;
        localFinancialStatementV2.balance_sheet.total_current_assets = 32;
        localFinancialStatementV2.balance_sheet.total_current_liabilities = 33;
        localFinancialStatementV2.balance_sheet.total_fixed_assets = 34;
        localFinancialStatementV2.balance_sheet.total_intangible_assets = 35;
        localFinancialStatementV2.balance_sheet.total_inventories = 36;
        localFinancialStatementV2.balance_sheet.total_liabilities = 37;
        localFinancialStatementV2.balance_sheet.total_long_term_liabilities = 38;
        localFinancialStatementV2.balance_sheet.total_other_fixed_assets = 39;
        localFinancialStatementV2.balance_sheet.total_receivables = 40;
        localFinancialStatementV2.balance_sheet.total_shareholders_equity = 41;
        localFinancialStatementV2.balance_sheet.total_tangible_assets = 42;
        localFinancialStatementV2.balance_sheet.trade_payables = 43;
        localFinancialStatementV2.balance_sheet.trade_payables_due_after1year = 44;
        localFinancialStatementV2.balance_sheet.trade_receivables = 45;
        localFinancialStatementV2.balance_sheet.work_in_progress = 46;
        localFinancialStatementV2.other_financials = new CreditsafeWsdl.CreditsafeCompanyOtherFinancialsV2();
        localFinancialStatementV2.other_financials.working_capital = 1;
        localFinancialStatementV2.other_financials.net_worth = 2;
        localFinancialStatementV2.consolidated_accounts = true;
        localFinancialStatementV2.number_of_weeks = 3;
        localFinancialStatementV2.currency_x = '12';
        reportFullV2.local_financial_statements.item.add(localFinancialStatementV2);

        reportFullV2.negative_information = new CreditsafeWsdl.CreditsafeCompanyNegativeInformationV2();
        reportFullV2.negative_information.nl = new CreditsafeWsdl.CreditsafeCompanyNegativeInformationNLV2();
        reportFullV2.negative_information.nl.court_items = new CreditsafeWsdl.CreditsafeCompanyNegativeInformationNLCourtItemV2Array();
        reportFullV2.negative_information.nl.court_items.item = new List<CreditsafeWsdl.CreditsafeCompanyNegativeInformationNLCourtItemV2>();
        CreditsafeWsdl.CreditsafeCompanyNegativeInformationNLCourtItemV2 courtItemV2 = new CreditsafeWsdl.CreditsafeCompanyNegativeInformationNLCourtItemV2();
        courtItemV2.address = 'address';
        courtItemV2.court_action = 'action';
        courtItemV2.date_of_bankruptcy = Datetime.newInstance(2020,1,1);
        reportFullV2.negative_information.nl.court_items.item.add(courtItemV2);

        reportFullV2.negative_information.de = new CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEV2();
        reportFullV2.negative_information.de.bankruptcy = new CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEBankruptcyV2();
        reportFullV2.negative_information.de.bankruptcy.has_bankruptcy = 'yes';
        reportFullV2.negative_information.de.insolvency_information = new CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEInsolvencyInformationV2();
        reportFullV2.negative_information.de.insolvency_information.insolvency_events = new CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEInsolvencyEventV2Array();
        reportFullV2.negative_information.de.insolvency_information.insolvency_events.item = new List<CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEInsolvencyEventV2>();
        CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEInsolvencyEventV2 negativeInformationDEInsolvencyEventV2 = new CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEInsolvencyEventV2();
        negativeInformationDEInsolvencyEventV2.created_at = Datetime.newInstance(2020, 2,12);
        negativeInformationDEInsolvencyEventV2.reference_number_court = 'court';
        reportFullV2.negative_information.de.insolvency_information.insolvency_events.item.add(negativeInformationDEInsolvencyEventV2);
        reportFullV2.negative_information.de.insolvency_information.dateof_insolvency = 'Today';
        reportFullV2.negative_information.de.insolvency_information.trustee = new CreditsafeWsdl.CreditsafeCompanyNegativeInformationDETrusteeV2();
        reportFullV2.negative_information.de.insolvency_information.trustee.name = 'trustee.name';
        reportFullV2.negative_information.de.insolvency_information.trustee.title = 'trustee.title';
        reportFullV2.negative_information.de.insolvency_information.trustee.first_name = 'trustee.first_name';
        reportFullV2.negative_information.de.insolvency_information.trustee.last_name = 'trustee.last_name';
        reportFullV2.negative_information.de.insolvency_information.trustee.code = 'trustee.code';
        reportFullV2.negative_information.de.insolvency_information.trustee.city = 'trustee.city';
        reportFullV2.negative_information.de.insolvency_information.trustee.telephone_number = '12';
        reportFullV2.negative_information.de.insolvency_information.trustee.fax_number = '12';
        reportFullV2.negative_information.de.insolvency_information.trustee.email_address = 'trustee@gmail.com';
        reportFullV2.negative_information.de.director_events = new CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEDirectorEventV2Array();
        reportFullV2.negative_information.de.director_events.item = new List<CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEDirectorEventV2>();
        CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEDirectorEventV2 directorEventV2 = new CreditsafeWsdl.CreditsafeCompanyNegativeInformationDEDirectorEventV2();
        directorEventV2.name = 'name';
        directorEventV2.type_x = 'type';
        directorEventV2.date_x = Datetime.newInstance(2020,1,1);
        directorEventV2.description = 'description';
        directorEventV2.code = 'code';
        reportFullV2.negative_information.de.director_events.item.add(directorEventV2);
        reportFullV2.negative_information.generic = new CreditsafeWsdl.CreditsafeCompanyKeyValueV2Array();
        reportFullV2.negative_information.generic.item = new List<CreditsafeWsdl.CreditsafeCompanyKeyValueV2>();
        for (Integer i = 0; i < 2; i++) {
            CreditsafeWsdl.CreditsafeCompanyKeyValueV2 keyValueV2 = new CreditsafeWsdl.CreditsafeCompanyKeyValueV2();
            keyValueV2.value = 'value'+ i;
            keyValueV2.key = 'key' + i;
            reportFullV2.negative_information.generic.item.add(keyValueV2);
        }

        reportFullV2.order_number = '1212';
        reportFullV2.other_information = new CreditsafeWsdl.CreditsafeCompanyOtherInformationV2();
        reportFullV2.other_information.bankers = new CreditsafeWsdl.CreditsafeCompanyBankerV2Array();
        reportFullV2.other_information.bankers.item = new List<CreditsafeWsdl.CreditsafeCompanyBankerV2>();
        CreditsafeWsdl.CreditsafeCompanyBankerV2 bankerV2 = new CreditsafeWsdl.CreditsafeCompanyBankerV2();
        bankerV2.address = new CreditsafeWsdl.CreditsafeAddressV2();
        bankerV2.address.country = 'bank country';
        bankerV2.address.house_number = '1';
        bankerV2.address.full_address = 'bank full_address';
        bankerV2.address.telephone = '987654321';
        bankerV2.address.street = 'bank street';
        bankerV2.address.city = 'bank city';
        bankerV2.address.postal_code = '1212';
        bankerV2.name = 'bank';
        bankerV2.bank_code = '1212';
        reportFullV2.other_information.bankers.item.add(bankerV2);

        reportFullV2.other_information.advisors = new CreditsafeWsdl.CreditsafeCompanyAdvisorV2Array();
        reportFullV2.other_information.advisors.item = new List<CreditsafeWsdl.CreditsafeCompanyAdvisorV2>();
        CreditsafeWsdl.CreditsafeCompanyAdvisorV2 advisorV2 = new CreditsafeWsdl.CreditsafeCompanyAdvisorV2();
        advisorV2.auditor_name = 'auditor_name';
        advisorV2.solicitor_name = 'solicitor_name';
        reportFullV2.other_information.advisors.item.add(advisorV2);

        reportFullV2.other_information.employees_information = new CreditsafeWsdl.CreditsafeCompanyEmployeeInformationV2Array();
        reportFullV2.other_information.employees_information.item = new List<CreditsafeWsdl.CreditsafeCompanyEmployeeInformationV2>();
        CreditsafeWsdl.CreditsafeCompanyEmployeeInformationV2 employeeInformationV2 = new CreditsafeWsdl.CreditsafeCompanyEmployeeInformationV2();
        employeeInformationV2.number_of_employees = 21;
        employeeInformationV2.year = 2020;
        reportFullV2.other_information.employees_information.item.add(employeeInformationV2);

        reportFullV2.share_capital_structure = new CreditsafeWsdl.CreditsafeCompanyShareCapitalStructureV2();
        reportFullV2.share_capital_structure.share_holders = new CreditsafeWsdl.CreditsafeCompanyShareHolderV2Array();
        reportFullV2.share_capital_structure.share_holders.item = new List<CreditsafeWsdl.CreditsafeCompanyShareHolderV2>();
        CreditsafeWsdl.CreditsafeCompanyShareHolderV2 shareHolderV2 = new CreditsafeWsdl.CreditsafeCompanyShareHolderV2();
        shareHolderV2.address = new CreditsafeWsdl.CreditsafeAddressV2();
        shareHolderV2.address.country = 'shareholder country';
        shareHolderV2.address.house_number = '1';
        shareHolderV2.address.full_address = 'shareholder full_address';
        shareHolderV2.address.telephone = '987654321';
        shareHolderV2.address.street = 'shareholder street';
        shareHolderV2.address.city = 'shareholder city';
        shareHolderV2.address.postal_code = '1212';
        shareHolderV2.name = 'shareholder';
        shareHolderV2.share_percent = 100;
        reportFullV2.share_capital_structure.share_holders.item.add(shareHolderV2);
        reportFullV2.share_capital_structure.nominal_share_capital = 'nominal_share_capital';
        reportFullV2.share_capital_structure.issued_share_capital = 'issued_share_capital';

        reportFullV2.payment_data = new CreditsafeWsdl.CreditsafeCompanyPaymentDataV2();
        reportFullV2.payment_data.generic = new CreditsafeWsdl.CreditsafeCompanyKeyValueV2Array();
        reportFullV2.payment_data.generic.item = new List<CreditsafeWsdl.CreditsafeCompanyKeyValueV2>();
        for (Integer i = 0; i < 2; i++) {
            CreditsafeWsdl.CreditsafeCompanyKeyValueV2 keyValueV2 = new CreditsafeWsdl.CreditsafeCompanyKeyValueV2();
            keyValueV2.value = 'value'+ i;
            keyValueV2.key = 'key' + i;
            reportFullV2.payment_data.generic.item.add(keyValueV2);
        }

        reportFullV2.language = 'lang';
        reportFullV2.company_id = '1212';

        return reportFullV2;
    }
}