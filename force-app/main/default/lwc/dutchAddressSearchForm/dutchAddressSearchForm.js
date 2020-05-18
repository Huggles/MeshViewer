/**
 * Created by tejaswinidandi on 15/05/2020.
 */

import {LightningElement, api} from 'lwc';
import {fireEvent, registerListener} from "c/pubsub";

export default class DutchAddressSearchForm extends LightningElement {

    @api address;

    connectedCallback() {
        registerListener('validationRequest', this.handleValidationRequest, this);
        registerListener('componentRegistrationOpen', this.handleComponentRegistrationOpen, this);
    }

    handleComponentRegistrationOpen(registrar) {
        // fire a registration event
        fireEvent(this.pageRef, 'componentRegistration', {component: this});
    }

    handleValidationRequest() {
        fireEvent(this.pageRef, 'componentValidationDone', {component: this, isValid: valid});
    }
}