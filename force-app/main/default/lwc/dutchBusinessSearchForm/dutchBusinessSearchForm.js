/**
 * Created by jaapbranderhorst on 09/02/2020.
 */

import {api, LightningElement, track} from 'lwc';
import {fireEvent, registerListener} from "c/pubsub";
import {FlowAttributeChangeEvent} from 'lightning/flowSupport';
import {createErrorMessageMarkup} from 'c/companyInfoUtils';
import Search_Criterium_TradeName_Address_Description from '@salesforce/label/c.Search_Criterium_TradeName_Address_Description';
import Validation_Error_Message_Toast_Title from '@salesforce/label/c.Validation_Error_Message_Toast_Title';
import Valid_Dutch_phone_number from '@salesforce/label/c.Valid_Dutch_phone_number';
import Trade_Name from '@salesforce/label/c.Trade_Name';
import Domain_Name from '@salesforce/label/c.Domain_Name';
import Phone_Number from '@salesforce/label/c.Phone_Number';
import Street from '@salesforce/label/c.Street';
import House_Number from '@salesforce/label/c.House_Number';
import Valid_house_number from '@salesforce/label/c.Valid_house_number';
import Addition from '@salesforce/label/c.Addition';
import Postal_Code from '@salesforce/label/c.Postal_Code';
import Valid_Dutch_postal_code from '@salesforce/label/c.Valid_Dutch_postal_code';
import City from '@salesforce/label/c.City';


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
    errorMessage;
    @track
    errorTitle = Validation_Error_Message_Toast_Title;

    label = {
        Valid_Dutch_phone_number,
        Trade_Name,
        Domain_Name,
        Phone_Number,
        Street,
        House_Number,
        Valid_house_number,
        Addition,
        Postal_Code,
        Valid_Dutch_postal_code,
        City
    }

    connectedCallback() {
        registerListener('validationRequest', this.handleValidationRequest, this);
        registerListener('componentRegistrationOpen', this.handleComponentRegistrationOpen, this);
    }

    handleComponentRegistrationOpen(registrar) {
        // fire a registration event
        fireEvent(this.pageRef, 'componentRegistration', {component: this});
    }

    handleValidationRequest() {
        fireEvent(this.pageRef, 'componentValidationDone', {component: this, isValid: this.allValid()});
    }

    /**
     * Checks if the input in all input elements in this template is valid
     * @returns true if valid
     */
    @api
    allValid() {
        this.errorMessage = null;
        let valid = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
            }, true);
        if (!(this.tradeName || this.city || this.street || this.postalCode || this.domainName || this.phoneNumber)) {
            this.errorMessage = createErrorMessageMarkup([Search_Criterium_TradeName_Address_Description]);
        }
        valid = valid && this.errorMessage;
        return valid;
    }

    handleOnChange(event) {
        const attributeChangeEvent = new FlowAttributeChangeEvent(event.target.name, event.target.value);
        this.dispatchEvent(attributeChangeEvent);
    }

}