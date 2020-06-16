/**
 * Created by jaapbranderhorst on 09/04/2020.
 */

import {LightningElement, track, wire} from 'lwc';
import saveUsernamePassword from '@salesforce/apex/CompanyInfoLoginController.saveUsernamePassword';
import getCredentials from '@salesforce/apex/CompanyInfoLoginController.getCredentials';
import showToastEvent, {ShowToastEvent} from 'lightning/platformShowToastEvent';

import Config_Account_Password from '@salesforce/label/c.Config_Account_Password';
import Config_Account_Username from '@salesforce/label/c.Config_Account_Username';
import SubmitButtonLabel from '@salesforce/label/c.Config_Account_Save';
import Error from '@salesforce/label/c.Error';
import Success from '@salesforce/label/c.Success';
import Credentials_successfully_updated_message from '@salesforce/label/c.Credentials_successfully_updated_message';
import Loading from '@salesforce/label/c.Loading';

export default class CompanyInfoLogin extends LightningElement {

    label = {
        Config_Account_Password,
        Config_Account_Username,
        SubmitButtonLabel,
        Loading
    }

    @track loaded = true;


    m_credentials;
    @wire(getCredentials)
    wiredGetCredentials(result){
        console.log('result');
        console.log(result);
        if(result.data != null){
            this.m_credentials = result.data;
            this.error = undefined;
            this.prefillFields();
        }
        else if(result.error != null){
            showToastEvent('Error', result.error.body.message, 'error');
        }
    }

    usernameElement;
    passwordElement;
    renderedCallback() {
        this.usernameElement = this.template.querySelector(".username");
        this.passwordElement = this.template.querySelector(".password");
        this.prefillFields();
    }

    prefillFields(){
        if(this.usernameElement != null && this.passwordElement != null && this.m_credentials != null){
            this.usernameElement.value = this.m_credentials.appsolutely__Username__c;
            this.passwordElement.value = this.m_credentials.appsolutely__Password__c;
        }
    }

    /**
     * Handles the click on the submit button by saving the username and password
     */
    handleSubmitButtonClick() {
        this.loaded = false;
        // first validate the input
        let valid = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
            }, true);
        if (valid) {
            // then submit
            saveUsernamePassword({"username": this.template.querySelector(".username").value, "password": this.template.querySelector(".password").value})
                .then(result => {
                    const event = new ShowToastEvent({
                        title: Success,
                        message: Credentials_successfully_updated_message,
                        variant: 'success'
                    });
                    this.dispatchEvent(event);
                    this.loaded = true;
                })
                .catch(error => {
                    const event = new ShowToastEvent({
                        title: Error,
                        message: error.body.message,
                        variant: 'error',
                        mode: 'sticky'
                    });
                    this.dispatchEvent(event);
                    this.loaded = true;
                });
        }

    }
}