public interface IUserSelector extends fflib_ISObjectSelector {

    List<User> selectByNameLikeSearchKey(String searchKey, String sortedBy, String sortedDirection);

    List<User> selectByProfileLikeSearchKey(String searchKey, String sortedBy, String sortedDirection);
}