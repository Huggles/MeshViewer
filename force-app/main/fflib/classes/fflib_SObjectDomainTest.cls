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
private with sharing class fflib_SObjectDomainTest 
{	
	@IsTest
	private static void testValidationWithoutDML()
	{
		fflib_SObjectDomain.TestSObjectDomain contacts = new fflib_SObjectDomain.TestSObjectDomain(new Contact[] { new Contact ( LastName = 'Test' ) } );
		contacts.onValidate();
		System.assertEquals(1, fflib_SObjectDomain.Errors.getAll().size());		
		System.assertEquals('You must provide an Account for Contacts.', fflib_SObjectDomain.Errors.getAll()[0].message);
		System.assertEquals(Contact.AccountId, ((fflib_SObjectDomain.FieldError)fflib_SObjectDomain.Errors.getAll()[0]).field);

		contacts = new fflib_SObjectDomain.TestSObjectDomain(new SObject[] { new Contact ( LastName = 'Test' ) }, Contact.SObjectType );
		System.assertEquals(1, fflib_SObjectDomain.Errors.getAll().size());		
		System.assertEquals('You must provide an Account for Contacts.', fflib_SObjectDomain.Errors.getAll()[0].message);
		System.assertEquals(Contact.AccountId, ((fflib_SObjectDomain.FieldError)fflib_SObjectDomain.Errors.getAll()[0]).field);		
	}
	
	@IsTest
	private static void testInsertValidationFailedWithoutDML()
	{
		Contact cont = new Contact ( LastName = 'Test' );
		System.assertEquals(false, fflib_SObjectDomain.Test.Database.hasRecords());
		fflib_SObjectDomain.Test.Database.onInsert(new Contact[] { cont } );		
		System.assertEquals(true, fflib_SObjectDomain.Test.Database.hasRecords());
		fflib_SObjectDomain.triggerHandler(fflib_SObjectDomain.TestSObjectDomainConstructor.class);		
		System.assertEquals(1, fflib_SObjectDomain.Errors.getAll().size());		
		System.assertEquals('You must provide an Account for Contacts.', fflib_SObjectDomain.Errors.getAll()[0].message);
		System.assertEquals(Contact.AccountId, ((fflib_SObjectDomain.FieldError)fflib_SObjectDomain.Errors.getAll()[0]).field); 		
	}

	@IsTest
	private static void testUpdateValidationFailedWithoutDML()
	{
		Id myid = fflib_IDGenerator.generate(Contact.SObjectType);
		Contact oldContact = (Contact) Contact.SObjectType.newSObject(myid);
		oldContact.LastName = 'Test';
		oldContact.FirstName = 'Test old';
		Contact newContact = (Contact) Contact.SObjectType.newSObject(myid);
		oldContact.LastName = 'Test';
		oldContact.FirstName = 'Test new';
		System.assertEquals(false, fflib_SObjectDomain.Test.Database.hasRecords());		
		fflib_SObjectDomain.Test.Database.onUpdate(new Contact[] { newContact }, new Map<Id, SObject> { newContact.Id => oldContact } );
		System.assertEquals(true, fflib_SObjectDomain.Test.Database.hasRecords());				
		fflib_SObjectDomain.triggerHandler(fflib_SObjectDomain.TestSObjectDomainConstructor.class);		
		System.assertEquals(1, fflib_SObjectDomain.Errors.getAll().size());		
		System.assertEquals('You cannot change the Contact firstname once it has been created.', fflib_SObjectDomain.Errors.getAll()[0].message);
		System.assertEquals(Contact.FirstName, ((fflib_SObjectDomain.FieldError)fflib_SObjectDomain.Errors.getAll()[0]).field); 		
	}
	
	@IsTest
	private static void testOnBeforeDeleteWithoutDML()
	{
		Id myid = fflib_IDGenerator.generate(Contact.SObjectType);
		Contact oldContact = (Contact) Contact.SObjectType.newSObject(myid);
		oldContact.LastName = 'Test';
		oldContact.FirstName = 'Test old';
		System.assertEquals(false, fflib_SObjectDomain.Test.Database.hasRecords());		
		fflib_SObjectDomain.Test.Database.onDelete(new Map<ID, Contact> { oldContact.Id => oldContact } );		
		System.assertEquals(true, fflib_SObjectDomain.Test.Database.hasRecords());				
		fflib_SObjectDomain.triggerHandler(fflib_SObjectDomain.TestSObjectDomainConstructor.class);		
		System.assertEquals(1, fflib_SObjectDomain.Errors.getAll().size());		
		System.assertEquals('You cannot delete this Contact.', fflib_SObjectDomain.Errors.getAll()[0].message);
	}
	
	@IsTest
	private static void testOnAfterUndeleteWithoutDML()
	{
		Id myid = fflib_IDGenerator.generate(Contact.SObjectType);
		Contact oldContact = (Contact) Contact.SObjectType.newSObject(myid);
		oldContact.LastName = 'Test';
		oldContact.FirstName = 'Test old';
		System.assertEquals(false, fflib_SObjectDomain.Test.Database.hasRecords());		
		fflib_SObjectDomain.Test.Database.onUndelete(new list<Contact> { oldContact } );
		System.assertEquals(true, fflib_SObjectDomain.Test.Database.hasRecords());				
		fflib_SObjectDomain.triggerHandler(fflib_SObjectDomain.TestSObjectDomainConstructor.class);		
	}
	
	@IsTest
	private static void testObjectSecurity()
	{
		// Create a user which will not have access to the test object type
		User testUser = createChatterExternalUser();
		if(testUser==null)
			return; // Abort the test if unable to create a user with low enough acess
		System.runAs(testUser)
		{					
			// Test Create object security
			Contact cont = new Contact ( FirstName = 'test', LastName = 'test');
			fflib_SObjectDomain.Test.Database.onInsert(new Contact[] { cont } );
			try {
				fflib_SObjectDomain.triggerHandler(fflib_SObjectDomain.TestSObjectDomainConstructor.class);
				System.assert(false, 'Expected access denied exception');						
			} catch (Exception e) {
				System.assertEquals('Permission to create an Contact denied.', e.getMessage());
			}		
			
			// Test Update object security
			Id myid = fflib_IDGenerator.generate(Contact.SObjectType);
			Contact existingContact = (Contact) Contact.SObjectType.newSObject(myid);
			existingContact.LastName = 'Test';
			existingContact.FirstName = 'Test old';
			fflib_SObjectDomain.Test.Database.onUpdate(new List<Contact> { cont }, new Map<Id, Contact> { cont.Id => existingContact } );
			try {
				fflib_SObjectDomain.triggerHandler(fflib_SObjectDomain.TestSObjectDomainConstructor.class);
				System.assert(false, 'Expected access denied exception');						
			} catch (Exception e) {
				System.assertEquals('Permission to udpate an Contact denied.', e.getMessage());
			}		
			
			// Test Delete object security
			fflib_SObjectDomain.Test.Database.onDelete(new Map<Id, Contact> { cont.Id => cont });
			try {
				fflib_SObjectDomain.triggerHandler(fflib_SObjectDomain.TestSObjectDomainConstructor.class);
				System.assert(false, 'Expected access denied exception');						
			} catch (Exception e) {
				System.assertEquals('Permission to delete an Contact denied.', e.getMessage());
			}		
		}			
	}
	
	@IsTest
	private static void testErrorLogging()
	{	
		// Test static helpers for raise none domain object instance errors
		Contact cont = new Contact ( FirstName = 'test', LastName = 'test');
		fflib_SObjectDomain.Errors.error('Error', cont);
		fflib_SObjectDomain.Errors.error('Error', cont, Contact.FirstName);
		System.assertEquals(2, fflib_SObjectDomain.Errors.getAll().size());		
		System.assertEquals('Error', fflib_SObjectDomain.Errors.getAll()[0].message);
		System.assertEquals('Error', fflib_SObjectDomain.Errors.getAll()[1].message);
		System.assertEquals(Contact.FirstName, ((fflib_SObjectDomain.FieldError)fflib_SObjectDomain.Errors.getAll()[1]).field);
		fflib_SObjectDomain.Errors.clearAll();		
		System.assertEquals(0, fflib_SObjectDomain.Errors.getAll().size());		
	}
	
	@IsTest
	private static void testTriggerState()
	{
		Contact cont = new Contact ( FirstName = 'test', LastName = 'test');
		fflib_SObjectDomain.Test.Database.onInsert(new Contact[] { cont } );
		fflib_SObjectDomain.triggerHandler(fflib_SObjectDomain.TestSObjectStatefulDomainConstructor.class);		
		System.assertEquals(1, fflib_SObjectDomain.Errors.getAll().size());		
		System.assertEquals('Error on Record test', fflib_SObjectDomain.Errors.getAll()[0].message);
	}	

	@IsTest
	private static void testRecursiveTriggerState()
	{
		Contact cont = new Contact ( FirstName = 'test', LastName = 'Test Recursive 1');
		fflib_SObjectDomain.Test.Database.onInsert(new Contact[] { cont } );
		fflib_SObjectDomain.triggerHandler(fflib_SObjectDomain.TestSObjectStatefulDomainConstructor.class);		
		System.assertEquals(2, fflib_SObjectDomain.Errors.getAll().size());		
		System.assertEquals('Error on Record Test Recursive 2', fflib_SObjectDomain.Errors.getAll()[0].message);
		System.assertEquals('Error on Record Test Recursive 1', fflib_SObjectDomain.Errors.getAll()[1].message);
	}	

	@IsTest
	private static void testOnValidateBehaviorDefault()
	{
		Id myid = fflib_IDGenerator.generate(Contact.SObjectType);
		Contact oldContact = (Contact) Contact.SObjectType.newSObject(myid);
		oldContact.LastName = 'Test Default Behaviour';
		oldContact.FirstName = 'Existing Account';
		Contact newContact = (Contact) Contact.SObjectType.newSObject(myid);
		newContact.LastName = 'Test Default Behaviour';
		newContact.FirstName = 'New Account';
		fflib_SObjectDomain.Test.Database.onUpdate(new Contact[] { newContact }, new Map<Id, SObject> { newContact.Id => oldContact } );
		fflib_SObjectDomain.triggerHandler(fflib_SObjectDomain.TestSObjectOnValidateBehaviourConstructor.class);		
	}	

	@IsTest
	private static void testOnValidateBehaviorOld()
	{
		Id myid = fflib_IDGenerator.generate(Contact.SObjectType);
		Contact oldContact = (Contact) Contact.SObjectType.newSObject(myid);
		oldContact.LastName = 'Test Enable Old Behaviour';
		oldContact.FirstName = 'Existing Account';
		Contact newContact = (Contact) Contact.SObjectType.newSObject(myid);
		newContact.LastName = 'Test Enable Old Behaviour';
		newContact.FirstName = 'New Account';
		fflib_SObjectDomain.Test.Database.onUpdate(new Contact[] { newContact }, new Map<Id, SObject> { newContact.Id => oldContact } );
		try {		
			fflib_SObjectDomain.triggerHandler(fflib_SObjectDomain.TestSObjectOnValidateBehaviourConstructor.class);
			System.assert(false, 'Expected exception');
		} catch (Exception e) {
			System.assertEquals('onValidate called', e.getMessage());
		}
	}	
	
	/**
	 * Create test user
	 **/
	private static User createChatterExternalUser()
	{
		// Can only proceed with test if we have a suitable profile - Chatter External license has no access to Opportunity
		List<Profile> testProfiles = [Select Id From Profile where UserLicense.Name='Chatter External' limit 1];
		if(testProfiles.size()!=1)
			return null; 		

		// Can only proceed with test if we can successfully insert a test user 
		String testUsername = System.now().format('yyyyMMddhhmmss') + '@testorg.com';
		User testUser = new User(Alias = 'test1', Email='testuser1@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = testProfiles[0].Id, TimeZoneSidKey='America/Los_Angeles', UserName=testUsername);
		try {
			insert testUser;
		} catch (Exception e) {
			return null;
		}		
		return testUser;
	}

	/**
	 *	The following tests that the ability to enable/disable all trigger events works as required
	 **/
	@IsTest
	private static void testDisableTriggerEventsBehaviour()
	{
		boolean bError = false;

		String  sErrorMessage = '';

		Id myid = fflib_IDGenerator.generate(Contact.SObjectType);
		Contact oldContact = (Contact) Contact.SObjectType.newSObject(myid);
		oldContact.LastName = 'Test';
		oldContact.FirstName = 'Existing';
		Contact newContact = (Contact) Contact.SObjectType.newSObject(myid);
		newContact.LastName = 'Test';
		newContact.FirstName = 'New';

		// these will be called multiple times making sure the correct error message comes back out
		// so... there are alot of tests to do here sadly and remember everything is reversed and you need to run backwards!
		// 1 - all disabled 
		try
		{
			fflib_SObjectDomain.getTriggerEvent(fflib_SObjectDomain.TestSObjectDisableBehaviourConstructor.class).disableAll();
			fflib_SObjectDomain.Test.Database.onInsert(new Contact[] { newContact } );
			fflib_SObjectDomain.triggerHandler(fflib_SObjectDomain.TestSObjectDisableBehaviourConstructor.class);
		}
		catch (Exception e)
		{
			bError = true;
		}

		System.AssertEquals(false, bError, 'Error - Trigger events have been fired when they are disabled');

		////////////////////////////
		// Insert!
		try
		{
			// now lets go after insert and then before
			fflib_SObjectDomain.getTriggerEvent(fflib_SObjectDomain.TestSObjectDisableBehaviourConstructor.class).enableAfterInsert();
			fflib_SObjectDomain.Test.Database.onInsert(new Contact[] { newContact });
			fflib_SObjectDomain.triggerHandler(fflib_SObjectDomain.TestSObjectDisableBehaviourConstructor.class);
		}
		catch (Exception e)
		{
			sErrorMessage = e.getMessage();
			System.Debug('Exception Fired :' + e.getMEssage());
		}

		System.AssertEquals('onAfterInsert called', sErrorMessage, 'Error - After Insert Event is enabled but did not run');

		try
		{
			// now lets go after insert and then before
			fflib_SObjectDomain.getTriggerEvent(fflib_SObjectDomain.TestSObjectDisableBehaviourConstructor.class).enableBeforeInsert();
			fflib_SObjectDomain.Test.Database.onInsert(new Contact[] { newContact });
			fflib_SObjectDomain.triggerHandler(fflib_SObjectDomain.TestSObjectDisableBehaviourConstructor.class);
		}
		catch (Exception e)
		{
			sErrorMessage = e.getMessage();
		}

		System.AssertEquals('onBeforeInsert called', sErrorMessage, 'Error - Before Insert Event is enabled but did not run');

		////////////////////////////
		// Update!
		try
		{
			// now lets go after insert and then before
			fflib_SObjectDomain.getTriggerEvent(fflib_SObjectDomain.TestSObjectDisableBehaviourConstructor.class).enableAfterUpdate();
			fflib_SObjectDomain.Test.Database.onUpdate(new Contact[] { newContact }, new Map<Id, SObject> { newContact.Id => oldContact } );
			fflib_SObjectDomain.triggerHandler(fflib_SObjectDomain.TestSObjectDisableBehaviourConstructor.class);
		}
		catch (Exception e)
		{
			sErrorMessage = e.getMessage();
		}

		System.AssertEquals('onAfterUpdate called', sErrorMessage, 'Error - After Update Event is enabled but did not run');

		try
		{
			// now lets go after insert and then before
			fflib_SObjectDomain.getTriggerEvent(fflib_SObjectDomain.TestSObjectDisableBehaviourConstructor.class).enableBeforeUpdate();
			fflib_SObjectDomain.Test.Database.onUpdate(new Contact[] { newContact }, new Map<Id, SObject> { newContact.Id => oldContact } );
			fflib_SObjectDomain.triggerHandler(fflib_SObjectDomain.TestSObjectDisableBehaviourConstructor.class);
		}
		catch (Exception e)
		{
			sErrorMessage = e.getMessage();	
		}

		System.AssertEquals('onBeforeUpdate called', sErrorMessage, 'Error - Before Update Event is enabled but did not run');

		////////////////////////////
		// Delete!
		try
		{
			// now lets go after insert and then before
			fflib_SObjectDomain.getTriggerEvent(fflib_SObjectDomain.TestSObjectDisableBehaviourConstructor.class).enableAfterDelete();
			fflib_SObjectDomain.Test.Database.onDelete(new Map<Id, Contact> { newContact.Id => newContact } );
			fflib_SObjectDomain.triggerHandler(fflib_SObjectDomain.TestSObjectDisableBehaviourConstructor.class);
		}
		catch (Exception e)
		{
			sErrorMessage = e.getMessage();
		}

		System.AssertEquals('onAfterDelete called', sErrorMessage, 'Error - After Delete Event is enabled but did not run');

		try
		{
			// now lets go after insert and then before
			fflib_SObjectDomain.getTriggerEvent(fflib_SObjectDomain.TestSObjectDisableBehaviourConstructor.class).enableBeforeDelete();
			fflib_SObjectDomain.Test.Database.onDelete(new Map<Id, Contact> { newContact.Id => newContact });
			fflib_SObjectDomain.triggerHandler(fflib_SObjectDomain.TestSObjectDisableBehaviourConstructor.class);
		}
		catch (Exception e)
		{
			sErrorMessage = e.getMessage();	
		}

		System.AssertEquals('onBeforeDelete called', sErrorMessage, 'Error - Before Delete Event is enabled but did not run');

		////////////////////////////
		// Undelete!
		try
		{
			// now lets go after insert and then before
			fflib_SObjectDomain.getTriggerEvent(fflib_SObjectDomain.TestSObjectDisableBehaviourConstructor.class).enableAfterUndelete();
			fflib_SObjectDomain.Test.Database.onUndelete(new Contact[] { newContact });
			fflib_SObjectDomain.triggerHandler(fflib_SObjectDomain.TestSObjectDisableBehaviourConstructor.class);
		}
		catch (Exception e)
		{
			sErrorMessage = e.getMessage();
		}

		System.AssertEquals('onAfterUndelete called', sErrorMessage, 'Error - After Undelete Event is enabled but did not run');

		/*

		fflib_SObjectDomain.Test.Database.onInsert(new Opportunity[] { opp } );



		fflib_SObjectDomain.Test.Database.onUpdate(new Opportunity[] { newOpp }, new Map<Id, SObject> { newOpp.Id => oldOpp } );

		fflib_SObjectDomain.Test.Database.onDelete(new Map<ID, Opportunity> { opp.Id => opp } );		

		fflib_SObjectDomain.Test.Database.onUndelete(new list<Opportunity> { opp } );		


		try {		
			fflib_SObjectDomain.triggerHandler(fflib_SObjectDomain.TestSObjectOnValidateBehaviourConstructor.class);
			System.assert(false, 'Expected exception');
		} catch (Exception e) {
			System.assertEquals('onValidate called', e.getMessage());
		}
		*/
	}
}