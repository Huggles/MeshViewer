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

    connectedCallback() {
        this.fetchUnAssignedUsers(0, numberOfRowsToLoad, this.defaultSortedBy, this.defaultSortDirection);
    }

    handleCancelClicked() {
        this.dispatchEvent(new CustomEvent('close'));
    }

    handleSort(event) {
        if (event.detail.reload)
            this.fetchUnAssignedUsers(0, numberOfRowsToLoad, event.target.sortedBy, event.target.sortDirection);
    }

    handleRowSelection(event) {
        this.selectedRows = template.querySelector('c-user-data-table').getSelectedRows();
    }

    handleLoadMore(event) {
        this.fetchUnAssignedUsers(event.detail.offset, event.detail.limit, this.target.sortedBy, this.target.sortDirection);
    }

    /**
     * Fetches a new set of users. Appends them to the assignedUsers.
     */
    fetchUnAssignedUsers(offset, limit, sortedBy, sortDirection) {
        // TODO: refactor so there is no code duplication with licenseTypeManagementCard
        this.isLoading = true;
        if (this.maxUsers <= (offset + limit)) {
            this.enableInfiniteLoading = false;
        }
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
                }
                this.isLoading = false;
            })
            .catch(error => {
                this.error = error;
                this.isLoading = false;
            })
    }

}