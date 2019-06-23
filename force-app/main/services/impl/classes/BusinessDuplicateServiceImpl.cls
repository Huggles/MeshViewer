/**
 * Created by jaapbranderhorst on 2019-06-19.
 */

public without sharing class BusinessDuplicateServiceImpl implements IBusinessDuplicateService {

    public List<CheckDuplicateDossierResponse> checkForDuplicateDossiers(List<CheckDuplicateDossierRequest> requests) {
        try {
            // prep the query
            Set<DossierQueryDTO> queryDTOS = new Set<DossierQueryDTO>();
            for (CheckDuplicateDossierRequest checkDuplicateDossierRequest : requests) {
                queryDTOS.add(new DossierQueryDTO(checkDuplicateDossierRequest.dossierNumber, checkDuplicateDossierRequest.establishmentNumber));
            }
            // execute the query
            List<Business_Dossier__c> dossiers = BusinessDossierSelector.newInstance().selectByDossierNumbers(queryDTOS, false);

            // map the found dossiers on the request params
            Map<String, Business_Dossier__c> dossiersByDossierAndEstablishmentNumber = new Map<String, Business_Dossier__c>();
            for (Business_Dossier__c businessDossier : dossiers) {
                dossiersByDossierAndEstablishmentNumber.put(businessDossier.Dossier_Number__c + businessDossier.Establishment_Number__c, businessDossier);
            }
            List<CheckDuplicateDossierResponse> result = new List<CheckDuplicateDossierResponse>();
            for (CheckDuplicateDossierRequest checkDuplicateDossierRequest : requests) {
                String key = checkDuplicateDossierRequest.dossierNumber + checkDuplicateDossierRequest.establishmentNumber;
                result.add(new CheckDuplicateDossierResponse(
                        checkDuplicateDossierRequest.dossierNumber,
                        checkDuplicateDossierRequest.establishmentNumber,
                        dossiersByDossierAndEstablishmentNumber.get(key))
                );
            }
            return result;
        } catch (Exception ex) {
            ErrorLogUtil.logException(ex); // logging whenever we catch any exception other than CCException type
            throw new CCException(System.Label.DBSCall_Unknown_Exception, ex);
        }
    }

    /**
     * checks for account duplicates. Return a List of IDs if duplicates for the given account exist.
     *
     * @param acc
     *
     * @return
     */
    public List<Account> checkForAccountDuplicates(Account acc){
        List<Account> result = new List<Account>();
        try{
            Datacloud.FindDuplicatesResult[] results = Datacloud.FindDuplicates.findDuplicates(new List<Account>{acc});
            for (Datacloud.FindDuplicatesResult dupeResult : results) {
                for (Datacloud.DuplicateResult dupeRes : dupeResult.getDuplicateResults()) {
                    for (Datacloud.MatchResult matchRes : dupeRes.getMatchResults()) {
                        for (Datacloud.MatchRecord matchRec : matchRes.getMatchRecords()) {
                            result.add((Account)matchRec.getRecord());
                        }
                    }
                }
            }
        }catch(System.HandledException e){ // thrown if no duplicate rules are active. Let it fail silently to cover for orgs without duplicate management
            System.debug(LoggingLevel.INFO, 'No duplicate management for accounts in this org');
        }
        return result;
    }

}