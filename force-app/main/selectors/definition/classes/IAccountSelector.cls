public interface IAccountSelector extends fflib_ISObjectSelector {

    List<Account> selectById(set<ID> IdSet);
    Account selectById(String  Id);
}
