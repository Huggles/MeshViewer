/**
 * Created by jaapbranderhorst on 09/04/2020.
 */

import {LightningElement, track} from 'lwc';
import safeUsernamePassword from '@salesforce/apex/CompanyInfoLoginController.safeUsernamePassword';
import showToastEvent, {ShowToastEvent} from 'lightning/platformShowToastEvent';

import Config_Account_Password from '@salesforce/label/c.Config_Account_Password';
import Config_Account_Username from '@salesforce/label/c.Config_Account_Username';
import SubmitButtonLabel from '@salesforce/label/c.Config_Account_Save';
import Error from '@salesforce/label/c.Error';
import Success from '@salesforce/label/c.Success';
import Credentials_successfully_updated_message from '@salesforce/label/c.Credentials_successfully_updated_message';

export default class CompanyInfoLogin extends LightningElement {

    label = {
        Config_Account_Password,
        Config_Account_Username,
        SubmitButtonLabel
    }

    /**
     * Handles the click on the submit button by saving the username and password
     */
    handleSubmitButtonClick() {
        // first validate the input
        let valid = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
            }, true);
        if (valid) {
            // then submit
            safeUsernamePassword({"username": this.template.querySelector(".username").value, "password": this.template.querySelector(".password").value})
                .then(result => {
                    const event = new ShowToastEvent({
                        title: Success,
                        message: Credentials_successfully_updated_message,
                        variant: 'success'
                    });
                    this.dispatchEvent(event);
                })
                .catch(error => {
                    const event = new ShowToastEvent({
                        title: Error,
                        message: error.body.message,
                        variant: 'error',
                        mode: 'sticky'
                    });
                    this.dispatchEvent(event);
                });
        }

    }
}