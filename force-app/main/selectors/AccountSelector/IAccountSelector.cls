public interface IAccountSelector extends fflib_ISObjectSelector {

    List<Account> selectById(set<Id> IdSet); 
}
