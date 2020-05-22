/**
 * Created by appsolutely on 18/02/2020.
 */

import {LightningElement, track, api, wire} from 'lwc';
import {FlowAttributeChangeEvent, FlowNavigationNextEvent} from 'lightning/flowSupport';
import getIso3166Options from '@salesforce/apex/Iso3166CountryPickListController.getIso3166Options';
import getIsO3166OptionByAlpha2Code from '@salesforce/apex/Iso3166CountryPickListController.getIsO3166OptionByAlpha2Code';
import {fireEvent, registerListener, unregisterAllListeners} from "c/pubsub";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {sanitizeStreet} from "c/inputSanitization";

import Organization from '@salesforce/label/c.Organization';
import Building from '@salesforce/label/c.Building';
import Street from '@salesforce/label/c.Street';
import POBox from '@salesforce/label/c.POBox';
import Locality from '@salesforce/label/c.Locality';
import Postcode from '@salesforce/label/c.Postal_Code';
import Province from '@salesforce/label/c.Province';
import House_Number from '@salesforce/label/c.House_Number';
import Country from '@salesforce/label/c.Country';
import Validation_Error_Message_Toast_Title from '@salesforce/label/c.Validation_Error_Message_Toast_Title';
import No_address_fields_filled_international_address from '@salesforce/label/c.No_address_fields_filled_international_address';
import Locality_Help_Text from '@salesforce/label/c.Locality_Help_Text';

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
    countryAlpha2codeByAlpha3code = new Map();

    @track errorMessage;

    label = {
        Organization,
        Building,
        Street,
        House_Number,
        POBox,
        Locality,
        Postcode,
        Province,
        Country,
        No_address_fields_filled_international_address,
        Validation_Error_Message_Toast_Title,
        Locality_Help_Text
    }

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
                    this.countryAlpha2codeByAlpha3code.set(resultElement.alpha3Code, resultElement.alpha2Code);
                }
                this.selectOptions = localSelectOptions;
            })
            .catch(error => {
                this.hints = error;
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
                        this.hints = "Invalid country alpha 2 code: " + this.countryInAlpha2Code;
                    }
                })
                .catch(error => {
                    this.hints = error;
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
        // TODO: move this to a module to make it generic
        // check if the fields are valid based on the html
        let valid = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
            }, true);
        // do the javascript based validation checks. Set the error message at the same time
        this.errorMessage = null; // just to be certain. Should be null or not defined anyway
        if (valid) { // only when the input on a field level is valid
            if (!(this.street || this.postcode || this.pobox || this.locality)) {
                valid = false;
                this.errorMessage = No_address_fields_filled_international_address;
            }
            // show the toast with the error message. Field level error messages are already handled in the check for field validity
            if (!valid) {
                const event = new ShowToastEvent({
                    title: Validation_Error_Message_Toast_Title,
                    message: this.errorMessage,
                    variant: 'error',
                    mode: 'sticky'
                });
                this.dispatchEvent(event);
                this.errorMessage = null;
            }
        }
        fireEvent(this.pageRef, 'componentValidationDone', {component: this, isValid: valid});
    }

    handleOnChange(event) {
        this.dispatchFlowAttributeChangeEvent(event.target.name, event.target.value);
    }

    handleSelectedCountryChange(event) {
        this.country = event.target.value;
        this.handleOnChange(event);
        this.countryInAlpha2Code = this.countryAlpha2codeByAlpha3code.get(this.country);
        this.dispatchFlowAttributeChangeEvent('countryInAlpha2Code', this.countryInAlpha2Code);
    }

    dispatchFlowAttributeChangeEvent(attributeName, attributeValue) {
        const attributeChangeEvent = new FlowAttributeChangeEvent(attributeName, attributeValue);
        this.dispatchEvent(attributeChangeEvent);
    }

    assignStreetAndHouseNumber(street) {
        var streetWithHouseNumber = sanitizeStreet(this.street);
        if (streetWithHouseNumber) {
            if (this.housenr == null || this.housenr == undefined) this.housenr = streetWithHouseNumber.number;
            this.street = streetWithHouseNumber.street;
        }
    }
}