
/****************************************************************************************
Author          : ValerijsProkudins
******************************************************************************************/
public inherited sharing class BusinessDossierSelector extends fflib_SObjectSelector implements IBusinessDossierSelector  {

    public static IBusinessDossierSelector newInstance() {

        return (IBusinessDossierSelector) Application.Selector.newInstance(Business_Dossier__c.SObjectType);
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                Business_Dossier__c.Id,
                Business_Dossier__c.Name,
                Business_Dossier__c.Dossier_Number__c,
                Business_Dossier__c.Establishment_Number__c,
                Business_Dossier__c.VAT_Number__c,
                Business_Dossier__c.RecordTypeId,
                Business_Dossier__c.Creditsafe_Id__c
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Business_Dossier__c.SObjectType;
    }

    public List<Business_Dossier__c> selectByDossierNumber(Set<String> dossierNumSet, Boolean enforceFLS){//, String sortedBy, String sortedDirection) {
        fflib_QueryFactory queryFactory = newQueryFactory();
        List<Business_Dossier__c> result = new List<Business_Dossier__c>();
        queryFactory.setEnforceFLS(enforceFLS);
        queryFactory.setCondition('Dossier_Number__c IN :dossierNumSet');
        result = Database.query(queryFactory.toSOQL());
        return result;
    }

    /**
     * Selects all dossiers with the same vat number
     *
     * @param vatNumber
     *
     * @return a list with the found dossiers (empty if none has been found)
     */
    public List<Business_Dossier__c> selectByVatNumber(String vatNumber, Boolean enforceFLS) {
        fflib_QueryFactory queryFactory = newQueryFactory();
        List<Business_Dossier__c> result = new List<Business_Dossier__c>();
        queryFactory.setEnforceFLS(enforceFLS);
        queryFactory.setCondition('VAT_Number__c = :vatNumber');
        result = Database.query(queryFactory.toSOQL());
        return result;
    }

    /**
     * Selects all dossiers with the same credit safe id
     *
     * @param creditSafeId
     *
     * @return a list with the found dossiers (empty if none have been found)
     */
    public List<Business_Dossier__c> selectByCreditSafeId(String creditSafeId, Boolean enforceFLS) {
        fflib_QueryFactory queryFactory = newQueryFactory();
        List<Business_Dossier__c> result = new List<Business_Dossier__c>();
        queryFactory.setEnforceFLS(enforceFLS);
        queryFactory.setCondition('Creditsafe_Id__c = :creditSafeId');
        result = Database.query(queryFactory.toSOQL());
        return result;
    }


    public List<Business_Dossier__c> selectByDossierNumbers(Set<DossierQueryDTO> dossierQueryDTOS, Boolean enforceFLS){//, String sortedBy, String sortedDirection) {
        fflib_QueryFactory queryFactory = newQueryFactory();
        List<Business_Dossier__c> result = new list<Business_Dossier__c>();
        queryFactory.setEnforceFLS(enforceFLS);
        Set<String> dossierNumbers = new Set<String>();
        Set<String> establishmentNumbers = new Set<String>();
        Set<String> uniqueKeys = new Set<String>();
        for (DossierQueryDTO dossierQueryDTO : dossierQueryDTOS) {
            dossierNumbers.add(dossierQueryDTO.dossierNumber);
            establishmentNumbers.add(dossierQueryDTO.establishmentNumber);
            uniqueKeys.add(dossierQueryDTO.dossierNumber + dossierQueryDTO.establishmentNumber);
        }
        queryFactory.setCondition('Dossier_Number__c IN :dossierNumbers AND Establishment_Number__c IN :establishmentNumbers');
        // queryFactory.setLimit(20); //TODO although this is a best practice it can result in limitations.
        List<Business_Dossier__c> wideResult = Database.query(queryFactory.toSOQL());
        // only select the combinations of dossierNumbers and establishmentNumbers we want from it
        for (Business_Dossier__c businessDossier : wideResult) {
            if (uniqueKeys.contains(businessDossier.Dossier_Number__c + businessDossier.Establishment_Number__c)) {
                result.add(businessDossier);
            }
        }
        return result;
    }

    public List<Business_Dossier__c> selectById(set<Id> dosserIdSet){
        return (List<Business_Dossier__c>) selectSObjectsById(dosserIdSet);
    }

}
