/**
 * Created by jaapbranderhorst on 2019-07-03.
 */

@IsTest
private class CreditSafeServiceImplTest {

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

            //test for SEWithCompanyId
            List<Business_Dossier__c> dossiers1 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'SE'}, 'id', '', '', '', '', '', '', '', '', '');
            System.assert(dossiers1.size() == 5);
            for (Business_Dossier__c dossier : dossiers1) {
                System.assert(dossier.Company_Id__c.isNumeric());
            }

            //test for SEWithRegistrationNumber, registration_type
            List<Business_Dossier__c> dossiers2 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'SE'}, '', '', 'registration_number', 'registration_type', '', '', '', '', '', '');
            System.assertEquals(dossiers2.size() , 10);
            for (Business_Dossier__c dossier : dossiers2) {
                System.assert(dossier.Dossier_Number__c.startsWith('123'));
            }

            //test for SEWith name, status, registration_type, street, city, postalcode
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
    static void testSearchForCreditSafeDossiersForDK() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsCreditsafe wsCreditsafeService = (IWsCreditsafe)mocks.mock(IWsCreditsafe.class);

        CreditsafeWsdl.CreditsafeSearchResultV2 searchResultV2 = new CreditsafeWsdl.CreditsafeSearchResultV2();
        searchResultV2.companies = new CreditsafeWsdl.CreditsafeCompanyV2Array();
        searchResultV2.companies.item = new List<CreditsafeWsdl.CreditsafeCompanyV2>();
        for (Integer i = 0; i < 5; i++) {
            CreditsafeWsdl.CreditsafeCompanyV2 company  = new CreditsafeWsdl.CreditsafeCompanyV2();
            company.country = 'DK';
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
            List<Business_Dossier__c> dossiers = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'DK'}, 'id', 'status', 'regnr', 'type', 'vat', 'province', 'city', 'street', 'postal_code', 'name');
            System.assert(dossiers.size() == 20);
            for (Business_Dossier__c dossier : dossiers) {
                System.assert(dossier.Name.isNumeric());
                System.assert(dossier.Dossier_Number__c.startsWith('123'));
                System.assert(dossier.Country__c == 'DK');
                System.assert(dossier.Street__c == 'Braillelaan');
                System.assert(dossier.City__c == 'Utrecht');
                System.assert(dossier.Date_of_Last_Account__c != null && dossier.Date_of_Last_Account__c < Datetime.now());
                System.assert(dossier.Date_of_Last_Change__c != null && dossier.Date_of_Last_Change__c < Datetime.now());
                System.assert(dossier.Office_Type__c == 'Headoffice');
                System.assert(dossier.Trade_Names__c != null);
                System.assert(dossier.Telephone_Number__c.isNumeric());
            }

            //test for DKWithCompanyId
            List<Business_Dossier__c> dossiers1 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'DK'}, 'id', '', '', '', '', '', '', '', '', '');
            System.assert(dossiers1.size() == 5);
            for (Business_Dossier__c dossier : dossiers1) {
                System.assert(dossier.Company_Id__c.isNumeric());
            }

            //test for DKWithRegistrationNumber
            List<Business_Dossier__c> dossiers2 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'DK'}, '', '', 'registration_number', '', '', '', '', '', '', '');
            System.assertEquals(dossiers2.size() , 5);
            for (Business_Dossier__c dossier : dossiers2) {
                System.assert(dossier.Dossier_Number__c.startsWith('123'));
            }

            //test for DKWithVATNumber
            List<Business_Dossier__c> dossiers3 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'IT'}, '', '', '', '', 'vat', '', '', '', '', '');
            System.assertEquals(dossiers3.size() , 5);
            for (Business_Dossier__c dossier : dossiers3) {
                System.assert(dossier.VAT_Number__c != null);
            }

            //test for DKWith name, status, street, city, postalcode, province
            List<Business_Dossier__c> dossiers4 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'DK'}, '', 'status', '', '', '', 'province', 'city', 'street', 'postal_code', 'name');
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
    static void testSearchForCreditSafeDossiersForIT() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsCreditsafe wsCreditsafeService = (IWsCreditsafe)mocks.mock(IWsCreditsafe.class);

        CreditsafeWsdl.CreditsafeSearchResultV2 searchResultV2 = new CreditsafeWsdl.CreditsafeSearchResultV2();
        searchResultV2.companies = new CreditsafeWsdl.CreditsafeCompanyV2Array();
        searchResultV2.companies.item = new List<CreditsafeWsdl.CreditsafeCompanyV2>();
        for (Integer i = 0; i < 5; i++) {
            CreditsafeWsdl.CreditsafeCompanyV2 company  = new CreditsafeWsdl.CreditsafeCompanyV2();
            company.country = 'IT';
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
            List<Business_Dossier__c> dossiers = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'IT'}, 'id', 'status', 'regnr', 'type', 'vat', 'province', 'city', 'street', 'postal_code', 'name');
            System.assert(dossiers.size() == 20);
            for (Business_Dossier__c dossier : dossiers) {
                System.assert(dossier.Name.isNumeric());
                System.assert(dossier.Dossier_Number__c.startsWith('123'));
                System.assert(dossier.Country__c == 'IT');
                System.assert(dossier.Street__c == 'Braillelaan');
                System.assert(dossier.City__c == 'Utrecht');
                System.assert(dossier.Date_of_Last_Account__c != null && dossier.Date_of_Last_Account__c < Datetime.now());
                System.assert(dossier.Date_of_Last_Change__c != null && dossier.Date_of_Last_Change__c < Datetime.now());
                System.assert(dossier.Office_Type__c == 'Headoffice');
                System.assert(dossier.Trade_Names__c != null);
                System.assert(dossier.Telephone_Number__c.isNumeric());
            }

            //test for ITWithCompanyId
            List<Business_Dossier__c> dossiers1 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'IT'}, 'id', '', '', '', '', '', '', '', '', '');
            System.assert(dossiers1.size() == 5);
            for (Business_Dossier__c dossier : dossiers1) {
                System.assert(dossier.Company_Id__c.isNumeric());
            }

            //test for ITWithRegistrationNumber
            List<Business_Dossier__c> dossiers2 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'IT'}, '', '', 'registration_number', '', '', '', '', '', '', '');
            System.assertEquals(dossiers2.size() , 5);
            for (Business_Dossier__c dossier : dossiers2) {
                System.assert(dossier.Dossier_Number__c.startsWith('123'));
            }

            //test for ITWithVATNumber, status, registration_type
            List<Business_Dossier__c> dossiers3 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'IT'}, '', 'status', '', 'registration_type', 'vat', '', '', '', '', '');
            System.assertEquals(dossiers3.size() , 10);
            for (Business_Dossier__c dossier : dossiers3) {
                System.assert(dossier.VAT_Number__c != null);
            }

            //test for ITWith name, status, street, city, postalcode, province, registration_type
            List<Business_Dossier__c> dossiers4 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'IT'}, '', 'status', '', 'registration_type', '', 'province', 'city', 'street', 'postal_code', 'name');
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
    static void testSearchForCreditSafeDossiersForES() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsCreditsafe wsCreditsafeService = (IWsCreditsafe)mocks.mock(IWsCreditsafe.class);

        CreditsafeWsdl.CreditsafeSearchResultV2 searchResultV2 = new CreditsafeWsdl.CreditsafeSearchResultV2();
        searchResultV2.companies = new CreditsafeWsdl.CreditsafeCompanyV2Array();
        searchResultV2.companies.item = new List<CreditsafeWsdl.CreditsafeCompanyV2>();
        for (Integer i = 0; i < 5; i++) {
            CreditsafeWsdl.CreditsafeCompanyV2 company  = new CreditsafeWsdl.CreditsafeCompanyV2();
            company.country = 'ES';
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
            List<Business_Dossier__c> dossiers = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'ES'}, 'id', 'status', 'regnr', 'type', 'vat', 'province', 'city', 'street', 'postal_code', 'name');
            System.assert(dossiers.size() == 20);
            for (Business_Dossier__c dossier : dossiers) {
                System.assert(dossier.Name.isNumeric());
                System.assert(dossier.Dossier_Number__c.startsWith('123'));
                System.assert(dossier.Country__c == 'ES');
                System.assert(dossier.Street__c == 'Braillelaan');
                System.assert(dossier.City__c == 'Utrecht');
                System.assert(dossier.Date_of_Last_Account__c != null && dossier.Date_of_Last_Account__c < Datetime.now());
                System.assert(dossier.Date_of_Last_Change__c != null && dossier.Date_of_Last_Change__c < Datetime.now());
                System.assert(dossier.Office_Type__c == 'Headoffice');
                System.assert(dossier.Trade_Names__c != null);
                System.assert(dossier.Telephone_Number__c.isNumeric());
            }

            //test for ESWithCompanyId
            List<Business_Dossier__c> dossiers1 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'ES'}, 'id', '', '', '', '', '', '', '', '', '');
            System.assert(dossiers1.size() == 5);
            for (Business_Dossier__c dossier : dossiers1) {
                System.assert(dossier.Company_Id__c.isNumeric());
            }

            //test for ESWithRegistrationNumber
            List<Business_Dossier__c> dossiers2 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'ES'}, '', '', 'registration_number', '', '', '', '', '', '', '');
            System.assertEquals(dossiers2.size() , 5);
            for (Business_Dossier__c dossier : dossiers2) {
                System.assert(dossier.Dossier_Number__c.startsWith('123'));
            }

            //test for ESWithVATNumber
            List<Business_Dossier__c> dossiers3 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'ES'}, '', '', '', '', 'vat', '', '', '', '', '');
            System.assertEquals(dossiers3.size() , 5);
            for (Business_Dossier__c dossier : dossiers3) {
                System.assert(dossier.VAT_Number__c != null);
            }

            //test for ESWith name, status, street, city, postalcode, province, registration_type
            List<Business_Dossier__c> dossiers4 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'ES'}, '', 'status', '', 'registration_type', '', 'province', 'city', 'street', 'postal_code', 'name');
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
    static void testSearchForCreditSafeDossiersForNO() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IWsCreditsafe wsCreditsafeService = (IWsCreditsafe)mocks.mock(IWsCreditsafe.class);

        CreditsafeWsdl.CreditsafeSearchResultV2 searchResultV2 = new CreditsafeWsdl.CreditsafeSearchResultV2();
        searchResultV2.companies = new CreditsafeWsdl.CreditsafeCompanyV2Array();
        searchResultV2.companies.item = new List<CreditsafeWsdl.CreditsafeCompanyV2>();
        for (Integer i = 0; i < 5; i++) {
            CreditsafeWsdl.CreditsafeCompanyV2 company  = new CreditsafeWsdl.CreditsafeCompanyV2();
            company.country = 'NO';
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
            List<Business_Dossier__c> dossiers = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'NO'}, 'id', 'status', 'regnr', 'type', 'vat', 'province', 'city', 'street', 'postal_code', 'name');
            System.assertEquals(dossiers.size(), 15);
            for (Business_Dossier__c dossier : dossiers) {
                System.assert(dossier.Name.isNumeric());
                System.assert(dossier.Dossier_Number__c.startsWith('123'));
                System.assert(dossier.Country__c == 'NO');
                System.assert(dossier.Street__c == 'Braillelaan');
                System.assert(dossier.City__c == 'Utrecht');
                System.assert(dossier.Date_of_Last_Account__c != null && dossier.Date_of_Last_Account__c < Datetime.now());
                System.assert(dossier.Date_of_Last_Change__c != null && dossier.Date_of_Last_Change__c < Datetime.now());
                System.assert(dossier.Office_Type__c == 'Headoffice');
                System.assert(dossier.Trade_Names__c != null);
                System.assert(dossier.Telephone_Number__c.isNumeric());
            }

            //test for NOWithCompanyId
            List<Business_Dossier__c> dossiers1 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'NO'}, 'id', '', '', '', '', '', '', '', '', '');
            System.assert(dossiers1.size() == 5);
            for (Business_Dossier__c dossier : dossiers1) {
                System.assert(dossier.Company_Id__c.isNumeric());
            }

            //test for NOWithRegistrationNumber, registration_type
            List<Business_Dossier__c> dossiers2 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'NO'}, '', '', 'registration_number', 'registration_type', '', '', '', '', '', '');
            System.assertEquals(dossiers2.size() , 10);
            for (Business_Dossier__c dossier : dossiers2) {
                System.assert(dossier.Dossier_Number__c.startsWith('123'));
            }

            //test for NOWith name, status, street, city, postalcode, province
            List<Business_Dossier__c> dossiers4 = CreditSafeService.searchForCreditSafeDossiers(new List<String>{'NO'}, '', 'status', '', 'registration_type', '', '', 'city', 'street', 'postal_code', 'name');
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

        CreditsafeWsdl.CreditsafeCompanyReportFullV2 reportFullV2 = TestUtils.createCompanyReportFullV2Mock();

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
}