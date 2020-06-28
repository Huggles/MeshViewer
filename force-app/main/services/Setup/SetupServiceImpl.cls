/**
 * Created by Hugo on 04/06/2020.
 */

public with sharing class SetupServiceImpl implements ISetupService {

    public inherited sharing class CustomMetadataCallback implements Metadata.DeployCallback {
        public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {
            if (result.status == Metadata.DeployStatus.Succeeded) {
            } else {

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
                SELECT Data_source__c
                FROM Datasource_Per_Country__mdt
                WHERE Data_Source_Select_Record__c = TRUE AND ISO_3166_Entry__r.Country_Code__c = :countryCode WITH SECURITY_ENFORCED];
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
                    FROM Data_source__mdt WHERE Id = :datasourcePerCountries.get(0).Data_source__c WITH SECURITY_ENFORCED];
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
                        Data_source__c,
                        Data_Source_Select_Record__c,
                        ISO_3166_Entry__c,
                        ISO_3166_Entry__r.Country_Code__c,
                        ISO_3166_Entry__r.Label,
                        ISO_3166_Entry__r.Country_Name__c,
                        DeveloperName,
                        Id,
                        Label,
                        Language,
                        MasterLabel,
                        NamespacePrefix,
                        QualifiedApiName
                FROM Datasource_Per_Country__mdt WHERE Data_Source_Select_Record__c = FALSE WITH SECURITY_ENFORCED];
        return datasourcePerCountries;
    }

    public Id setUpdateTypes(List<Map<string, object>> payload) {
        string updateTypeAPIName = String.valueOf(appsolutely__Protected_Subscriber_Setting__mdt.getSObjectType());
        List<Protected_Subscriber_Setting__mdt> updateTypes = SetupService.getUpdateTypes();
        CustomMetadataCallback callback = new CustomMetadataCallback();

        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        for(Map<string, object> mdRecord : payload ){

            boolean checked = Boolean.valueOf(mdRecord.get('checked'));
            string developerName = String.valueOf(mdRecord.get('developerName')); //RecordName = DeveloperName
            string masterLabel = String.valueOf(mdRecord.get('label'));

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


}