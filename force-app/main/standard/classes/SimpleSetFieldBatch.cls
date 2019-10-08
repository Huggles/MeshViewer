/**
 * Created by jaapbranderhorst on 2019-07-16.
 *
 * Sets a constant to the given field for all records in the where clause. Handy to quickly update recordtype ids for example.
 */

public without sharing class SimpleSetFieldBatch implements Database.Batchable<SObject> {

    private String whereClause { get; set; }

    private String sObjectName { get; set; }

    private Map<String, Object> constantValuesByFieldName { get; set; }

    private String query {
        get {
            if (query == null) {
                query = 'SELECT Id FROM ';
                query += SObjectName;
                if (!String.isEmpty(whereClause)) {
                    query = query + ' WHERE ' + whereClause;
                }
            }
            return query;
        }
        set;
    }

    public Database.QueryLocator start(Database.BatchableContext context) {
        System.debug(query);
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext param1, List<SObject> scope) {
        System.debug(scope);
        for(SObject recordToConvert : scope) {
            for(String fieldName : constantValuesByFieldName.keySet()) {
                System.debug('before ' + recordToConvert);
                recordToConvert.put(fieldName, constantValuesByFieldName.get(fieldName));
                System.debug('after ' + recordToConvert);
            }
        }
        System.debug('after ' + scope);
        update scope;
    }

    public void finish(Database.BatchableContext param1) {
    }

    public SimpleSetFieldBatch(Map<String, Object> constantValuesByFieldName, String sObjectName, String whereClause) {
        this.whereClause = whereClause;
        this.sObjectName = sObjectName;
        this.constantValuesByFieldName = constantValuesByFieldName;
    }




}