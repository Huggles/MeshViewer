import { LightningElement, track, wire } from 'lwc';
import getUserOnboarded from '@salesforce/apex/ConfigAppController.getUserOnboarded';
import enableTrial from '@salesforce/apex/ConfigAppController.enableTrial';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';



export default class onboardCustomer extends LightningElement {

@track onboarded = false;
@track error;

isUserOnboarded;

@wire(getUserOnboarded)
wiredUserOnboarded(result){
    this.isUserOnboarded = result;
    if(result.error){
        this.error = result.error;
        this.users = undefined;
    }else{
        this.onboarded = result.data;
        //this.ready = true;
        this.error = undefined;
    }
}

enableTrial(event){
    const evt = new ShowToastEvent({
        title: 'Success',
        message: 'Users were added to the application',
        variant: 'success'
    });
    this.dispatchEvent(evt);
    enableTrial()
    .then(result => {
       // .then(() => {
        console.log('SUCCESS123');

        return refreshApex(this.isUserOnboarded);
    })
    .catch(error => {
        this.error = error;
    });
}
 
}