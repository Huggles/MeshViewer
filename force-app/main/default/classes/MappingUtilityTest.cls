/**
 * Created by jaapbranderhorst on 16/02/2020.
 */

@IsTest
private class MappingUtilityTest {
    @IsTest
    static void testOneRecord() {
        String mapping = '{ "nameAttr" : "Name", "idAttr" : "Id" }';
        Account acc = new Account(Name = 'test');
        insert acc;
        Test.startTest();
        Map<String, Object> mappedAttributes = MappingUtility.mapToObjectsByStrings(mapping, acc.Id);
        Test.stopTest();
        System.assert(mappedAttributes.size() == 2);
        System.assert(mappedAttributes.get('nameAttr') == 'test');
        System.assert(mappedAttributes.get('idAttr') == acc.Id);
    }
}