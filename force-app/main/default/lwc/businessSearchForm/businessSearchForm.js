/**
 * Created by jaapbranderhorst on 08/02/2020.
 */

import {LightningElement, api, track} from 'lwc';
import {FlowAttributeChangeEvent} from 'lightning/flowSupport';
import {fireEvent, registerListener} from 'c/pubsub';
import Country_Belgium from '@salesforce/label/c.Country_Belgium';
import Country_France from '@salesforce/label/c.Country_France';
import Country_Germany from '@salesforce/label/c.Country_Germany';
import Country_Ireland from '@salesforce/label/c.Country_Ireland';
import Country_Netherlands from '@salesforce/label/c.Country_Netherlands';
import Country_United_Kingdom from '@salesforce/label/c.Country_United_Kingdom';
import Country_Sweden from '@salesforce/label/c.Country_Sweden';

export default class BusinessSearchForm extends LightningElement {
    // TODO: implement validation
    // TODO: introduce labels
    labels = {
        Country_Belgium,
        Country_France,
        Country_Germany,
        Country_Ireland,
        Country_Netherlands,
        Country_United_Kingdom,
        Country_Sweden
    }

    get countries() {
        return [
            { label: Country_Netherlands, value: 'NL' },
            { label: Country_Belgium, value: 'BE' },
            { label: Country_Germany, value: 'DE' },
            { label: Country_France, value: 'FR' },
            { label: Country_United_Kingdom, value: 'GB' },
            { label: Country_Ireland, value: 'IE' },
            { label: Country_Sweden, value: 'SE' }
        ];
    }
    // TODO: make NL configurable depending on a user custom setting
    @api
    selectedCountry;
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
    @api
    id;
    @api
    status;
    @api
    registrationNumber;
    @api
    registrationType;
    @api
    vatNumber;
    @api
    province;
    @api
    name;

    @api
    get isNlSelected() {
        return this.selectedCountry === 'NL';
    }
    @api
    get isGbSelected() {
        return this.selectedCountry === 'GB';
    }
    @api
    get isBeSelected() {
        return this.selectedCountry === 'BE';
    }
    @api
    get isDeSelected() {
        return this.selectedCountry === 'DE';
    }
    @api
    get isFrSelected() {
        return this.selectedCountry === 'FR';
    }
    @api
    get isSeSelected() {
        return this.selectedCountry === 'SE';
    }
    @api
    get isIeSelected() {
        return this.selectedCountry === 'IE';
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

    handleSelectedCountryChange(event) {
        this.selectedCountry = event.target.value;
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

}