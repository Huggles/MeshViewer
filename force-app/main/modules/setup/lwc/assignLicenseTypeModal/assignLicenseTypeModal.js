/**
 * Created by jaapbranderhorst on 11/05/2020.
 */

import {LightningElement, wire, api} from 'lwc';
import getUnAssignedUsers from '@salesforce/apex/LicenseTypeManagementCardController.getUnAssignedUsers';
import getUnAssignedUserCount from '@salesforce/apex/LicenseTypeManagementCardController.getUnAssignedUserCount';
import getLicenseTypeInfo from '@salesforce/apex/LicenseTypeManagementCardController.getLicenseTypeInfo';
import assignUsers from '@salesforce/apex/LicenseTypeManagementCardController.assignUsers';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

import Success from '@salesforce/label/c.Success';
import Close from '@salesforce/label/c.Close';
import Assign_Licenses from '@salesforce/label/c.Assign_Licenses';
import Loading from '@salesforce/label/c.Loading';
import Assign from '@salesforce/label/c.Assign';
import Cancel from '@salesforce/label/c.Cancel';
import Error from '@salesforce/label/c.Error';
import Assign_users_success_message from '@salesforce/label/c.Assign_users_success_message'
import {format} from 'c/labelFormatUtils';

import No_users_available_to_assign_licenses_to from '@salesforce/label/c.No_users_available_to_assign_licenses_to';
import Not_Enough_Seats_Available from '@salesforce/label/c.Not_Enough_Seats_Available';

const numberOfRowsToLoad = 20;

export default class AssignLicenseTypeModal extends LightningElement {

    label = {
        Success,
        Close,
        Assign_Licenses,
        Loading,
        No_users_available_to_assign_licenses_to,
        Assign,
        Cancel,
        Assign_users_success_message,
        Error,
        Not_Enough_Seats_Available
    }

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
     * The information about the license type. Warning: this method is not cached so will result in a roundtrip to the server for every call
     */
    licenseTypeInfo;

    /**
     * True if the table is loading
     */
    isFetchingUsers;

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

    /**
     * True if the component is initializing and a spinner should be shown. False otherwise
     */
    isInitializing = true;

    connectedCallback() {
        this.isInitializing = true;
        this.fetchUnAssignedUsers(0, numberOfRowsToLoad, this.defaultSortedBy, this.defaultSortDirection).
            then(result =>
                {
                    this.isInitializing = false
                }).
            catch(error =>
                {
                    this.isInitializing = false;
                    this.error = error;
                });
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

    handleAssignButtonClicked(event) {
        let nrOfSelectedUsers = this.selectedRows.length;
        getLicenseTypeInfo({licenseTypeAPIName: this.licenseTypeApiName})
            .then(result => {
                this.licenseTypeInfo = result;
                if (nrOfSelectedUsers > this.licenseTypeInfo.availableNrOfSeats) {
                    let message = format(this.label.Not_Enough_Seats_Available, [nrOfSelectedUsers, this.licenseTypeInfo.availableNrOfSeats]);
                    const event = new ShowToastEvent({
                        title: this.label.Error,
                        message: message,
                        variant: 'error',
                        mode: 'sticky'
                    });
                    this.dispatchEvent(event);
                } else {
                    this.handleAssignUsers();
                }
            })
            .catch(error => {
                let message = error;
                if (error.message) {
                    message = error.message;
                }
                if (error.body && error.body.message) {
                    message = error.body.message;
                }
                const event = new ShowToastEvent({
                    title: this.label.Error,
                    message: message,
                    variant: 'error'
                });
                this.dispatchEvent(event);
            });
        
    }

    handleAssignUsers() {
        if (this.selectedRows && this.selectedRows.length > 0) {
            const selectedIds = this.selectedRows.map(a => a.Id);
            assignUsers({licenseTypeAPIName: this.licenseTypeApiName, usersToAssign: selectedIds})
                .then(result => {
                    const event = new ShowToastEvent({
                        title: this.label.Success,
                        message: this.label.Assign_users_success_message,
                        variant: 'success'
                    });
                    this.dispatchEvent(event);
                    const newlyAssignedUsers = this.sObjectUsers.filter(sObjectUser => selectedIds.includes(sObjectUser.Id));
                    this.dispatchEvent(new CustomEvent('usersassigned', {detail: newlyAssignedUsers}));
                    const notYetAssignedsObjectUsers = this.sObjectUsers.filter(sObjectUser => !selectedIds.includes(sObjectUser.Id) );
                    if (notYetAssignedsObjectUsers && notYetAssignedsObjectUsers.length > 0) {
                        this.sObjectUsers = notYetAssignedsObjectUsers;
                    } else { // if no sObjectUsers are there to be assigned, close the window
                        this.sObjectUsers = undefined;
                        this.handleDialogClose();
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
     * True when rows have been selected, false if not
     * @type {boolean}
     */
    isNoRowSelected = true;

    /**
     * Called when rows in the user data table have been selected
     * @param event
     */
    handleRowSelection(event) {
        this.selectedRows = event.target.selectedRows;
        if (this.selectedRows && this.selectedRows.length > 0) {
            this.isNoRowSelected = false;
        } else {
            this.isNoRowSelected = true;
        }
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
        return new Promise((resolve, reject) => {
            this.isFetchingUsers = true;
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
                    this.isFetchingUsers = false;
                    resolve('unassigned users sucessfully loaded');
                })
                .catch(error => {
                    this.error = error;
                    this.isFetchingUsers = false;
                    resolve(error);
                })
        });

    }

}