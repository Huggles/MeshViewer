/**
 * Created by Hugo on 04/06/2020.
 */

public interface ISetupService {


    /**
     * Gets all update types from custom metadata.
     */
    List<Protected_Subscriber_Setting__mdt> getUpdateTypes();

    /**
     * Sets the update type
     * @param payload
     *
     * @return the job id of the metadata deployment
     */
    Id setUpdateTypes(List<Map<String, Object>> payload);

    /**
     * Gets all possible data sources per country. Does not return the current selected data source for a country
     * but just the possible data sources.
     * @return the possible data sources for a country
     */
    List<Datasource_Per_Country__mdt> getDataSourcesPerCountry();

    /**
     * Gets the selected data source for the given country code
     * @param countryCode the alpha 2 letter country code to get the selected data source for
     *
     * @return the selected data source
     */
    Data_source__mdt getSelectedDataSource(String countryCode);

    /**
    * Sets the selected datasource per country
    * @param selectedDataSourcePerCountry a map with as key the country code and as value the selected data source
    *
    */
    void setDataSourcePerCountry(Map<String, String> selectedDataSourcePerCountry);

    /**
   * Gets information about a scheduled job.
   *
   * @param scheduleName The name of the job
   */
    List<CronTrigger> getScheduledCronJob(String scheduleName);


    /**
    * Sets the cron expression for the dutch business dossier update in the custom meta data settings.
    * @param cronExpression The new cron expressions
    */
    Id setUpdateTypeCron(String cronExpression);

    /**
   * Schedules a cronjob. Aborts any scheduled cronjobs with the same name.
   *
   * @param scheduleName The name of the job
   * @param schedulable The class implementing the Schedulable interface.
   * @param cronExpression The cron expression used to determine when to run.
   */
    void scheduleCronJob(String scheduleName, Schedulable schedulable, String cronExpression);


}