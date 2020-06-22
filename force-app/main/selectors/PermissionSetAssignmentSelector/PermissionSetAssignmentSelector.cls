/**
 * Created by jaapbranderhorst on 06/05/2020.
 */

public inherited sharing class PermissionSetAssignmentSelector extends fflib_SObjectSelector implements IPermissionSetAssignmentSelector {



    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                PermissionSetAssignment.AssigneeId,
                PermissionSetAssignment.PermissionSetId,
                PermissionSetAssignment.Id
        };
    }

    public SObjectType getSObjectType() {
        return PermissionSetAssignment.SObjectType;
    }

    // need to override this because the PermissionSetAssignment 'SObject' doesn't have a createddate or name
    public override String getOrderBy() {
        return null;
    }

    public static IPermissionSetAssignmentSelector newInstance() {
        SObjectType op = PermissionSetAssignment.SObjectType;
        return (IPermissionSetAssignmentSelector)Application.Selector.newInstance(PermissionSetAssignment.SObjectType);
    }

    public PermissionSetAssignment[] selectByLicenseType(LicenseType licenseType, Integer offSet, Integer nrOfRows, List<fflib_QueryFactory.Ordering> orderings) {
        fflib_QueryFactory queryFactory = newQueryFactory(false, false, true);
        List<PermissionSetAssignment> result = new List<PermissionSetAssignment>();
        PermissionSet permissionSet = PermissionSetSelector.newInstance().selectByLicenseType(licenseType);
        if (permissionSet != null) { // can be null if the licenseType is a test licensetype
            Id permissionSetId = permissionSet.Id;
            queryFactory.setCondition('PermissionSetId = :permissionSetId');
            for (fflib_QueryFactory.Ordering ordering : orderings) {
                queryFactory.addOrdering(ordering);
            }
            queryFactory.setOffset(offSet);
            queryFactory.setLimit(nrOfRows);
            result = Database.query(queryFactory.toSOQL());
        }
        return result;
    }

    public PermissionSetAssignment[] selectByLicenseTypeAndUsers(LicenseType licenseType, List<User> users) {
        fflib_QueryFactory queryFactory = newQueryFactory(false, false, true);
        List<PermissionSetAssignment> result = new List<PermissionSetAssignment>();
        PermissionSet permissionSet = PermissionSetSelector.newInstance().selectByLicenseType(licenseType);
        if (permissionSet != null) { // can be null if the licenseType is a test licensetype
            Id permissionSetId = permissionSet.Id;
            Set<Id> userIds = (new Map<Id, User>(users)).keySet();
            queryFactory.setCondition('PermissionSetId = :permissionSetId AND AssigneeId IN :userIds');
            result = Database.query(queryFactory.toSOQL());
        }
        return result;
    }

    public PermissionSetAssignment[] selectLicenseTypePermissionSetAssignmentsExcludingLicenseType(LicenseType licenseType, Integer offSet, Integer nrOfRows, List<fflib_QueryFactory.Ordering> orderings) {
        List<PermissionSetAssignment> result = new List<PermissionSetAssignment>();
        PermissionSet permissionSet = PermissionSetSelector.newInstance().selectByLicenseType(licenseType);
        if (permissionSet != null) { // can be null if the licenseType is a test licensetype
            Id permissionSetId = permissionSet.Id;
            fflib_QueryFactory queryFactory = newQueryFactory(false, false, true);
            queryFactory.setCondition('PermissionSetId != permissionSetId');
            queryFactory.selectField('PermissionSet.Name');
            queryFactory.selectField('Assignee.Profile.Name');
            for (fflib_QueryFactory.Ordering ordering : orderings) {
                queryFactory.addOrdering(ordering);
            }
            queryFactory.setOffset(offSet);
            queryFactory.setLimit(nrOfRows);
            result = Database.query(queryFactory.toSOQL());
        }
        return result;
    }

    public PermissionSetAssignment[] selectByLicenseType(LicenseType licenseType) {
        fflib_QueryFactory queryFactory = newQueryFactory(false, false, true);
        List<PermissionSetAssignment> result = new List<PermissionSetAssignment>();
        PermissionSet permissionSet = PermissionSetSelector.newInstance().selectByLicenseType(licenseType);
        if (permissionSet != null) { // can be null if the licenseType is a test licensetype
            Id permissionSetId = permissionSet.Id;
            queryFactory.setCondition('PermissionSetId = :permissionSetId');
            result = Database.query(queryFactory.toSOQL());
        }
        return result;
    }


}