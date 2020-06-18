/**
 * Created by jaapbranderhorst on 05/05/2020.
 */

import {track, api, wire, LightningElement} from 'lwc';
import getLicenseTypeInfo from '@salesforce/apex/LicenseTypeManagementCardController.getLicenseTypeInfo';
import getAssignedUsers from '@salesforce/apex/LicenseTypeManagementCardController.getAssignedUsers';
import unAssignUsers from '@salesforce/apex/LicenseTypeManagementCardController.unAssignUsers';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {format} from 'c/labelFormatUtils';


import Loading from '@salesforce/label/c.Loading';
import Remove_Assignments_Button from '@salesforce/label/c.Remove_Assignments_Button';
import Assign_Licenses from '@salesforce/label/c.Assign_Licenses';
import Nr_of_licenses_assigned from '@salesforce/label/c.Nr_of_licenses_assigned';
import No_users_assigned from '@salesforce/label/c.No_users_assigned';
import License_assignment_succesfully_removed from '@salesforce/label/c.License_assignment_succesfully_removed';



const numberOfRowsToLoad = 20;

export default class LicenseTypeManagementCard extends LightningElement {

    label = {
        Loading,
        Remove_Assignments_Button,
        Assign_Licenses,
        Nr_of_licenses_assigned,
        No_users_assigned,
        License_assignment_succesfully_removed
    }

    /**
     * Contains the API name of the license type as defined in the LicenseType enum in Apex
     */
    @api
    licenseTypeApiName;

    /**
     * Contains the name of the License Type (Company.info for Business for example).
     */
    title;

    /**
     * The total number of available seats for this license type
     */
    totalNrOfSeats;

    /**
     * The available number of seats for this license type
     */
    availableNrOfSeats;

    /**
     * The number of seats that has been assigned
     */
    assignedNorOfSeats;

    /**
     * Error message to show
     */
    error;

    /**
     * Fetches the information of the license type
     * @param error
     * @param data
     */
    fetchLicenseTypeInfo() {
        return new Promise((resolve, reject) =>
            getLicenseTypeInfo({ licenseTypeAPIName: this.licenseTypeApiName })
                .then(result => {
                    this.title = result.name;
                    this.totalNrOfSeats = result.totalNrOfSeats;
                    this.availableNrOfSeats = result.availableNrOfSeats;
                    this.assignedNorOfSeats = this.totalNrOfSeats - this.availableNrOfSeats;
                    this.showAssignLicensesButton = this.availableNrOfSeats > 0;
                  //  this.licensesAssignedLabel = format(this.label.Nr_of_licenses_assigned, [this.assignedNorOfSeats, this.totalNrOfSeats]);
                    resolve('license type info fetched');
                })
                .catch(error => {
                    this.error = error;
                    reject(error);
                })
        );
    }

    /**
     * Shows how many licenses have been assigned
     * @returns {*}
     */
    get licensesAssignedLabel() {
        return format(this.label.Nr_of_licenses_assigned, [this.assignedNorOfSeats, this.totalNrOfSeats]);
    }

    /**
     * Returns true if there are licenses available. Used to determine if the assign button should be shown.
     * @returns {boolean}
     */
    licensesAvailable() {
        return this.availableNrOfSeats > 0;
    }


    /**
     * The users assigned to the license type
     */
    sObjectUsers;

    /**
     * The selected rows in the table
     */
    selectedRows = [];

    /**
     * Enable infinite loading on the table
     */
    enableInfiniteLoading = true;

    // /**
    //  * True if the table is loading. A spinner is shown in the table if true
    //  */
    // isLoading = false;

    /**
     * True if no rows selected in the table. If false the remove assignment button is enabled
     * @type {boolean}
     */
    isNoRowSelected = true;


    /**
     * Column FieldName on which to sort the table
     */
    sortedBy = 'Name';

    /**
     * Direction to sort the table on. Valid values are 'asc' and 'desc'
     * @type {string}
     */
    sortDirection = 'asc';

    /**
     * The default sort direction
     * @type {string}
     */
    defaultSortDirection = 'asc';

    /**
     * The default field on which to sort the results
     */
    defaultSortedBy = 'Name';

    /**
     * Fetches a new set of users. Appends them to the assignedUsers.
     */
    fetchAssignedUsers(offset, limit, sortedBy, sortDirection) {
        return new Promise((resolve, reject) => {
            getAssignedUsers({
                licenseTypeAPIName: this.licenseTypeApiName,
                startRow: offset,
                nrOfRows: limit,
                orderings: [{fieldName: sortedBy, sortOrder: sortDirection}]
            })
                .then(result => {
                    if (result && result.length > 0) {
                        if (this.sObjectUsers) {
                            const currentSObjectUsers = this.sObjectUsers;
                            const newSObjectUsers = currentSObjectUsers.concat(result);
                            this.sObjectUsers = newSObjectUsers;
                        } else {
                            this.sObjectUsers = result;
                        }
                    }
                    if (this.sObjectUsers && this.sObjectUsers.length >= this.assignedNorOfSeats) {
                        this.enableInfiniteLoading = false;
                    }
                    resolve('assigned users loaded');
                })
                .catch(error => {
                    this.error = error;
                    reject(this.error);
                })
        });
    }

    /**
     * True if the component is loading
     */
    isInitializing = true;

    connectedCallback() {
        this.isInitializing = true;
        this.fetchLicenseTypeInfo()
            .then(result => {
                this.showAssignLicensesButton = this.availableNrOfSeats > 0; // TODO: should take into account how many users there are in the org
                this.fetchAssignedUsers(0, numberOfRowsToLoad, this.defaultSortedBy, this.defaultSortDirection)
                    .then(this.isInitializing = false)
                    .catch((error) => {
                        this.error = error;
                        this.isInitializing = false;
                    })
            })
    }

    handleLoadMore(event) {
        let table = event.target;
        table.isLoading = true;
        this.fetchAssignedUsers(event.detail.offset, event.detail.limit, this.sortedBy, this.sortDirection)
            .then(result => {table.isLoading = false});
    }

    handleSort(event) {
        let table = event.target;
        this.sortedBy = table.sortedBy;
        this.sortDirection = table.sortDirection;
        if (event.detail.reload) {
            table.isLoading = true;
            this.fetchAssignedUsers(0, event.detail.limit, this.sortedBy, this.sortDirection)
                .then(result => {table.isLoading = false});
        }

    }

    handleRowSelection(event) {
        this.selectedRows = event.target.selectedRows;
        if (this.selectedRows && this.selectedRows.length > 0) {
            this.isNoRowSelected = false;
        } else {
            this.isNoRowSelected = true;
        }
    }

    handleRemoveAssignmentClicked(event) {
        if (this.selectedRows && this.selectedRows.length > 0) {
            const selectedIds = this.selectedRows.map(a => a.Id);
            unAssignUsers({licenseTypeAPIName: this.licenseTypeApiName, usersToUnAssign: selectedIds})
                .then(result => {
                    const event = new ShowToastEvent({
                        title: 'Success',
                        message: this.label.License_assignment_succesfully_removed,
                        variant: 'success'
                    });
                    this.dispatchEvent(event);
                    const filteredsObjectUsers = this.sObjectUsers.filter(sObjectUser => !selectedIds.includes(sObjectUser.Id) );
                    if (filteredsObjectUsers && filteredsObjectUsers.length > 0) {
                        this.sObjectUsers = filteredsObjectUsers;
                        this.assignedNorOfSeats = this.sObjectUsers.length;
                    } else {
                        this.sObjectUsers = undefined;
                        this.assignedNorOfSeats = 0;
                    }
                    this.availableNrOfSeats = this.totalNrOfSeats - this.assignedNorOfSeats;
                    this.selectedRows = [];
                })
                .catch(error => {
                    this.error = error;
                    this.selectedRows = [];
                });
        }
    }




    /**
     * True if the assign licenses button has been clicked
     */
    showAssignLicensesModal;

    /**
     * If true show the assign licenses button
     */
    showAssignLicensesButton;

    /**
     * Handles the click on the assign licenses button
     * @param event
     */
    handleAssignLicensesClicked(event) {
        this.showAssignLicensesModal = true;
    }

    /**
     * Handles the assignment of users in the assign license type modal
     * @param event
     */
    handleUsersAssigned(event) {
        const assignedUsers = event.detail;
        if (this.sObjectUsers) {
            const oldSObjectUsers = this.sObjectUsers;
            const newAndOldsObjectUsers = oldSObjectUsers.concat(assignedUsers);
            this.sObjectUsers = newAndOldsObjectUsers;
        } else {
            this.sObjectUsers = assignedUsers;
        }
        this.assignedNorOfSeats = this.sObjectUsers.length;
        this.availableNrOfSeats = this.totalNrOfSeats - this.assignedNorOfSeats;
    }

    /**
     * Handles closing the assign licenses modal
     * @param event
     */
    handleCloseAssignLicensesModal(event) {
        this.showAssignLicensesModal = false;
        this.fetchLicenseTypeInfo();
    }

}