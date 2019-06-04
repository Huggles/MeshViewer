import { LightningElement, track, wire } from 'lwc';
import getUserOnboarded from '@salesforce/apex/ConfigAppController.getUserOnboarded';
import enableTrial from '@salesforce/apex/ConfigAppController.enableTrial';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Config_Account_ActivateDescription from '@salesforce/label/c.Config_Account_ActivateDescription';
import Config_Account_ActivateDescriptionRequest from '@salesforce/label/c.Config_Account_ActivateDescriptionRequest';
import Config_Account_Username from '@salesforce/label/c.Config_Account_Username';
import Config_Account_Password from '@salesforce/label/c.Config_Account_Password';
import Config_Account_Save from '@salesforce/label/c.Config_Account_Save';
import Config_Title from '@salesforce/label/c.Config_Title';


export default class onboardCustomer extends LightningElement {

@track onboarded = false;
@track error;
@track openmodal = false;

username;
password;

label = {
    Config_Account_ActivateDescription,
    Config_Account_ActivateDescriptionRequest,
    Config_Account_Username,
    Config_Account_Password,
    Config_Account_Save,
    Config_Title
}

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