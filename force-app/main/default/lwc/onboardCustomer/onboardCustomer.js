import { LightningElement, track, wire } from 'lwc';
import getUserOnboarded from '@salesforce/apex/ConfigAppController.getUserOnboarded';
import enableTrial from '@salesforce/apex/ConfigAppController.enableTrial';
import saveDataUserCredentials from '@salesforce/apex/ConfigAppController.saveDataUserCredentials';
import getCredentials from '@salesforce/apex/ConfigAppController.getCredentials';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Config_Credentials from '@salesforce/label/c.Config_Credentials';
import Config_Account_ActivateDescription from '@salesforce/label/c.Config_Account_ActivateDescription';
import Config_Account_ActivateDescriptionRequest from '@salesforce/label/c.Config_Account_ActivateDescriptionRequest';
import Config_Account_ID from '@salesforce/label/c.Config_Account_ID';
import Config_Account_Username from '@salesforce/label/c.Config_Account_Username';
import Config_Account_Password from '@salesforce/label/c.Config_Account_Password';
import Config_Account_Save from '@salesforce/label/c.Config_Account_Save';
import Config_Account_CreateAccount from '@salesforce/label/c.Config_Account_CreateAccount';
import Config_Account_ExistingUser from '@salesforce/label/c.Config_Account_ExistingUser';
import Config_Title from '@salesforce/label/c.Config_Title';
import Success from '@salesforce/label/c.Success';
import Error from '@salesforce/label/c.Error';
import Error_Incomplete from '@salesforce/label/c.Error_Incomplete';
import Error_Config from '@salesforce/label/c.Error_Config';
import Dossier_Account_Update_Completed from '@salesforce/label/c.Dossier_Account_Update_Completed';

export default class onboardCustomer extends LightningElement {

@track onboarded = false;
@track error;
@track openmodal = false;


@track newUser = true;

    get existingUser() {
        return !this.newUser;
    }

@track accountId = '';
    username = '';
    password = '';

    label = {
        Config_Credentials,
        Config_Account_ActivateDescription,
        Config_Account_ActivateDescriptionRequest,
        Config_Account_ID,
        Config_Account_Username,
        Config_Account_Password,
        Config_Account_Save,
        Config_Title,
        Config_Account_ExistingUser,
        Config_Account_CreateAccount,
        Success,
        Error,
        Error_Incomplete,
        Error_Config,
        Dossier_Account_Update_Completed
    };

    isUserOnboarded;

@wire(getUserOnboarded)
    wiredUserOnboarded(result){
        this.isUserOnboarded = result;
        if(result.error){
            this.error = result.error;
        }else{
            this.onboarded = result.data;
            this.error = undefined;
        }
    }

@wire(getCredentials)
    wiredGetCredentials(result){
        if(result.error){
            this.error = result.error;
        }else{
            if (result && result.data) {
                this.accountId = result.data.appsolutely__CompanyConnectUserId__c;
                this.username = result.data.appsolutely__Username__c;
                this.password = result.data.appsolutely__Password__c;
                this.newUser = result.data.appsolutely__CompanyConnectUserId__c === undefined;
                this.error = undefined;
            }
        }
    }

    enableTrial(event){
        if (this.password === '') {
            const evt = new ShowToastEvent({
                title: this.label.Error,
                message: this.label.Error_Incomplete,
                variant: 'error'
            });
            this.dispatchEvent(evt);
            return;
        }
        enableTrial({password: this.password}).then(result => {
            const evt = new ShowToastEvent({
                title: this.label.Success,
                message:  this.label.Dossier_Account_Update_Completed,
                variant: 'success'
            });
        this.dispatchEvent(evt);
        const event = new CustomEvent('useronboarded', {
            // detail contains only primitives
            //detail: this.product.fields.Id.value
        });
        // Fire the event from c-tile
        this.dispatchEvent(event);
        return refreshApex(this.isUserOnboarded);
    })
    .catch(error => {
            this.error = error;
        const evt = new ShowToastEvent({
            title: this.label.Error,
            message: this.error.body.message,
            variant: 'error'
        });
        this.dispatchEvent(evt);
    })
    }

    saveDataUserCredentials() {
        if (this.username === '' || this.password === '') {
            const evt = new ShowToastEvent({
                title: this.label.Error,
                message: this.label.Error_Incomplete,
                variant: 'error'
            });
            this.dispatchEvent(evt);
            return;
        }
        saveDataUserCredentials({username:this.username, password: this.password}).then(result => {
                const evt = new ShowToastEvent({
                    title: this.label.Success,
                    message: this.label.Dossier_Account_Update_Completed,
                    variant: 'success'
                });
                this.error = undefined;
                // this.password = '';
                this.dispatchEvent(evt);
                const event = new CustomEvent('useronboarded', {
                    // detail contains only primitives
                    //detail: this.product.fields.Id.value
                });
                // Fire the event from c-tile
                this.dispatchEvent(event);
                return refreshApex(this.isUserOnboarded);
            })
            .catch(error => {
                this.error = error;
                const evt = new ShowToastEvent({
                    title: this.label.Error,
                    message: error.body.message,
                    variant: 'error'
                });
                this.dispatchEvent(evt);
            });
    }

    toggleNewUser(event) {
        this.newUser = !this.newUser;
    }

    changeAccountId(event) {
        this.accountId = event.target.value;
    }

    changeUsername(event) {
        this.username = event.target.value;
    }
    changePassword(event) {
        this.password = event.target.value;
    }

}