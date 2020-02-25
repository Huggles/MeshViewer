/**
 * Created by jaapbranderhorst on 09/02/2020.
 */

import {api, LightningElement} from 'lwc';
import {fireEvent, registerListener} from "c/pubsub";
import {FlowAttributeChangeEvent} from 'lightning/flowSupport';

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
        let valid = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
            }, true);
        valid = valid && (this.tradeName || this.city || this.street || this.postalCode || this.domainName || this.phoneNumber);
        return valid;
    }

    handleOnChange(event) {
        const attributeChangeEvent = new FlowAttributeChangeEvent(event.target.name, event.target.value);
        this.dispatchEvent(attributeChangeEvent);
    }

}