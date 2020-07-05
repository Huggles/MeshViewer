/**
 * Created by jaapbranderhorst on 09/04/2020.
 */

import {LightningElement, track, wire} from 'lwc';
import saveUsernamePassword from '@salesforce/apex/CompanyInfoLoginController.saveUsernamePassword';
import getCredentials from '@salesforce/apex/CompanyInfoLoginController.getCredentials';
import {handleResponse} from "c/auraResponseWrapperHandler";
import {ToastEventController} from "c/toastEventController";

import Password from '@salesforce/label/c.Password';
import Companyinfo_Username from '@salesforce/label/c.Companyinfo_Username';
import SubmitButtonLabel from '@salesforce/label/c.Login_Button';
import Error from '@salesforce/label/c.Error';
import Success from '@salesforce/label/c.Success';
import Login_successfull from '@salesforce/label/c.Login_successful';
import Loading from '@salesforce/label/c.Loading';

export default class CompanyInfoLogin extends LightningElement {

    label = {
        Password,
        Companyinfo_Username,
        SubmitButtonLabel,
        Loading
    }

    /**
     * Switch which is set to true to show a spinner when interacting with the server
     */
    loading;

    /**
     * The password
     */
    password;

    /**
     * The username
     */
    username;

    /**
     * Load the credentials
     */
    connectedCallback() {
        this.loading = true;
        getCredentials()
            .then(result => {
                return handleResponse(result);
            })
            .then(result => {
                this.username = result.username;
                this.password = result.password;
            })
            .catch(error => {
                new ToastEventController(this).showErrorToastMessage(Error,error.message);
            })
            .finally(() => {
                this.loading = false;
            })
    }

    /**
     * Handles the click on the submit button by saving the username and password
     */
    handleSubmitButtonClick() {
        this.loading = true;
        saveUsernamePassword({"username": this.username, "password": this.password})
            .then(result => {
                new ToastEventController(this).showSuccessToastMessage(Success,Login_successfull);
            })
            .catch(error => {
                new ToastEventController(this).showErrorToastMessage(null,error.body.message);
            })
            .finally(() => {
                this.loading = false
            });

    }

    handleOnChange(event) {
        this[event.target.name] = event.target.value;
    }
}