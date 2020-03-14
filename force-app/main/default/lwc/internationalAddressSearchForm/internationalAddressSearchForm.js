/**
 * Created by appsolutely on 18/02/2020.
 */

import {LightningElement, track, api, wire} from 'lwc';
import {FlowAttributeChangeEvent, FlowNavigationNextEvent} from 'lightning/flowSupport';
import getCountries from '@salesforce/apex/Iso3166CountryPickListController.getIso3166Options';
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
    @api country = 'NLD';

    @api availableActions = [];

    @track selectOptions = [];

    loadCountries() {
        getIso3166Options()
            .then(result => {
                // result consists of an array of objects with country, alpha3Code and countryCode as fields
                for (const resultElement of result) {
                    this.selectOptions.push({value: resultElement.alpha3Code, label: resultElement.country});
                }
            })
            .catch(error => {
                this.error = error;
            });
    }

    connectedCallback() {
        registerListener('validationRequest', this.handleValidationRequest, this);
        registerListener('componentRegistrationOpen', this.handleComponentRegistrationOpen, this);
        this.loadCountries();
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
        // this.hints = null; // remove the toast
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