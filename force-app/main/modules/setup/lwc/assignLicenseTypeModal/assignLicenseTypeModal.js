/**
 * Created by jaapbranderhorst on 11/05/2020.
 */

import {LightningElement, wire, api} from 'lwc';
import getUnAssignedUsers from '@salesforce/apex/LicenseTypeManagementCardController.getUnAssignedUsers';
import getUnAssignedUserCount from '@salesforce/apex/LicenseTypeManagementCardController.getUnAssignedUserCount';
import assignUsers from '@salesforce/apex/LicenseTypeManagementCardController.assignUsers';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

const numberOfRowsToLoad = 20;

export default class AssignLicenseTypeModal extends LightningElement {

    /**
     * The API name of the License type
     */
    @api
    licenseTypeApiName = '';

    /**
     * The loaded users as SObjects
     */
    sObjectUsers;

    /**
     * The maximum number of users
     */
    @wire(getUnAssignedUserCount, {licenseTypeAPIName: '$licenseTypeApiName'})
    maxUsers;

    /**
     * True if the table is loading
     */
    isLoading;

    /**
     * The rows selected in the table
     */
    selectedRows;

    /**
     * The default sort direction
     */
    defaultSortDirection = 'asc';

    /**
     * True if more results can be loaded
     */
    enableInfiniteLoading;

    /**
     * Column FieldName on which to sort the table
     */
    defaultSortedBy = 'Name';


    /**
     * The current sort field of the data table
     */
    sortedBy = this.defaultSortedBy;

    /**
     * The current sort direction of the table
     * @type {string}
     */
    sortDirection = this.defaultSortDirection;

    connectedCallback() {
        this.fetchUnAssignedUsers(0, numberOfRowsToLoad, this.defaultSortedBy, this.defaultSortDirection);
    }

    /**
     * Called when the modal close button is clicked (cross on the upper right)
     */
    handleDialogClose() {
        this.dispatchEvent(new CustomEvent('close'));
    }

    /**
     * Called when the cancel button is clicked
     */
    handleCancelClicked() {
        this.dispatchEvent(new CustomEvent('close'));
    }

    handleAssignAndCloseButtonClicked() {
        this.handleAssignUsers();
        this.handleDialogClose();
    }

    handleAssignButtonClicked(event) {
        this.handleAssignUsers();
        // this.sObjectUsers = undefined;
        // this.fetchUnAssignedUsers(0, numberOfRowsToLoad, this.sortedBy, this.sortDirection);
    }

    handleAssignUsers() {
        if (this.selectedRows && this.selectedRows.length > 0) {
            const selectedIds = this.selectedRows.map(a => a.Id);
            assignUsers({licenseTypeAPIName: this.licenseTypeApiName, usersToAssign: selectedIds})
                .then(result => {
                    const event = new ShowToastEvent({
                        title: 'Success',
                        message: 'User assignment successful'
                    });
                    this.dispatchEvent(event);
                    const newlyAssignedUsers = this.sObjectUsers.filter(sObjectUser => selectedIds.includes(sObjectUser.Id));
                    this.dispatchEvent(new CustomEvent('usersassigned', {detail: newlyAssignedUsers}));
                    const notYetAssignedsObjectUsers = this.sObjectUsers.filter(sObjectUser => !selectedIds.includes(sObjectUser.Id) );
                    if (notYetAssignedsObjectUsers && notYetAssignedsObjectUsers.length > 0) {
                        this.sObjectUsers = notYetAssignedsObjectUsers;
                    } else { // if no sObjectUsers are there to be assigned, make this.sObjectUsers undefined so the data table is not shown
                        this.sObjectUsers = undefined;
                    }
                    this.selectedRows = [];
                })
                .catch(error => this.error = error);

        }
    }

    /**
     * Called when the user data table has been sorted
     * @param event
     */
    handleSort(event) {
        this.sortDirection = event.target.sortDirection;
        this.sortedBy = event.target.sortedBy;
        if (event.detail.reload) // if not all data is loaded, the sort field or the direction of the sort has been swapped reload the data
            this.fetchUnAssignedUsers(0, event.detail.limit, event.target.sortedBy, event.target.sortDirection);
    }

    /**
     * Called when rows in the user data table have been selected
     * @param event
     */
    handleRowSelection(event) {
        this.selectedRows = event.target.selectedRows;
    }



    /**
     * Called when the user data table needs to load more data
     * @param event
     */
    handleLoadMore(event) {
        this.fetchUnAssignedUsers(event.detail.offset, event.detail.limit, this.target.sortedBy, this.target.sortDirection);
    }

    /**
     * Fetches a new set of unassigned users. Appends them to the sObjectUsers or initializes the property.
     */
    fetchUnAssignedUsers(offset, limit, sortedBy, sortDirection) {
        // TODO: refactor so there is no code duplication with licenseTypeManagementCard
        this.isLoading = true;
        getUnAssignedUsers({licenseTypeAPIName: this.licenseTypeApiName, startRow: offset, nrOfRows: limit, orderings: [{fieldName: sortedBy, sortOrder: sortDirection}]})
            .then(result => {
                if (result && result.length > 0) {
                    if (this.sObjectUsers) {
                        const currentSObjectUsers = this.sObjectUsers;
                        const newSObjectUsers = currentSObjectUsers.concat(result);
                        this.sObjectUsers = newSObjectUsers;
                    } else {
                        this.sObjectUsers = result;
                    }
                    if (this.sObjectUsers && this.sObjectUsers.length >= this.maxUsers) {
                        this.enableInfiniteLoading = false;
                    }
                }
                this.isLoading = false;
            })
            .catch(error => {
                this.error = error;
                this.isLoading = false;
            })
    }

}