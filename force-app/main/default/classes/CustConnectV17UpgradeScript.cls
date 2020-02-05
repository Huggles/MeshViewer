/**
 * Created by jaapbranderhorst on 2019-07-17.
 */

public without sharing class CustConnectV17UpgradeScript implements IInstallAction  {

    public void execute(InstallContext context) {
        Database.executeBatch(new SimpleSetFieldBatch(new Map<String, Object>{
                'RecordTypeId' => Schema.SObjectType.Business_Dossier__c.getRecordTypeInfosByName().get('Dutch Business').getRecordTypeId()
        },
        'Business_Dossier__c',
        'RecordTypeId = null'));
    } 


}