/**
 * Created by jaapbranderhorst on 2019-06-18.
 */

public interface ISbiCodeSelector extends fflib_ISObjectSelector {
    List<Business_Data_SBI__c> selectByDossierId(set<Id> dossierIdSet);
}