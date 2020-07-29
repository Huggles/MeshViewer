/**
 * Created by Hugo on 04/06/2020.
 */

public with sharing class SetupServiceImpl implements ISetupService {

    static final String DATA_SOURCE_API_NAME = '_Selected_Data_Source';
    public final static String UPDATED_DUTCH_DOSSIER_SCHEDULE_CRON_SETTING_NAME = 'Update_Dutch_Dossier_Batch_Cron_Schedule';
    public final static String UPDATED_DUTCH_DOSSIER_SCHEDULE_CRON_SETTING_MASTERLABEL = 'Update Dutch Dossier Batch Cron Schedule';

    public inherited sharing class CustomMetadataCallback implements Metadata.DeployCallback {
        public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {
            if (result.status == Metadata.DeployStatus.Succeeded) {
            } else {
                CustomException ex = new CustomException('Custom Metadata Deployment with job id ' + context.getCallbackJobId() + ' failed.');
                ErrorLogUtil.logException(ex, true);
            }
        }
    }

    public List<Protected_Subscriber_Setting__mdt> getUpdateTypes(){
        List<Protected_Subscriber_Setting__mdt> updateTypes = [
                SELECT id, DeveloperName, MasterLabel, Label, External_Id__c, Enabled__c, Description__c
                FROM Protected_Subscriber_Setting__mdt
                WHERE DeveloperName LIKE '%Update_Type_%'
                WITH SECURITY_ENFORCED
                ORDER BY MasterLabel
        ];
        return updateTypes;
    }

    public Data_source__mdt getSelectedDataSource(String countryCode) {
        List<Datasource_Per_Country__mdt> datasourcePerCountries = [
                SELECT Datasource__c
                FROM Datasource_Per_Country__mdt
                WHERE Data_Source_Select_Record__c = TRUE AND ISO_3166_Entry__r.Alpha_2_Code__c = :countryCode];
        if (datasourcePerCountries != null && datasourcePerCountries.size() == 1) {
            Data_source__mdt dataSource = [
                    SELECT
                            DeveloperName,
                            Id,
                            Label,
                            Language,
                            MasterLabel,
                            NamespacePrefix,
                            QualifiedApiName
                    FROM Data_source__mdt WHERE Id = :datasourcePerCountries.get(0).Datasource__c];
            return dataSource;
        } else {
            throw new InputException('Found no or too many data sources selected for country code ' + countryCode);
        }
    }

    public List<Datasource_Per_Country__mdt> getDataSourcesPerCountry() {
        List<Datasource_Per_Country__mdt> datasourcePerCountries = [
                SELECT
                        Data_source__r.Label,
                        Data_source__r.DeveloperName,
                        Datasource__c,
                        Data_Source_Select_Record__c,
                        ISO_3166_Entry__c,
                        ISO_3166_Entry__r.Alpha_2_Code__c,
                        ISO_3166_Entry__r.Label,
                        ISO_3166_Entry__r.Country_Name__c,
                        DeveloperName,
                        Id,
                        Label,
                        Language,
                        MasterLabel,
                        NamespacePrefix,
                        QualifiedApiName
                FROM Datasource_Per_Country__mdt WHERE Data_Source_Select_Record__c = FALSE WITH SECURITY_ENFORCED ORDER BY MasterLabel];
        return datasourcePerCountries;
    }

    public Id setUpdateTypes(List<Map<string, object>> payload) {
        String updateTypeAPIName = String.valueOf(Protected_Subscriber_Setting__mdt.getSObjectType());
        CustomMetadataCallback callback = new CustomMetadataCallback();

        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        for(Map<string, object> mdRecord : payload ){

            Boolean checked = Boolean.valueOf(mdRecord.get('checked'));
            String developerName = String.valueOf(mdRecord.get('developerName')); //RecordName = DeveloperName
            String developerNameSpace = GetNameSpace.getNameSpace(developerName,'CustomMetadata',updateTypeAPIName);
            developerName = (developerNameSpace != null) ? developerNameSpace+ '__' + developerName  : developerName;
            String masterLabel = String.valueOf(mdRecord.get('label'));

            if(checked == null || developerName == null || masterLabel == null){
                throw new InputException(Label.Error_Input_Incorrect);
            }
            Metadata.CustomMetadata customMetadata = new Metadata.CustomMetadata();
            customMetadata.fullName = updateTypeAPIName + '.' + developerName; //RecordName = DeveloperName
            customMetadata.label = masterLabel;

            Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
            customField.field = String.valueOf(Protected_Subscriber_Setting__mdt.Enabled__c);
            customField.value = checked;
            customMetadata.values.add(customField);

            mdContainer.addMetadata(customMetadata);
        }
        //Cannot update an empty container.
        if(mdContainer.getMetadata().size() == 0){
            return null;
        }

        Id jobId;
        try{
            jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
        }catch (Exception e){
            MetadataOperationException metadataOperationException = new MetadataOperationException(Label.Error_updating_update_type_settings);
            metadataOperationException.setMessage(Label.Error_updating_update_type_settings); //Explicitly set the message so it can be read in apex as well.
            throw metadataOperationException;
        }
        return jobId;

    }

    public void setDataSourcePerCountry(Map<String, String> selectedDataSourcePerCountry) {
        List<Datasource_Per_Country__mdt> datasourcePerCountriesMdt = new List<Datasource_Per_Country__mdt>();
        for (String countryCode : selectedDataSourcePerCountry.keySet()) {
            String dataSourceDeveloperName = selectedDataSourcePerCountry.get(countryCode);
            Id dataSourceId = getDatasourceIdsByDeveloperName().get(dataSourceDeveloperName);
            Id countryId = getCountryMtdsByCountryCode().get(countryCode).Id;

            //get and add namespace for the custom metadata record
            string countryNamespacePrefix = GetNameSpace.getNameSpace(getCountryMtdsByCountryCode().get(countryCode).DeveloperName+'_Selected_Data_Source','CustomMetadata','Datasource_Per_Country__mdt');
            countryNamespacePrefix = countryNamespacePrefix != null ? countryNamespacePrefix+'__':countryNamespacePrefix;
            String countryMasterLabel = countryNamespacePrefix+getCountryMtdsByCountryCode().get(countryCode).Label;
            String countryLabel = getCountryMtdsByCountryCode().get(countryCode).Label;

            Datasource_Per_Country__mdt datasourcePerCountry = new Datasource_Per_Country__mdt();
            datasourcePerCountry.Data_Source_Select_Record__c = true;
            datasourcePerCountry.Datasource__c = dataSourceId;
            datasourcePerCountry.ISO_3166_Entry__c = countryId;
            datasourcePerCountry.DeveloperName = countryMasterLabel + DATA_SOURCE_API_NAME; // brittle but I don't see another solution
            datasourcePerCountry.MasterLabel = countryMasterLabel +' '+Label.Data_source_Label; // brittle once more
            datasourcePerCountry.Label = countryLabel+ ' '+Label.Data_source_Label;
            datasourcePerCountriesMdt.add(datasourcePerCountry);
        }
        upsertDataSourcePerCountry(datasourcePerCountriesMdt);
    }

    public Id setUpdateTypeCron(String cronExpression){
        String updateTypeAPIName = String.valueOf(Setting__mdt.getSObjectType());
        String namespacePrefix = GetNameSpace.getCustomMetadataNameSpace(UPDATED_DUTCH_DOSSIER_SCHEDULE_CRON_SETTING_NAME, updateTypeAPIName) + '__';

        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();

        // record
        Metadata.CustomMetadata customMetadata = new Metadata.CustomMetadata();
        customMetadata.fullName = updateTypeAPIName + '.' + namespacePrefix + UPDATED_DUTCH_DOSSIER_SCHEDULE_CRON_SETTING_NAME;
        customMetadata.label = UPDATED_DUTCH_DOSSIER_SCHEDULE_CRON_SETTING_MASTERLABEL;

        // value field
        Metadata.CustomMetadataValue valueField = new Metadata.CustomMetadataValue();
        valueField.field = String.valueOf(Setting__mdt.Value__c);
        valueField.value = cronExpression;

        customMetadata.values.add(valueField);
        mdContainer.addMetadata(customMetadata);

        Id jobId;
        try{
            SetUpdateCronExpressionCallback callback = new SetUpdateCronExpressionCallback();
            jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
        }catch (Exception e){
            MetadataOperationException metadataOperationException = new MetadataOperationException(e.getMessage());
            metadataOperationException.setMessage(e.getMessage()); //Explicitly set the message so it can be read in apex as well.
            throw metadataOperationException;
        }
        return jobId;
    }
    public inherited sharing class SetUpdateCronExpressionCallback implements Metadata.DeployCallback {
        public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {
            if (result.status == Metadata.DeployStatus.Succeeded) {
                String newCronValue = [SELECT Value__c FROM Setting__mdt WHERE DeveloperName = :UPDATED_DUTCH_DOSSIER_SCHEDULE_CRON_SETTING_NAME LIMIT 1].Value__c;
                SetupService.scheduleCronJob(UPDATED_DUTCH_DOSSIER_SCHEDULE_CRON_SETTING_MASTERLABEL, new UpdateDossierBatchScheduler() , newCronValue );
            } else {
                CustomException ex = new CustomException('Custom Metadata Deployment with job id ' + context.getCallbackJobId() + ' failed.');
                ErrorLogUtil.logException(ex, true);
            }
        }
    }

    public List<CronTrigger> getScheduledCronJob(String scheduleName){
        List<CronTrigger> cronTriggers = [SELECT Id,  CreatedDate, CronJobDetailId, CronJobDetail.Name, CronExpression, PreviousFireTime, NextFireTime FROM CronTrigger WHERE CronJobDetail.Name =: scheduleName];
        return cronTriggers;
    }
    public void scheduleCronJob(String scheduleName, Schedulable schedulable, String cronExpression) {
        // check if there is an existing scheduled job, if so abort it and restart (to ensure no 'stale' jobs run)
        abortScheduledCronJob(scheduleName);
        try {
            System.schedule(scheduleName, cronExpression, schedulable);
        } catch (Exception ex) {
            ErrorLogUtil.logException(ex, true);
        }
    }
    private void abortScheduledCronJob(String scheduleName) {
        // check if there is an existing scheduled job, if so abort it and restart (to ensure no 'stale' jobs run)
        List<CronTrigger> cronTriggers = getScheduledCronJob(scheduleName);
        for (CronTrigger cronTrigger : cronTriggers) {
            try {
                System.abortJob(cronTrigger.Id);
            } catch (Exception ex) { // sometimes this throws unexpected exceptions which can be ignored.

            }
        }
    }

    private Map<String, Id> dataSourceIdByDeveloperName;

    private Map<String, Id> getDatasourceIdsByDeveloperName() {
        if (dataSourceIdByDeveloperName == null) {
            dataSourceIdByDeveloperName = new Map<String, Id>();
            List<Data_source__mdt> dataSources = [
                    SELECT
                            DeveloperName,
                            Id,
                            Label,
                            Language,
                            MasterLabel,
                            NamespacePrefix,
                            QualifiedApiName
                    FROM Data_source__mdt];
            for (Data_source__mdt dataSource : dataSources) {
                dataSourceIdByDeveloperName.put(dataSource.DeveloperName, dataSource.Id);
            }
        }
        return dataSourceIdByDeveloperName;
    }

    private Map<String, ISO_3166_Entry__mdt> countryMtdsByCountryCode;

    private Map<String, ISO_3166_Entry__mdt> getCountryMtdsByCountryCode() {
        if (countryMtdsByCountryCode == null) {
            countryMtdsByCountryCode = new Map<String, ISO_3166_Entry__mdt>();
            List<ISO_3166_Entry__mdt> iso3166Entries = [
                    SELECT
                            Alpha_2_Code__c,
                            Country_Code__c,
                            Country_Name__c,
                            DeveloperName,
                            Id,
                            Label,
                            Language,
                            MasterLabel,
                            NamespacePrefix,
                            QualifiedApiName
                    FROM ISO_3166_Entry__mdt];
            for (ISO_3166_Entry__mdt isoO3166Entry : iso3166Entries) {
                countryMtdsByCountryCode.put(isoO3166Entry.Alpha_2_Code__c, isoO3166Entry);
            }
        }
        return countryMtdsByCountryCode;
    }

    private Id upsertDataSourcePerCountry(List<Datasource_Per_Country__mdt> datasourcePerCountries) {
        String updateTypeAPIName = String.valueOf(Datasource_Per_Country__mdt.getSObjectType());

        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        for(Datasource_Per_Country__mdt datasourcePerCountry : datasourcePerCountries ){

            // record
            Metadata.CustomMetadata customMetadata = new Metadata.CustomMetadata();
            customMetadata.fullName = updateTypeAPIName + '.' + datasourcePerCountry.DeveloperName; //RecordName = DeveloperName
            customMetadata.label = datasourcePerCountry.Label;
            customMetadata.protected_x = false;

            // country field
            Metadata.CustomMetadataValue countryField = new Metadata.CustomMetadataValue();
            countryField.field = String.valueOf(Datasource_Per_Country__mdt.ISO_3166_Entry__c);
            ISO_3166_Entry__mdt country = [SELECT QualifiedApiName FROM ISO_3166_Entry__mdt WHERE Id = :datasourcePerCountry.ISO_3166_Entry__c LIMIT 1]; // can be solved more gracefully but does the job
            countryField.value = country.QualifiedApiName;
            customMetadata.values.add(countryField);

            // data source field
            Metadata.CustomMetadataValue datasourceField = new Metadata.CustomMetadataValue();
            datasourceField.field = String.valueOf(Datasource_Per_Country__mdt.Datasource__c);
            Data_source__mdt dataSource = [SELECT QualifiedApiName FROM Data_source__mdt WHERE Id = :datasourcePerCountry.Datasource__c LIMIT 1];
            datasourceField.value = dataSource.QualifiedApiName;
            customMetadata.values.add(datasourceField);

            // data source select record
            Metadata.CustomMetadataValue selectedDataSourcefield = new Metadata.CustomMetadataValue();
            selectedDataSourcefield.field = String.valueOf(Datasource_Per_Country__mdt.Data_Source_Select_Record__c);
            selectedDataSourcefield.value = datasourcePerCountry.Data_Source_Select_Record__c;
            customMetadata.values.add(selectedDataSourcefield);

            mdContainer.addMetadata(customMetadata);
        }
        //Cannot update an empty container.
        if(mdContainer.getMetadata().size() == 0){
            return null;
        }

        Id jobId;
        try{
            CustomMetadataCallback callback = new CustomMetadataCallback();
            jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
        }catch (Exception e){
            // TODO: labels
            MetadataOperationException metadataOperationException = new MetadataOperationException(Label.Error_updating_update_type_settings);
            metadataOperationException.setMessage(Label.Error_updating_update_type_settings); //Explicitly set the message so it can be read in apex as well.
            throw metadataOperationException;
        }
        return jobId;
    }

}
