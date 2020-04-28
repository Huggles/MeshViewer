/**
 * Created by jaapbranderhorst on 02/02/2020.
 */

/**
 * Iterator to be used in the update/remove dutch dossier batches
 */

public inherited sharing class UpdatedDossiersIterator implements Iterator<Business_Dossier__c> {

    private Integer currentPageNr;
    private Integer maxPageNumber;
    private Integer currentDossierPointer;

    @TestVisible
    private List<Business_Dossier__c> dossiersOnCurrentPage;
    private List<String> updateTypes;


    public UpdatedDossiersIterator(List<String> updateTypes) {
        if (updateTypes == null) {
            CCInputException e = new CCInputException('UpdateTypes is null while trying to create an update dossiers iterator');
            ErrorLogUtil.logException(e);
            throw e;
        }
        this.updateTypes = updateTypes;
        // let's get the first page
        currentPageNr = 1;
        try {
            dossiersOnCurrentPage = retrievePage(currentPageNr);
        } catch (Exception ex) {
            ErrorLogUtil.logException(ex, true); // needs to be handled here and not in the batch since there is no way to catch these exceptions in the batch engine.
            if (!Test.isRunningTest()) // since it is in a third asynchronous thread the Apex testing framework is not able to handle the transactions correct when testing, so not throwing it in test situations
                throw ex;
        }
        currentDossierPointer = 0;
    }

    public Boolean hasNext() {
        return hasNextDossierOnCurrentPage() || hasNextPage();
    }

    public Business_Dossier__c next() {
        Business_Dossier__c dossier;
        if (!hasNextDossierOnCurrentPage() && hasNextPage()) { // turn the page
            currentPageNr++;
            try {
                dossiersOnCurrentPage = retrievePage(currentPageNr);
            } catch (Exception ex) {
                ErrorLogUtil.logException(ex, true);
                throw ex;
            }
            currentDossierPointer = 0;
        }
        dossier = null;
        if (hasNext()) {
            currentDossierPointer++;
            if (currentDossierPointer > 0 && dossiersOnCurrentPage.size() > 0) {
                dossier = dossiersOnCurrentPage[currentDossierPointer - 1];
            }
        } else {
            dossier = null; // just to make it very clear;
        }
        return dossier;
    }

    /**
     * Returns true if there are still dossiers on the current page to read
     *
     * @return
     */
    private Boolean hasNextDossierOnCurrentPage() {
        return (currentDossierPointer < (dossiersOnCurrentPage != null ? dossiersOnCurrentPage.size() : 0));
    }

    private Boolean hasNextPage() {
        return (currentPageNr < maxPageNumber);
    }

    private List<Business_Dossier__c> retrievePage(Integer pageNr) {
        // query the next page in CI
        List<UpdateDossierReferenceDTO> updateDossierReferenceDTOS = DutchBusinessService.getDutchBusinessUpdatedDossiersSince(currentPageNr, updateTypes, Date.today() - 1);

        List<Business_Dossier__c> businessDossiers = new List<Business_Dossier__c>();
        if (updateDossierReferenceDTOS != null && updateDossierReferenceDTOS.size() > 0) {
            // get the maxPageNumber
            maxPageNumber = updateDossierReferenceDTOS.get(0).numPages;

            // find the updated business dossiers in the DB
            Set<DossierQueryDTO> dossierQueryDTOS = new Set<DossierQueryDTO>();
            for (UpdateDossierReferenceDTO updateDossierReferenceDTO : updateDossierReferenceDTOS) {
                dossierQueryDTOS.add(new DossierQueryDTO(updateDossierReferenceDTO.dossier_number, updateDossierReferenceDTO.establishment_number));
            }
            businessDossiers = ((IBusinessDossierSelector) Application.Selector.newInstance(Business_Dossier__c.SObjectType)).selectByDossierNumbers(dossierQueryDTOS, false);
        }
        return  businessDossiers;
    }


}
