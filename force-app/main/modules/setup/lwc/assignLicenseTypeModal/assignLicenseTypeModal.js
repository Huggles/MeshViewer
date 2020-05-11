/**
 * Created by jaapbranderhorst on 11/05/2020.
 */

import {LightningElement} from 'lwc';

export default class AssignLicenseTypeModal extends LightningElement {

    /**
     * The loaded users
     */
    users;

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



    handleCancelClicked() {
        this.dispatchEvent(new CustomEvent('close'));
    }

    handleSort(event) {
        // TODO
    }

    handleRowSelection(event) {
        this.selectedRows = template.querySelector('c-user-data-table').getSelectedRows();
    }

    handleLoadMore(event) {
        // TODO
    }


}