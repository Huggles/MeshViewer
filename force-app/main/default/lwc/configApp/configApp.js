import { LightningElement, track, wire } from 'lwc';
import getUserOnboarded from '@salesforce/apex/ConfigAppController.getUserOnboarded';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class configApp extends LightningElement {

    @track onboarded = false;
    @track ready = false;
    @track showOnboarded = false;

    isUserOnboarded;

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
    handleUserOnboarded(){
        this.onboarded = true;
    }



}