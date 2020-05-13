/**
 * Created by jaapbranderhorst on 05/05/2020.
 */

import {track, api, wire, LightningElement} from 'lwc';
import getLicenseTypeInfo from '@salesforce/apex/LicenseTypeManagementCardController.getLicenseTypeInfo';
import getAssignedUsers from '@salesforce/apex/LicenseTypeManagementCardController.getAssignedUsers';

const numberOfRowsToLoad = 20;

export default class LicenseTypeManagementCard extends LightningElement {

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
                    resolve('license type info fetched');
                })
                .catch(error => {
                    this.error = error;
                    reject(error);
                })
        );
    }

    /**
     * The users assigned to the license type
     */
    sObjectUsers;

    /**
     * The selected rows in the table
     */
    selectedRows;

    /**
     * The label to be shown if there are no users assigned
     */
        // TODO: use a custom label
    noAssignedUsers = 'No Users Assigned';

    /**
     * Enable infinite loading on the table
     */
    enableInfiniteLoading = true;

    /**
     * True if the table is loadin
     */
    isLoading = false;

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
     * Fetches a new set of users. Appends them to the assignedUsers.
     */
    fetchAssignedUsers(offset, limit, sortedBy, sortDirection) {
        this.isLoading = true;
        if (this.maxUsers <= (offset + limit)) {
            this.enableInfiniteLoading = false;
        }
        getAssignedUsers({licenseTypeAPIName: this.licenseTypeApiName, startRow: offset, nrOfRows: limit, orderings: [{fieldName: sortedBy, sortOrder: sortDirection}]})
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
                this.isLoading = false;
            })
            .catch(error => {
                this.error = error;
                this.isLoading = false;
            })
    }

    connectedCallback() {
        this.fetchLicenseTypeInfo()
            .then(result => {
                this.fetchAssignedUsers(0, numberOfRowsToLoad, this.defaultSortedBy, this.defaultSortDirection);
            })
    }

    handleLoadMore(event) {
        this.fetchAssignedUsers();
    }

    handleSort(event) {
        this.fetchAssignedUsers(0, numberOfRowsToLoad, event.target.sortedBy, event.target.sortDirection);
    }

    handleRowSelection(event) {
        this.selectedRows = this.template.querySelector('c-user-data-table').getSelectedRows();
    }

    handleRemoveAssignmentClicked(event) {
        // TODO
    }

    /**
     * True if the assign licenses button has been clicked
     */
    showAssignLicensesModal;

    /**
     * Handles the click on the assign licenses button
     * @param event
     */
    handleAssignLicensesClicked(event) {
        this.showAssignLicensesModal = true;
    }

    /**
     * Handles closing the assign licenses modal
     * @param event
     */
    handleCloseAssignLicensesModal(event) {
        this.showAssignLicensesModal = false;
    }

}