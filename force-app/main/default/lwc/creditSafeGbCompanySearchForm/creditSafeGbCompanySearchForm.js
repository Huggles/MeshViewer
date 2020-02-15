/**
 * Created by jaapbranderhorst on 15/02/2020.
 */

import {LightningElement, api} from 'lwc';
import {fireEvent, registerListener} from "c/pubsub";

export default class CreditSafeGbCompanySearchForm extends LightningElement {
    @api
    id;
    @api
    status;
    @api
    registration_number;
    @api
    registration_type;
    @api
    vat_number;
    @api
    province;
    @api
    city;
    @api
    street;
    @api
    postal_code;
    @api
    name;

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