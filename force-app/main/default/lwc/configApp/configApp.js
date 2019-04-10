import { LightningElement, track, wire } from 'lwc';
import getUserList from '@salesforce/apex/ConfigAppController.getUserList';
import assignUsers from '@salesforce/apex/ConfigAppController.assignUsers';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
const columns = [
    {label: 'Full Name', fieldName: 'Name', type: 'string', sortable: 'true', sortedBy: 'Name'},
    {label: 'Active', fieldName: 'isActive', type: 'boolean'},
    {label: 'Dutch Business Active', fieldName: 'DutchBusinessActive', type: 'boolean'},
    {label: 'Email', fieldName: 'Email', type: 'email'}

];
const selectedUserIds = [];
/** The delay used when debouncing event handlers before invoking Apex. */
const DELAY = 300;
export default class configApp extends LightningElement {

    @track greeting = 'World';
    @track columns = columns;
    @track ready = false;
    @track users;
    @track error;
    @track searchKey = '';

    wiredUsersResult;

    @wire(getUserList, { searchKey: '$searchKey' })
    wiredUsers(result) {
        this.wiredUsersResult = result;
        if (result.data) {
            this.users = result.data;
            this.ready = true;
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.users = undefined;
        }
    }
    handleKeyChange(event) {
        // Debouncing this method: Do not update the reactive property as long as this function is
        // being called within a delay of DELAY. This is to avoid a very large number of Apex method calls.
        window.clearTimeout(this.delayTimeout);
        const searchKey = event.target.value;
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        this.delayTimeout = setTimeout(() => {
            this.searchKey = searchKey;
        }, DELAY);
    }
    getSelectedName(event){
        this.selectedUserIds = event.target.selectedRows;
    }
    addRemoveUsers(event){
        const evt = new ShowToastEvent({
            title: 'Success',
            message: 'Users were added to the application',
            variant: 'success'
        });
        this.dispatchEvent(evt);
        //return refreshApex(this.users);
        console.log('---ButtonClick---');
        console.log(this.selectedUserIds);
        assignUsers({UserIdList:this.selectedUserIds})
        .then(result => {
           // .then(() => {
            console.log('SUCCESS123');

            return refreshApex(this.wiredUsersResult);
        })
        .catch(error => {
            this.error = error;
        });
    }
    changeHandler(event) {
        this.greeting = event.target.value;
        
    }
      // The method onsort event handler
    updateColumnSorting(event) { // to ask Dan
        var fieldName = event.detail.fieldName;
        var sortDirection = event.detail.sortDirection;
        // assign the latest attribute with the sorted column fieldName and sorted direction
        this.sortedBy = fieldName;
        this.sortedDirection = sortDirection;
        console.log('nazhal');
        //this.data = this.sortData(fieldName, sortDirection);
   }


}