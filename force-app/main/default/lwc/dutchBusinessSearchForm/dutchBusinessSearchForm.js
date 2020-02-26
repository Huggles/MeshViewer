/**
 * Created by jaapbranderhorst on 09/02/2020.
 */

import {api, LightningElement, track} from 'lwc';
import {fireEvent, registerListener} from "c/pubsub";
import {FlowAttributeChangeEvent} from 'lightning/flowSupport';
import {createErrorMessageMarkup} from 'c/companyInfoUtils';

import Search_Criterium_TradeName_Address_Description from '@salesforce/label/c.Search_Criterium_TradeName_Address_Description';
import Validation_Error_Message_Toast_Title from '@salesforce/label/c.Validation_Error_Message_Toast_Title';
import CreditSafe_Validation_Message_Heading from '@salesforce/label/c.CreditSafe_Validation_Message_Heading';


export default class DutchBusinessSearchForm extends LightningElement {
    @api
    tradeName;
    @api
    street;
    @api
    houseNumber;
    @api
    houseNumberAddition;
    @api
    city;
    @api
    postalCode;
    @api
    domainName;
    @api
    phoneNumber;

    @track
    hints;

    label = {
        CreditSafe_Validation_Message_Heading,
        Validation_Error_Message_Toast_Title
    }

    // connectedCallback() {
    //     registerListener('validationRequest', this.handleValidationRequest, this);
    //     registerListener('componentRegistrationOpen', this.handleComponentRegistrationOpen, this);
    // }

    // handleComponentRegistrationOpen(registrar) {
    //     // fire a registration event
    //     fireEvent(this.pageRef, 'componentRegistration', {component: this});
    // }

    // handleValidationRequest() {
    //     fireEvent(this.pageRef, 'componentValidationDone', {component: this, isValid: this.allValid()});
    // }

    /**
     * Checks if the input in all input elements in this template is valid
     * @returns true if valid
     */
    @api
    allValid() {
        this.hints = null; // remove the toast
        let valid = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
            }, true);
        if (!(this.tradeName || this.city || this.street || this.postalCode || this.domainName || this.phoneNumber)) {
            this.hints = [Search_Criterium_TradeName_Address_Description];
        }
        valid = valid && !this.hints;
        return valid;
    }

    handleOnChange(event) {
        this.hints = null; // remove the toast
        const attributeChangeEvent = new FlowAttributeChangeEvent(event.target.name, event.target.value);
        this.dispatchEvent(attributeChangeEvent);
    }

}