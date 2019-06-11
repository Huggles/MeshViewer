import { LightningElement, track, wire } from 'lwc';
import getUserOnboarded from '@salesforce/apex/ConfigAppController.getUserOnboarded';
import userCheckActive from '@salesforce/apex/ConfigAppController.userCheckActive';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Config_Account_AwaitingActivation from '@salesforce/label/c.Config_Account_AwaitingActivation';
import Config_Title from '@salesforce/label/c.Config_Title';
import Config_Page_Title from '@salesforce/label/c.Config_Page_Title';
import Config_Loading from '@salesforce/label/c.Config_Loading';

export default class configApp extends LightningElement {

    @track onboarded = false;
    @track ready = false;
    @track showOnboarded = false;

    isUserOnboarded;
    @track userActive;

    activeData;

    label = {
        Config_Account_AwaitingActivation,
        Config_Title,
        Config_Page_Title,
        Config_Loading
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
        this.activeData = result;
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
        refreshApex(this.activeData);
    }

    get canShowOnboarded() {
        return this.showOnboarded || this.userActive;
    }

    get awaitingActivation() {
        return !this.userActive && this.onboarded;
    }
}