/**
 * Created by jaapbranderhorst on 2019-06-18.
 */

public interface ISbiCodeSelector {
    List<Business_Data_SBI__c> selectByDossierId(set<Id> dossierIdSet);
}