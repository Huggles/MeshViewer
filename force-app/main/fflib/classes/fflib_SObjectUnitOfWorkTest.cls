/**
 * Copyright (c), FinancialForce.com, inc
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice,
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice,
 *      this list of conditions and the following disclaimer in the documentation
 *      and/or other materials provided with the distribution.
 * - Neither the name of the FinancialForce.com, inc nor the names of its contributors
 *      may be used to endorse or promote products derived from this software without
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

@IsTest
private with sharing class fflib_SObjectUnitOfWorkTest
{

    private static List<Schema.SObjectType> MY_SOBJECTS2 =
            new Schema.SObjectType[] {
                    Account.SObjectType,
                    Contact.SObjectType

            };

    @isTest
    private static void testUnitOfWorkEmail()
    {
        string testRecordName = 'UoW Test Name 1';

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new list<String>{ 'foobar@test.com' });
        email.setPlainTextBody('See Spot run.');

        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(MY_SOBJECTS2);

        Account acc = new Account(Name = 'test');
        uow.registerNew( acc );

        uow.registerEmail( email );

        uow.registerRelationship( email, acc );

        uow.commitWork();

        List<Account> accs = [SELECT Id FROM Account];

        // assert that an email was sent
        system.assertEquals(1, Limits.getEmailInvocations());

        System.assertEquals(1, accs.size());
    }

    @isTest
    private static void testUnitOfWorkNewDirtyDelete()
    {
        // Insert Accounts with UnitOfWork

        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(MY_SOBJECTS2);
        for(Integer i=0; i<10; i++)
        {
            Account acc = new Account(Name = 'UoW Test Name ' + i);
            uow.registerNew(new List<SObject>{acc});
            for(Integer i2=0; i2<i+1; i2++)
            {
                Contact cont = new Contact(LastName = acc.Name + i);
                uow.registerNew(cont, Contact.AccountId, acc);

            }
        }

            uow.commitWork();


        // Assert Results
        assertResults2('UoW');

        // Records to update
        List<Account> accs = [SELECT Id, Name, (SELECT Id FROM Contacts ORDER BY Email NULLS LAST) FROM Account WHERE Name LIKE 'UoW Test Name %' ORDER BY Name];

        // Update some records with UnitOfWork
        {
            uow = new fflib_SObjectUnitOfWork(MY_SOBJECTS2);
            Account acc = accs[0];
            acc.Name = acc.Name + ' Changed';
            uow.registerDirty(new List<SObject>{acc});
            Contact cont = new Contact(LastName = acc.Name + ' : New Contact');
            uow.registerNew(cont, Contact.AccountId, acc);
            Contact existingContact = acc.Contacts[0];
            existingContact.Email = 'dirty@test.com';
            uow.registerDirty(new List<SObject>{existingContact});
            existingContact.FirstName = 'Test';
            uow.registerDirty(new List<SObject>{existingContact});
            uow.commitWork();
        }

        // Assert Results
        accs = [SELECT Id, Name, (SELECT Id, FirstName, Email FROM Contacts ORDER BY Email NULLS LAST) FROM Account WHERE Name LIKE 'UoW Test Name %' ORDER BY Name];
        System.assertEquals(10, accs.size());
        System.assertEquals('UoW Test Name 0 Changed', accs[0].Name);
        System.assertEquals(2, accs[0].Contacts.size());
        // Verify that both fields were updated properly
        System.assertEquals('dirty@test.com', accs[0].Contacts[0].Email);
        System.assertEquals('Test', accs[0].Contacts[0].FirstName);

        // Delete some records with the UnitOfWork
        {
            uow = new fflib_SObjectUnitOfWork(MY_SOBJECTS2);
            uow.registerDeleted(new List<SObject>{accs[0].Contacts[1]}); // Delete contact
            // Register the same deletions more than once.
            // This verifies that using a Map to back the deleted records collection prevents duplicate registration.
            uow.registerDeleted(new List<SObject>{accs[0].Contacts[1]}); // Delete contact
            uow.commitWork();
        }

        // Assert Results
        accs = [SELECT Id, Name, (SELECT Id, FirstName, Email FROM Contacts ORDER BY Email NULLS LAST) FROM Account WHERE Name LIKE 'UoW Test Name %' ORDER BY Name];
        System.assertEquals(10, accs.size());
        System.assertEquals('UoW Test Name 0 Changed', accs[0].Name);
        System.assertEquals(1, accs[0].Contacts.size());
    }

    private static void assertResults2(String prefix)
    {
        // Standard Assertions on tests data inserted by tests
        String filter = prefix + ' Test Name %';
        List<Account> accs = [SELECT Id, Name, (SELECT Id FROM Contacts ORDER BY Email NULLS LAST) FROM Account WHERE Name LIKE :filter ORDER BY Name];
        System.assertEquals(10, accs.size());
        System.assertEquals(1, accs[0].Contacts.size());
        System.assertEquals(2, accs[1].Contacts.size());
        System.assertEquals(3, accs[2].Contacts.size());
        System.assertEquals(4, accs[3].Contacts.size());
        System.assertEquals(5, accs[4].Contacts.size());
        System.assertEquals(6, accs[5].Contacts.size());
        System.assertEquals(7, accs[6].Contacts.size());
        System.assertEquals(8, accs[7].Contacts.size());
        System.assertEquals(9, accs[8].Contacts.size());
        System.assertEquals(10, accs[9].Contacts.size());
    }

    /**
     * Create uow with new records and commit
     *
     *	Testing:
     *
     *		- Correct events are fired when commitWork completes successfully
     *
     */
    @isTest
    private static void testDerivedUnitOfWork_CommitSuccess()
    {
        // Insert Accounts with UnitOfWork
        DerivedUnitOfWork uow = new DerivedUnitOfWork(MY_SOBJECTS2);
        for(Integer i=0; i<10; i++)
        {
            Account acc = new Account(Name = 'UoW Test Name ' + i);
            uow.registerNew(new List<SObject>{acc});
            for(Integer i2=0; i2<i+1; i2++)
            {
                Contact cont = new Contact(LastName = acc.Name + i);
                uow.registerNew(cont, Contact.AccountId, acc);

            }
        }
        uow.commitWork();

        // Assert Results
        assertResults2('UoW');

        assertEvents(new List<String> {
                'onCommitWorkStarting'
                , 'onDMLStarting'
                , 'onDMLFinished'
                , 'onDoWorkStarting'
                , 'onDoWorkFinished'
                , 'onCommitWorkFinishing'
                , 'onCommitWorkFinished - true'
            }
            , uow.getCommitWorkEventsFired(), new Set<Schema.SObjectType>(MY_SOBJECTS2), uow.getRegisteredTypes());
    }

    /**
     * Create uow with data that results in DML Exception
     *
     *	Testing:
     *
     *		- Correct events are fired when commitWork fails during DML processing
     *
     */
    @isTest
    private static void testDerivedUnitOfWork_CommitDMLFail()
    {
        // Insert contacts with UnitOfWork forcing a failure on DML by not setting 'LastName' field
        DerivedUnitOfWork uow = new DerivedUnitOfWork(MY_SOBJECTS2);
        Contact cont = new Contact();
        uow.registerNew(new List<SObject>{cont});
        Boolean didFail = false;
        System.DmlException caughtEx = null;

        try {
            uow.commitWork();
        }
        catch (System.DmlException dmlex) {
            didFail = true;
            caughtEx = dmlex;
        }

        // Assert Results
        System.assertEquals(didFail, true, 'didFail');
        System.assert(caughtEx.getMessage().contains('REQUIRED_FIELD_MISSING'), String.format('Exception message was ', new List<String> { caughtEx.getMessage() }));

        assertEvents(new List<String> {
                'onCommitWorkStarting'
                , 'onDMLStarting'
                , 'onCommitWorkFinished - false'
            }
            , uow.getCommitWorkEventsFired(), new Set<Schema.SObjectType>(MY_SOBJECTS2), uow.getRegisteredTypes());
    }

    /**
     * Create uow with work that fails
     *
     *	Testing:
     *
     *		- Correct events are fired when commitWork fails during DoWork processing
     *
     */
    @isTest
    private static void testDerivedUnitOfWork_CommitDoWorkFail()
    {
        // Insert Opporunities with UnitOfWork
        DerivedUnitOfWork uow = new DerivedUnitOfWork(MY_SOBJECTS2);
        Contact cont = new Contact(LastName = 'last');
        uow.registerNew(new List<SObject>{cont});

        // register work that will fail during processing
        FailDoingWork fdw = new FailDoingWork();
        uow.registerWork(fdw);

        Boolean didFail = false;
        FailDoingWorkException caughtEx = null;

        try {
            uow.commitWork();
        }
        catch (FailDoingWorkException fdwe) {
            didFail = true;
            caughtEx = fdwe;
        }

        // Assert Results
        System.assertEquals(didFail, true, 'didFail');
        System.assert(caughtEx.getMessage().contains('Work failed.'), String.format('Exception message was ', new List<String> { caughtEx.getMessage() }));

        assertEvents(new List<String> {
                'onCommitWorkStarting'
                , 'onDMLStarting'
                , 'onDMLFinished'
                , 'onDoWorkStarting'
                , 'onCommitWorkFinished - false'
            }
            , uow.getCommitWorkEventsFired(), new Set<Schema.SObjectType>(MY_SOBJECTS2), uow.getRegisteredTypes());
    }

    /**
     * Assert that actual events exactly match expected events (size, order and name)
     * and types match expected types
     */
    private static void assertEvents(List<String> expectedEvents, List<String> actualEvents, Set<Schema.SObjectType> expectedTypes, Set<Schema.SObjectType> actualTypes)
    {
        // assert that events match
        System.assertEquals(expectedEvents.size(), actualEvents.size(), 'events size');
        for (Integer i = 0; i < expectedEvents.size(); i++)
        {
            System.assertEquals(expectedEvents[i], actualEvents[i], String.format('Event {0} was not fired in order expected.', new List<String> { expectedEvents[i] }));
        }

        // assert that types match
        System.assertEquals(expectedTypes.size(), actualTypes.size(), 'types size');
        for (Schema.SObjectType sObjectType :expectedTypes)
        {
            System.assertEquals(true, actualTypes.contains(sObjectType), String.format('Type {0} was not registered.', new List<String> { sObjectType.getDescribe().getName() }));
        }
    }

    /**
     * DoWork implementation that throws exception during processing
     */
    private class FailDoingWork implements fflib_SObjectUnitOfWork.IDoWork
    {
        public void doWork()
        {
            throw new FailDoingWorkException('Work failed.');
        }
    }

    /**
     * Derived unit of work that tracks event notifications and handle registration of type
     */
    private class DerivedUnitOfWork extends fflib_SObjectUnitOfWork
    {
        private List<String> m_commitWorkEventsFired = new List<String>();
        private Set<Schema.SObjectType> m_registeredTypes = new Set<Schema.SObjectType>();

        public List<String> getCommitWorkEventsFired()
        {
            return m_commitWorkEventsFired.clone();
        }

        public Set<Schema.SObjectType> getRegisteredTypes()
        {
            return m_registeredTypes.clone();
        }

        public DerivedUnitOfWork(List<Schema.SObjectType> sObjectTypes)
        {
            super(sObjectTypes);
        }

        public DerivedUnitOfWork(List<Schema.SObjectType> sObjectTypes, IDML dml)
        {
            super(sObjectTypes, dml);
        }

        private void addEvent(String event)
        {
            // events should only be fired one time
            // ensure that this event has not been fired already
            for (String eventName :m_commitWorkEventsFired)
            {
                if (event == eventName)
                {
                    throw new DerivedUnitOfWorkException(String.format('Event {0} has already been fired.', new List<String> { event }));
                }
            }
            m_commitWorkEventsFired.add(event);
        }

        public override void onRegisterType(Schema.SObjectType sObjectType)
        {
            if (m_registeredTypes.contains(sObjectType))
            {
                throw new DerivedUnitOfWorkException(String.format('Type {0} has already been registered.', new List<String> { sObjectType.getDescribe().getName() }));
            }
            m_registeredTypes.add(sObjectType);
        }

        public override void onCommitWorkStarting()
        {
            addEvent('onCommitWorkStarting');
        }

        public override void onDMLStarting()
        {
            addEvent('onDMLStarting');
        }

        public override void onDMLFinished()
        {
            addEvent('onDMLFinished');
        }

        public override void onDoWorkStarting()
        {
            addEvent('onDoWorkStarting');
        }

        public override void onDoWorkFinished()
        {
            addEvent('onDoWorkFinished');
        }

        public override void onCommitWorkFinishing()
        {
            addEvent('onCommitWorkFinishing');
        }

        public override void onCommitWorkFinished(Boolean wasSuccessful)
        {
            addEvent('onCommitWorkFinished - ' + wasSuccessful);
        }
    }

    public class DerivedUnitOfWorkException extends Exception {}
    public class FailDoingWorkException extends Exception {}
}