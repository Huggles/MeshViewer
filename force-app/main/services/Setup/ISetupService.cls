/**
 * Created by Hugo on 04/06/2020.
 */

public interface ISetupService {


    /**
     * Gets all update types from custom metadata.
     */
    List<Update_Type__mdt> getUpdateTypes();
    Id setUpdateTypes(List<Map<string, object>> payload);
}