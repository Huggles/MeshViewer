/**
 * Created by jaapbranderhorst on 08/02/2020.
 */

import {LightningElement, api, track} from 'lwc';
import {FlowAttributeChangeEvent} from 'lightning/flowSupport';
import {fireEvent, registerListener, unregisterAllListeners} from 'c/pubsub';
import {sanitizeStreet} from "c/inputSanitization";

import getCountryOptions from "@salesforce/apex/BusinessSearchFormController.getCountryOptions";
import {ToastEventController} from "c/toastEventController";

import Country from '@salesforce/label/c.Country';
import Select_a_Country from '@salesforce/label/c.Select_a_Country';

export default class BusinessSearchForm extends LightningElement {

    label = {
        Country,
        Select_a_Country
    }

    get countries() {
        getCountryOptions()
            .then(result => {return result})
            .catch(error => {});
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

    handleComponentRegistrationOpen(event) {
        // fire a registration event
        if(event.pageRef == 'BusinessSearchForm'){
            fireEvent(this.pageRef, 'componentRegistration', {component: this, pageRef: event.pageRef});
        }

    }

    handleValidationRequest(event) {
        if(event.pageRef == 'BusinessSearchForm'){
            fireEvent(this.pageRef, 'componentValidationDone', {component: this, isValid: this.allValid(), pageRef: event.pageRef});
        }
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