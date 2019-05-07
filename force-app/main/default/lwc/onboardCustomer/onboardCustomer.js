import { LightningElement, track, wire } from 'lwc';
import getUserOnboarded from '@salesforce/apex/ConfigAppController.getUserOnboarded';
import enableTrial from '@salesforce/apex/ConfigAppController.enableTrial';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';



export default class onboardCustomer extends LightningElement {

@track onboarded = false;
@track error;
@track openmodal = false;

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
openmodalWindow() {
    console.log('openmodal pressed');
    this.openmodal = true
    console.log(this.openmodal);
}
closeModal() {
    this.openmodal = false
} 
saveMethod() {
    alert('save method invoked');
    this.closeModal();
}

enableTrial(event){

    enableTrial().then(result => {
        console.log('SUCCESS123');
        const evt = new ShowToastEvent({
            title: 'Success',
            message: 'The org was activated',
            variant: 'success'
        });
        this.dispatchEvent(evt);
        const event = new CustomEvent('userOnboarded', {
            // detail contains only primitives
            //detail: this.product.fields.Id.value
        });
        // Fire the event from c-tile
        this.dispatchEvent(event);
        return refreshApex(this.isUserOnboarded);
    })
    .catch(error => {
        this.error = error;
        console.log(this.error);
        const evt = new ShowToastEvent({
            title: 'Error',
            message: 'There was an error during org activation.',
            variant: 'error'
        });
        this.dispatchEvent(evt);
    });
}
 
}