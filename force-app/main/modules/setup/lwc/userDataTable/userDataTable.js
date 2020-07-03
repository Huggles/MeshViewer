/**
 * Created by jaapbranderhorst on 11/05/2020.
 */

import {LightningElement, api, track} from 'lwc';

import Full_Name from '@salesforce/label/c.Full_Name';
import Alias from '@salesforce/label/c.Alias';
import Username from '@salesforce/label/c.Username';
import Profile from '@salesforce/label/c.Profile';
import Role from '@salesforce/label/c.Role';
import Active_user from '@salesforce/label/c.Active_user';

/**
 * the column definition of the assigned user table
 */
const columns = [
    {label: Full_Name, fieldName: 'Name', type: 'text', sortable: true},
    {label: Alias, fieldName: 'Alias', type: 'text', sortable: true},
    {label: Username, fieldName: 'Username', type: 'text', sortable: true},
    {label: Profile, fieldName: 'ProfileName', type: 'text', sortable:  true},
    {label: Role, fieldName: 'UserRoleName', type: 'text', sortable: true},
    {label: Active_user, fieldName: 'IsActive', type: 'boolean', sortable: true}
];

export default class UserDataTable extends LightningElement {

    /**
     * The users as SObjects
     */
    @api
    get users() {
        return this.localUsers;
    }
    set users(theSObjectUsers) {
        if (this.isChangedSObjectList(theSObjectUsers)) {
            this.localUsers = this.convertsObjectUsers(theSObjectUsers);
            this.sortLocalUsers(this.sortedBy, this.sortDirection);
        }
    }

    isChangedSObjectList(theSObjectUsers) {
        // localUsers not yet defined
        if (!this.localUsers && theSObjectUsers) {
            return true;
        }
        // length of the arrays
        if (this.localUsers.length != theSObjectUsers.length) {
            return true;
        }
        // ids
        let sObjectUsersByIds = new Map();
        for (const theSObjectUser of theSObjectUsers) {
            sObjectUsersByIds.set(theSObjectUser.Id, theSObjectUser);
        }
        for (const localUser of this.localUsers) {
            if (!sObjectUsersByIds.get(localUser.Id)) {
                return true;
            }
        }
        return false;
    }

    @track
    localUsers;

    /**
     * The maximum number of users
     */
    @api
    maxNumberOfUsers;

    /**
     * The number of rows to load from the db
     */
    @api
    limit = 20;

    /**
     * The selected rows in the table
     */
    @api
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
    @api
    sortDirection = 'asc';

    /**
     * The default sort direction
     * @type {string}
     */
    @api
    defaultSortDirection = 'asc';

    convertsObjectUsers(sObjectUsers) {
        let users = [];
        for (const sObjectUser of sObjectUsers) {
            const localUser = {ProfileName: this.determineProfileName(sObjectUser), UserRoleName: this.determineUserRoleName(sObjectUser)};
            const user = Object.assign(localUser, sObjectUser);
            users.push(user);
        }
        return users;
    }

    determineProfileName(sObjectUser) {
        let profileName = '';
        if (sObjectUser.Profile && sObjectUser.Profile.Name) {
            profileName = sObjectUser.Profile.Name;
        }
        return profileName;
    }

    determineUserRoleName(sObjectUser) {
        let userRoleName = '';
        if (sObjectUser.UserRole && sObjectUser.UserRole.Name) {
            userRoleName = sObjectUser.UserRole.Name;
        }
        return userRoleName;
    }

    handleLoadMore(event) {
        this.dispatchEvent(new CustomEvent('loadmore', {detail: {offset: this.localUsers ? this.localUsers.length : 0, limit: this.limit}}));
    }

    handleSort(event) {
        // switch in sort direction and number of rows loaded is less than total number of rows
        let reload = false;
        if (this.sortDirection != event.detail.sortDirection && this.localUsers && this.localUsers.length < this.maxNumberOfUsers) {
            this.localUsers = undefined;
            reload = true;
        } else {
            this.sortLocalUsers(event.detail.fieldName, event.detail.sortDirection);
        }
        this.sortedBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.dispatchEvent(new CustomEvent('sort', {detail : {reload: reload, limit: this.limit}}));
    }

    sortLocalUsers(sortedBy, sortDirection) {
        if (this.localUsers) {
            let currentLocalUsers = [...this.localUsers];
            if (sortDirection === 'asc') {
                currentLocalUsers.sort((a, b) => (a[sortedBy] > b[sortedBy]) ? 1 : ((a[sortedBy] < b[sortedBy]) ? -1 : 0));
            } else {
                currentLocalUsers.sort((a, b) => (a[sortedBy] > b[sortedBy]) ? -1 : ((a[sortedBy] < b[sortedBy]) ? 1 : 0));
            }
            this.localUsers = currentLocalUsers;
        }
    }

    handleRowSelection(event) {
        this.selectedRows = event.target.getSelectedRows();
        this.dispatchEvent(new CustomEvent('rowselection'));
    }
}