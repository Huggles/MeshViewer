/**
 * Created by jaapbranderhorst on 04/03/2020.
 *
 * Implementation of IDoWork to upsert records based on the id. If the same record is also registered for update,
 * registering the record here as well will cause triggers etc. to be fired twice
 */

public inherited sharing abstract class AbstractUpsertUnitOfWork implements fflib_SObjectUnitOfWork.IDoWork
{
    public Database.UpsertResult[] Results {get; private set;}

    protected List<SObject> m_records;

    /**
     * Override the constructor in your concrete class and initialize m_records with a concrete List
     */
    public AbstractUpsertUnitOfWork()
    {
        // m_records = new List<Business_Dossier__c>();
    }

    public void registerUpsert(SObject record)
    {
        m_records.add(record);
    }

    public void registerUpsert(List<SObject> records) {
        m_records.addAll(records);
    }

    public void doWork()
    {
        Results = Database.upsert(m_records, false);
    }
}