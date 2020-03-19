/**
 * Created by appsolutely on 18/02/2020.
 */

import {LightningElement, track, api, wire} from 'lwc';
import {FlowAttributeChangeEvent, FlowNavigationNextEvent} from 'lightning/flowSupport';
import getIso3166Options from '@salesforce/apex/Iso3166CountryPickListController.getIso3166Options';
import getIsO3166OptionByAlpha2Code from '@salesforce/apex/Iso3166CountryPickListController.getIsO3166OptionByAlpha2Code';
import {fireEvent, registerListener, unregisterAllListeners} from "c/pubsub";

export default class InternationalAddressSearchForm extends LightningElement {

    @api organization;
    @api organizationRequired = false;
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
    @api countryInAlpha2Code;

    @api availableActions = [];

    @track selectOptions = [];
    @track error;

    /**
     * Loads all the countries according to Iso3166
     */
    loadCountries() {
        getIso3166Options()
            .then(result => {
                // result consists of an array of objects with country, alpha3Code and countryCode as fields
                let localSelectOptions = [];
                for (const resultElement of result) {
                    localSelectOptions.push({value: resultElement.alpha3Code, label: resultElement.country});
                }
                this.selectOptions = localSelectOptions;
            })
            .catch(error => {
                this.error = error;
            });
    }

    /**
     * Loads the country configured by the admin in the flow.
     * If the admin has set the countryInAlpha2Code property loads the correct alpha 3 code into the country property
     */
    getDefaultCountry() {
        if (this.countryInAlpha2Code && this.countryInAlpha2Code !== '') {
            getIsO3166OptionByAlpha2Code({alpha2Code: this.countryInAlpha2Code})
                .then(result => {
                    if (result && result.alpha3Code) {
                        this.country = result.alpha3Code;
                        this.dispatchFlowAttributeChangeEvent('country', this.country);
                    }
                    else {
                        this.error = "Invalid country alpha 2 code: " + this.countryInAlpha2Code;
                    }
                })
                .catch(error => {
                    this.error = error;
                });

        } else {
            if (!this.country || this.country === '') {
                this.country = 'NLD';
                this.dispatchFlowAttributeChangeEvent('country', this.country);
            }

        }
    }

    connectedCallback() {
        registerListener('validationRequest', this.handleValidationRequest, this);
        registerListener('componentRegistrationOpen', this.handleComponentRegistrationOpen, this);
        this.loadCountries();
        this.getDefaultCountry();
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
        this.dispatchFlowAttributeChangeEvent(event.target.name, event.target.value);
    }

    handleSelectedCountryChange(event) {
        this.country = event.target.value;
        this.handleOnChange(event);
    }

    dispatchFlowAttributeChangeEvent(attributeName, attributeValue) {
        const attributeChangeEvent = new FlowAttributeChangeEvent(attributeName, attributeValue);
        this.dispatchEvent(attributeChangeEvent);
    }
}