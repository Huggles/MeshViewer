import { LightningElement, track, wire } from 'lwc';
import getUserList from '@salesforce/apex/ConfigAppController.getUserList';
import assignUsers from '@salesforce/apex/ConfigAppController.assignUsers';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
const columns = [
    {label: 'Name', fieldName: 'Name', type: 'string', sortable: 'true'},
    {label: 'Active', fieldName: 'isActive', type: 'boolean'},
    {label: 'Dutch Business Active', fieldName: 'DutchBusinessActive', type: 'boolean'},
    {label: 'Profile Name', fieldName: 'ProfileName', type: 'string', sortable: 'true'}

];
const selectedUserIds = [];
/** The delay used when debouncing event handlers before invoking Apex. */
const DELAY = 300;
export default class LicenseControlList extends LightningElement {

    @track greeting = 'World';
    @track columns = columns;
    @track ready = false;
    @track users;
    @track error;
    @track searchKey = '';
    @track sortedBy = 'Name';
    @track sortedDirection = 'asc';

    @track searchParam = 'Name'; 

    wiredUsersResult;

    @wire(getUserList, { searchKey: '$searchKey', searchParam: '$searchParam', sortedBy: '$sortedBy',  sortedDirection: '$sortedDirection'})
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
      // The method onsort event handler
    updateColumnSorting(event) { // to ask Dan
        console.log('test');
        const fieldName = event.detail.fieldName;
        const sortDir = event.detail.sortDirection;

        console.log(event.detail.fieldName);
        console.log(event.detail.sortDirection);
        //console.log(event.target.sorted-direction);
        //console.log(event.sorted-direction);
        // assign the latest attribute with the sorted column fieldName and sorted direction
        this.sortedBy = fieldName;
        this.sortedDirection = sortDir; //sortDirection;
        console.log(this.sortedBy);
        console.log(this.sortedDirection);
        //this.data = this.sortData(fieldName, sortDirection);*/
   } //as

   handleUpdateSearchParam(event){
    console.log('testing');
        this.searchParam = event.detail;
   }

}