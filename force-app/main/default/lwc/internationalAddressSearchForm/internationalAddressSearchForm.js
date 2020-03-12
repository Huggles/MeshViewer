/**
 * Created by appsolutely on 18/02/2020.
 */

import {LightningElement, track, api, wire} from 'lwc';
import {FlowAttributeChangeEvent, FlowNavigationNextEvent} from 'lightning/flowSupport';
import getCountries from '@salesforce/apex/InternationalAddressController.getCountries';
import {fireEvent, registerListener, unregisterAllListeners} from "c/pubsub";

export default class InternationalAddressSearchForm extends LightningElement {

    @api organization;
    @api building;
    @api street;
    @api housenr;
    @api postcode;
    @api locality;
    @api province;
    @api pobox;
    @api language;
    @api txtBoxVal;
    @api country;

    @api availableActions = [];

    @track selectOptions = [];
    @track value = 'EN';

    @wire(getCountries)// TODO: test if this doesn't constantly call the api
    countries({ error, data }){
        if(data){
            for(var i=0; i < data.length; i++){
                const option = {
                    label: data[i],
                    value: data[i]
                };
                this.selectOptions = [...this.selectOptions, option];
            }
        }
    }

    connectedCallback() {
        registerListener('validationRequest', this.handleValidationRequest, this);
        registerListener('componentRegistrationOpen', this.handleComponentRegistrationOpen, this);
    }

    disconnectedCallback() {
        unregisterAllListeners(this);
    }

    handleComponentRegistrationOpen(registrar) {
        // fire a registration event
        fireEvent(this.pageRef, 'componentRegistration', {component: this});
    }

    handleValidationRequest() {
        fireEvent(this.pageRef, 'componentValidationDone', {component: this, isValid: this.allValid()});
    }

    @api
    allValid() {
        this.hints = null; // remove the toast
        let valid = [...this.template.querySelectorAll('lightning-input')]
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

    handleSelectedCountryChange(event) {
        this.country = event.target.value;
        this.handleOnChange(event);
    }
}