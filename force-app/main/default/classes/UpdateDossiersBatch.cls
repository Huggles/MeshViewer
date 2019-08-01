/**
 * Created by tejaswinidandi on 2019-07-19.
 */

public with sharing class UpdateDossiersBatch implements Database.Batchable<Business_Dossier__c>, Database.AllowsCallouts, Database.Stateful{

    public Integer pageNr = 1;
    public Integer numPages;

    public List<Business_Dossier__c> start(Database.BatchableContext BC){
        //collect list of dossiers that are removed from the Chamber of Commerce, for these dutchBusinessUpdateRemoveDossier should be called or marked as IsRemoved
        List<UpdateDossierReferenceDTO> updateDossiersRemovedList = new List<UpdateDossierReferenceDTO>();

        //call to company.info server to get list of dossiers with update
        List<UpdateDossierReferenceDTO> updateDossierReferenceDTOS = BusinessService.getChangedDossiers(pageNr);
        Set<String> dossierNrs = new Set<String>();
        Set<String> establishmentNrs = new Set<String>();

        for (UpdateDossierReferenceDTO updateDossierReferenceDTO : updateDossierReferenceDTOS) {
            dossierNrs.add(updateDossierReferenceDTO.dossier_number);
            establishmentNrs.add(updateDossierReferenceDTO.establishment_number);
            numPages = updateDossierReferenceDTO.numPages;
            if( updateDossierReferenceDTO.update_types.contains('Removed') ) {
                updateDossiersRemovedList.add(updateDossierReferenceDTO);
            }
        }

        //filter the dossiers which are there in salesforce
        Map<Id, Business_Dossier__c>  dossiers = new Map<Id, Business_Dossier__c>([SELECT Name, Establishment_Number__c, Dossier_Number__c, Account__c, Is_Removed__c
                                                                                  FROM Business_Dossier__c
                                                                                  WHERE Dossier_Number__c IN :dossierNrs OR Establishment_Number__c IN :establishmentNrs]);

        //if any of the dossiers are removed from the company.info server then mark the Is_Removed__c field to true
        if (updateDossiersRemovedList.size() > 0) {
            Map<String, Business_Dossier__c> dossierMap = new Map<String, Business_Dossier__c>();
            for (Business_Dossier__c businessDossier : dossiers.values()) {
                dossierMap.put(businessDossier.Dossier_Number__c+businessDossier.Establishment_Number__c, businessDossier);
            }

            for (UpdateDossierReferenceDTO updateRemovedDossier : updateDossiersRemovedList) {
                Business_Dossier__c bd = dossierMap.get(updateRemovedDossier.dossier_number+updateRemovedDossier.establishment_number);
                if ( bd != null) {
                    bd.Is_Removed__c = true;
                    dossiers.put(bd.Id, bd);
                }
            }
        }

        return dossiers.values();

    }

    public void execute(Database.BatchableContext BC, List<Business_Dossier__c> scope){
        List<UpdateDossierRequestDTO> updateDossierRequestDTOS = new List<UpdateDossierRequestDTO>();

        List<Business_Dossier__c> removeDossiers = new List<Business_Dossier__c>();

        //callout to server with getDossier method for each dossier
        for (Business_Dossier__c businessDossier : scope) {
            if ( ! businessDossier.Is_Removed__c) {
                DutchBusinessWsdl.DutchBusinessDossierV3 dossierV3 = new BusinessServiceImpl().getDossier(businessDossier.Dossier_Number__c, businessDossier.Establishment_Number__c);
                updateDossierRequestDTOS.add(new UpdateDossierRequestDTO(dossierV3, businessDossier ));
            }
            else{
                removeDossiers.add(businessDossier);
            }
        }

        //update the dossiers
        List<Business_Dossier__c> businessDossiers1 = BusinessService.updateDossiersWithDataVendorData(updateDossierRequestDTOS);

        //update the removed dossiers
        if (removeDossiers.size() > 0) {
            Database.update(removeDossiers, false);
        }
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
        else {
            //once all pages are retrieved then update the Last_Executed_Batch__c with current time
            Credentials__c cs = Credentials__c.getOrgDefaults();
            cs.Last_Executed_Batch__c = Datetime.now();

            update cs;
        }
    }
}