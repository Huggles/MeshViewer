/**
 * Created by jaapbranderhorst on 09/04/2020.
 */

import {LightningElement, track, wire} from 'lwc';
import saveUsernamePassword from '@salesforce/apex/CompanyInfoLoginController.saveUsernamePassword';
import getCredentials from '@salesforce/apex/CompanyInfoLoginController.getCredentials';
import showToastEvent, {ShowToastEvent} from 'lightning/platformShowToastEvent';

import Password from '@salesforce/label/c.Password';
import Companyinfo_Username from '@salesforce/label/c.Companyinfo_Username';
import SubmitButtonLabel from '@salesforce/label/c.Login_Button';
import Error from '@salesforce/label/c.Error';
import Success from '@salesforce/label/c.Success';
import Login_successfull from '@salesforce/label/c.Login_successfull';
import Loading from '@salesforce/label/c.Loading';

export default class CompanyInfoLogin extends LightningElement {

    label = {
        Password,
        Companyinfo_Username,
        SubmitButtonLabel,
        Loading
    }

    @track loaded = false;

    /**
     * The password
     */
    password;

    /**
     * The username
     */
    username;

    @wire(getCredentials)
    wiredGetCredentials(result){
        if(result.error){
            this.error = result.error;

        }else{
            if (result && result.data) {
                if (result.data.appsolutely__Username__c) {
                    this.username = result.data.appsolutely__Username__c;
                }
                if (result.data.appsolutely__Password__c) {
                    this.password = result.data.appsolutely__Password__c;
                }
            }
            this.error = undefined;
        }
        this.loaded = true;
    }

    /**
     * Handles the click on the submit button by saving the username and password
     */
    handleSubmitButtonClick() {
        this.loaded = false;
        saveUsernamePassword({"username": this.username, "password": this.password})
            .then(result => {
                const event = new ShowToastEvent({
                    title: Success,
                    message: Login_successfull,
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

    handleOnChange(event) {
        this[event.target.name] = event.target.value;
    }
}