public interface IGenericSelector extends fflib_ISObjectSelector {
    List<SObject> selectByParentRecordId(Id parentRecordId);
}
