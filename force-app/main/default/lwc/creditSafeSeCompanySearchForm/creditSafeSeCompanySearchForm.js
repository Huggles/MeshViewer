/**
 * Created by jaapbranderhorst on 16/02/2020.
 */

import {api, LightningElement} from 'lwc';
import {fireEvent, registerListener} from "c/pubsub";
import {FlowAttributeChangeEvent} from 'lightning/flowSupport';

export default class CreditSafeSeCompanySearchForm extends LightningElement {
    @api
    creditSafeId;
    @api
    status;
    @api
    registrationNumber;
    @api
    vatNumber;

    get statuses() {
        return [
            { label: 'Active', value: 'Active' },
            { label: 'Active, NonActive', value: 'Active, NonActive' }
        ];
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
    allValid() {
        const valid = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
            }, true);
        return valid;
    }

    handleOnChange(event) {
        const attributeChangeEvent = new FlowAttributeChangeEvent(event.target.name, event.target.value);
        this.dispatchEvent(attributeChangeEvent);
    }

    handleStatusOnChange(event) {
        this.status = event.target.value;
        this.handleOnChange(event);
    }
}