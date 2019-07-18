/**
 * Created by jaapbranderhorst on 2019-06-20.
 */
/**
 * 'Template' class to quickly migrate data from one field to another in the same object.
 */

public inherited sharing class SimpleDataMigrationBatch implements Database.Batchable<SObject> {

    private Map<String, String> oldToNew { get; set; }

    private String SObjectName { get; set; }

    private String query {
        get {
            if (query == null) {
                query = 'SELECT Id, ';
                Set<String> fieldNames = oldToNew.keySet();
                Integer counter = 0;
                for (String str : fieldNames) {
                    query += str;
                    counter++;
                    if (counter < fieldNames.size()) {
                        query += ', ';
                    }
                }
                query += ' FROM ';
                query += SObjectName;
                if (!String.isEmpty(whereClause)) {
                    query = query + ' WHERE ' + whereClause;
                }
            }
            System.debug(query);
            return query;
        }
        set;
    }

    private String whereClause { get; set; }

    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext batchContext, List<SObject> scope){
        for(SObject recordToConvert : scope) {
            for(String oldField : oldToNew.keySet()) {
                String newField = oldToNew.get(oldField);
                if(recordToConvert.get(oldField) != null) {
                    recordToConvert.put(newField, recordToConvert.get(oldField));
                }
            }
        }
        System.debug(scope);
        update scope;
    }

    public void finish(Database.BatchableContext BC){
    }

    /**
     * Constructor
     *
     * @param oldToNew a map with as keys the API names of the old fields and as values the API names of the new fields
     * @param SOBjectName the API name of the SOBject
     * @param whereClause  the whereclause to filter the records to be migrated. If null or empty, no filter is applied
     */
    public SimpleDataMigrationBatch(Map<String, String> oldToNew, String SOBjectName, String whereClause) {
        this.oldToNew = oldToNew;
        this.SObjectName = SOBjectName;
        this.whereClause = whereClause;
    }



}