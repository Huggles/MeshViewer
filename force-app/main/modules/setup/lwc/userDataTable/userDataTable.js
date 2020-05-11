/**
 * Created by jaapbranderhorst on 11/05/2020.
 */

import {LightningElement, api} from 'lwc';

/**
 * the column definition of the assigned user table
 */
// TODO: use custom labels
const columns = [
    {label: 'Full Name', fieldName: 'Name', type: 'text', sortable: true},
    {label: 'Alias', fieldName: 'Alias', type: 'text', sortable: true},
    {label: 'User name', fieldName: 'Username', type: 'text', sortable: true},
    {label: 'Profile', fieldName: 'Profile.Name', type: 'text', sortable:  true},
    {label: 'Role', fieldName: 'UserRole.Name', type: 'text', sortable: true},
    {label: 'Active', fieldName: 'Active', type: 'boolean', sortable: true}
];

export default class UserDataTable extends LightningElement {
    /**
     * The loaded users
     */
    @api
    users;

    /**
     * The selected rows in the table
     */
    selectedRows;

    /**
     * The column  of the data table with users
     */
    columns = columns;

    /**
     * Enable infinite loading on the table
     */
    @api
    enableInfiniteLoading;

    /**
     * Switch to turn the loading spinner on and off
     */
    @api
    isLoading = false;

    /**
     * Column FieldName on which to sort the table
     */
    @api
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
    @api
    defaultSortDirection = 'asc';

    /**
     * Returns the selected rows
     * @returns {*}
     */
    @api
    getSelectedRows() {
        return this.selectedRows;
    }

    handleLoadMore(event) {
        this.dispatchEvent(new CustomEvent('loadmore'));
    }

    handleSort(event) {
        this.dispatchEvent(new CustomEvent('sort'));
    }

    handleRowSelection(event) {
        this.dispatchEvent(new CustomEvent('rowselection'));
    }
}