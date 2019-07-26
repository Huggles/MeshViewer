/**
 * Created by tejaswinidandi on 2019-07-19.
 */

public with sharing class UpdateDossiersBatch implements Database.Batchable<Business_Dossier__c>, Database.AllowsCallouts, Database.Stateful{

    public Integer pageNr = 1;
    public Integer numPages;

    public List<Business_Dossier__c> start(Database.BatchableContext BC){

        //call to company.info server to get list of dossiers with update
        List<UpdateDossierReferenceDTO> updateDossierReferenceDTOS = BusinessService.getChangedDossiers(pageNr);
        Set<String> dossierNrs = new Set<String>();
        Set<String> establishmentNrs = new Set<String>();

        for (UpdateDossierReferenceDTO updateDossierReferenceDTO : updateDossierReferenceDTOS) {
            dossierNrs.add(updateDossierReferenceDTO.dossier_number);
            establishmentNrs.add(updateDossierReferenceDTO.establishment_number);
            numPages = updateDossierReferenceDTO.numPages;
        }

        //filter the dossiers which are there in salesforce
        List<Business_Dossier__c> dossiers = [SELECT Name, Establishment_Number__c, Dossier_Number__c, Account__c
                                              FROM Business_Dossier__c
                                              WHERE Dossier_Number__c IN :dossierNrs OR Establishment_Number__c IN :establishmentNrs];

        return dossiers;

    }

    public void execute(Database.BatchableContext BC, List<Business_Dossier__c> scope){
        List<UpdateDossierRequestDTO> updateDossierRequestDTOS = new List<UpdateDossierRequestDTO>();

        //get unique dossiers
        Set<Business_Dossier__c> businessDossiers = new Set<Business_Dossier__c>();
        businessDossiers.addAll(scope);

        //callout to server with getDossier method for each dossier
        for (Business_Dossier__c businessDossier : businessDossiers) {
            DutchBusinessWsdl.DutchBusinessDossierV3 dossierV3 = new BusinessServiceImpl().getDossier(businessDossier.Dossier_Number__c, businessDossier.Establishment_Number__c);
            updateDossierRequestDTOS.add(new UpdateDossierRequestDTO(dossierV3, businessDossier ));
        }

        //update the dossiers
        List<Business_Dossier__c> businessDossiers = BusinessService.updateDossiersWithDataVendorData(updateDossierRequestDTOS);
    }

    public void finish(Database.BatchableContext BC){
        //create a new batch to chain with the previous batch until all pages from the dutchBusinessUpdateGetChangedDossiers retrieved
        UpdateDossiersBatch updateDossiersBatch = new UpdateDossiersBatch();
        updateDossiersBatch.pageNr = pageNr+1;
        updateDossiersBatch.numPages = this.numPages;

        if (updateDossiersBatch.pageNr <= updateDossiersBatch.numPages) {
            //batch size of 50 or less is preferred, as we do a fallback call when 1st call to server fails and will not hit callout limit
            Database.executeBatch(updateDossiersBatch, 50);
        }
    }
}