/**
 * Created by tejaswinidandi on 21/04/2020.
 */

public interface IInternationalAddressSelector  extends fflib_ISObjectSelector {

    List<International_Address__c> selectById(set<Id> internationalAddressIdSet);
}