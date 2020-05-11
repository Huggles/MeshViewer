/**
 * Created by jaapbranderhorst on 05/05/2020.
 */

import {track, api, wire, LightningElement} from 'lwc';
import getLicenseTypeInfo from '@salesforce/apex/LicenseTypeManagementCardController.getLicenseTypeInfo';
import getAssignedUsers from '@salesforce/apex/LicenseTypeManagementCardController.getAssignedUsers';

/**
 * the column definition of the assigned user table
 */
// TODO: use custom labels
const columns = [
    {label: 'First Name', fieldName: 'FirstName', type: 'text', sortable: true},
    {label: 'Last Name', fieldName: 'LastName', type: 'text', sortable: true},
    {label: 'Profile', fieldName: 'Profile.Name', type: 'text', sortable:  true},
    {label: 'Role', fieldName: 'UserRole.Name', type: 'text', sortable: true}
];

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
                    this.title = result.title;
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
    assignedUsers;

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
     * The column  of the data table with users
     */
    columns = columns;

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
    fetchAssignedUsers(sortedBy, sortDirection) {
        this.isLoading = true;
        let startRow;
        if (!this.assignedUsers || (sortedBy && this.sortedBy !== sortedBy) || (sortDirection && this.sortDirection !== sortDirection) ) {
            startRow = 0;
        } else {
            startRow = this.assignedUsers.length;
        }
        let endRow;
        if (this.assignedNorOfSeats >= startRow + numberOfRowsToLoad) {
            endRow = startRow + numberOfRowsToLoad;
        } else {
            endRow = this.assignedNorOfSeats - startRow;
            this.enableInfiniteLoading = false;
        }
        if (sortedBy) {
            this.sortedBy = sortedBy;
        }
        if (sortDirection) {
            this.sortDirection = sortDirection;
        }
        getAssignedUsers({licenseTypeAPIName: this.licenseTypeApiName, startRow: startRow, endRow: endRow, orderings: [{fieldName: this.sortedBy, sortOrder: this.sortDirection}]})
            .then(result => {
                if (result && result.length > 0) {
                    if (this.assignedUsers) {
                        const currentAssignedUsers = this.assignedUsers;
                        const newCurrentAssignedUsers = currentAssignedUsers.concat(result);
                        this.assignedUsers = newCurrentAssignedUsers;
                    } else {
                        this.assignedUsers = result;
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
                this.fetchAssignedUsers();
            })
    }

    handleLoadMore(event) {
        this.fetchAssignedUsers();
    }

    handleSort(event) {
        this.fetchAssignedUsers(event.target.sortedBy, event.target.sortDirection);
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