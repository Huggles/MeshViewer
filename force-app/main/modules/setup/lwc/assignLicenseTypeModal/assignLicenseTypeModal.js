/**
 * Created by jaapbranderhorst on 11/05/2020.
 */

import {LightningElement, wire, api} from 'lwc';
import getUnAssignedUsers from '@salesforce/apex/LicenseTypeManagementCardController.getUnAssignedUsers';
import getUnAssignedUserCount from '@salesforce/apex/LicenseTypeManagementCardController.getUnAssignedUserCount';

const numberOfRowsToLoad = 20;

export default class AssignLicenseTypeModal extends LightningElement {

    /**
     * The API name of the License type
     */
    @api
    licenseTypeApiName = '';

    /**
     * The loaded users
     */
    users;

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
    defaultSortDirection;

    /**
     * True if more results can be loaded
     */
    enableInfiniteLoading;

    connectedCallback() {
        this.fetchUnAssignedUsers(this.sortedBy, this.sortDirection);
    }



    handleCancelClicked() {
        this.dispatchEvent(new CustomEvent('close'));
    }

    handleSort(event) {
        this.fetchUnAssignedUsers(event.target.sortedBy, event.target.sortDirection);
    }

    handleRowSelection(event) {
        this.selectedRows = template.querySelector('c-user-data-table').getSelectedRows();
    }

    handleLoadMore(event) {
        this.fetchUnAssignedUsers(this.sortedBy, this.sortDirection);
    }

    /**
     * Fetches a new set of users. Appends them to the assignedUsers.
     */
    fetchUnAssignedUsers(sortedBy, sortDirection) {
        // TODO: refactor so there is no code duplication with licenseTypeManagementCard
        this.isLoading = true;
        let startRow;
        if (!this.users || (sortedBy && this.sortedBy !== sortedBy) || (sortDirection && this.sortDirection !== sortDirection) ) {
            startRow = 0;
            this.users = undefined;
        } else {
            startRow = this.users.length;
        }
        if (sortedBy) {
            this.sortedBy = sortedBy;
        }
        if (sortDirection) {
            this.sortDirection = sortDirection;
        }
        getUnAssignedUsers({licenseTypeAPIName: this.licenseTypeApiName, startRow: startRow, nrOfRows: numberOfRowsToLoad, orderings: [{fieldName: this.sortedBy, sortOrder: this.sortDirection}]})
            .then(result => {
                if (result && result.length > 0) {
                    if (this.users) {
                        const currentUsers = this.users;
                        const newCurrentUsers = currentUsers.concat(result);
                        this.users = newCurrentUsers;
                        if (this.maxUsers <= (startRow + numberOfRowsToLoad)) {
                            this.enableInfiniteLoading = false;
                        }
                    } else {
                        this.users = result;
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