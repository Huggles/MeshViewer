/**
 * Created by jaapbranderhorst on 08/02/2020.
 */

import {LightningElement, api, track} from 'lwc';
import {FlowAttributeChangeEvent} from 'lightning/flowSupport';
import {fireEvent, registerListener, unregisterAllListeners} from 'c/pubsub';
import {sanitizeStreet} from "c/inputSanitization";

import Country_Belgium from '@salesforce/label/c.Country_Belgium';
import Country_France from '@salesforce/label/c.Country_France';
import Country_Germany from '@salesforce/label/c.Country_Germany';
import Country_Ireland from '@salesforce/label/c.Country_Ireland';
import Country_Netherlands from '@salesforce/label/c.Country_Netherlands';
import Country_United_Kingdom from '@salesforce/label/c.Country_United_Kingdom';
import Country_Sweden from '@salesforce/label/c.Country_Sweden';
import Country from '@salesforce/label/c.Country';
import Select_a_Country from '@salesforce/label/c.Select_a_Country';
import Country_Denmark from '@salesforce/label/c.Country_Denmark';
import Country_Italy from '@salesforce/label/c.Country_Italy';
import Country_Norway from '@salesforce/label/c.Country_Norway';
import Country_Spain from '@salesforce/label/c.Country_Spain';

export default class BusinessSearchForm extends LightningElement {

    label = {
        Country_Belgium,
        Country_France,
        Country_Germany,
        Country_Ireland,
        Country_Netherlands,
        Country_United_Kingdom,
        Country_Sweden,
        Country,
        Select_a_Country
    }

    get countries() {
        return [
            { label: Country_Belgium, value: 'BE' },
            { label: Country_Denmark, value: 'DK' },
            { label: Country_France, value: 'FR' },
            { label: Country_Germany, value: 'DE' },
            { label: Country_Ireland, value: 'IE' },
            { label: Country_Italy, value: 'IT' },
            { label: Country_Netherlands, value: 'NL'},
            { label: Country_Norway, value: 'NO' },
            { label: Country_Spain, value: 'ES' },
            { label: Country_Sweden, value: 'SE' },
            { label: Country_United_Kingdom, value: 'GB' }
        ];
    }

    // TODO: make NL configurable depending on a user custom setting
    @api
    selectedCountry;
    @api
    dossierNumber;
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
    creditSafeId;
    @api
    strictSearch;
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

    @api
    get isItSelected() {
        return this.selectedCountry === 'IT';
    }

    @api
    get isNoSelected() {
        return this.selectedCountry === 'NO';
    }

    @api
    get isDkSelected() {
        return this.selectedCountry === 'DK';
    }

    @api
    get isEsSelected() {
        return this.selectedCountry === 'ES';
    }

    connectedCallback() {
        registerListener('validationRequest', this.handleValidationRequest, this);
        registerListener('componentRegistrationOpen', this.handleComponentRegistrationOpen, this);
        if (this.street) this.assignStreetAndHouseNumber(this.street);
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

    handleSelectedCountryChange(event) {
        this.selectedCountry = event.target.value;
    }

    /**
     * Checks if the input in all input elements in this template is valid
     * @returns true if valid
     */
    allValid() {
        let valid = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
            }, true);
        // validate per search form
        valid = valid && this.template.querySelector('.searchForm').allValid();
        return valid;
    }

    assignStreetAndHouseNumber(street) {
        var streetWithHouseNumber = sanitizeStreet(this.street);
        if (streetWithHouseNumber) {
            if (this.houseNumber == null || this.houseNumber == undefined) this.houseNumber = streetWithHouseNumber.number;
            this.street = streetWithHouseNumber.street;
            if (this.houseNumberAddition == null || this.houseNumberAddition == undefined)this.houseNumberAddition = streetWithHouseNumber.addition;
        }
    }

}