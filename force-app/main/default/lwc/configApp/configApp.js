import { LightningElement, track, wire } from 'lwc';
import getUserOnboarded from '@salesforce/apex/ConfigAppController.getUserOnboarded';
import userCheckActive from '@salesforce/apex/ConfigAppController.userCheckActive';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Config_Account_AwaitingActivation from '@salesforce/label/c.Config_Account_AwaitingActivation';
import Config_Title from '@salesforce/label/c.Config_Title';

export default class configApp extends LightningElement {

    @track onboarded = false;
    @track ready = false;
    @track showOnboarded = false;

    isUserOnboarded;
    @track userActive;

    label = {
        Config_Account_AwaitingActivation,
        Config_Title
    }

    @wire(getUserOnboarded)
    wiredUserOnboarded(result){
        this.isUserOnboarded = result;
        if(result.error){
            this.error = result.error;
            this.users = undefined;
        }else{
            
            this.onboarded = result.data;
            this.ready = true;
            this.error = undefined;
            if(this.onboarded === false){
                this.showOnboarded = true; // to hide onboarding button during load
            }
        }
    }

    @wire(userCheckActive)
    wiredActive(result) {
        if (result.data !== undefined) {
            this.userActive = result.data;
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.users = undefined;
        }
    }

    handleUserOnboarded(){
        this.onboarded = true;
    }

    get awaitingActivation() {
        return !this.userActive && this.onboarded;
    }
}