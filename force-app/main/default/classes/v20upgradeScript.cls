/**
 * Created by jaapbranderhorst on 2019-07-17.
 */

public without sharing class v20upgradeScript implements PostInstallScript.InstallAction  {

    public void execute(InstallContext context) {
        System.debug('in v20upgrade');
        Database.executeBatch(new SimpleSetFieldBatch(new Map<String, Object>{
                'RecordTypeId' => Schema.SObjectType.Business_Dossier__c.getRecordTypeInfosByName().get('Dutch Business').getRecordTypeId()
        },
        'Business_Dossier__c',
        'RecordTypeId = null'));
    }


}