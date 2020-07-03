/**
 * Created by jaapbranderhorst on 08/02/2020.
 */

import {LightningElement, api, track} from 'lwc';
import {FlowAttributeChangeEvent} from 'lightning/flowSupport';
import {fireEvent, registerListener, unregisterAllListeners} from 'c/pubsub';
import {sanitizeStreet} from "c/inputSanitization";

import getCountryOptions from "@salesforce/apex/BusinessSearchFormController.getCountryOptions";
import getSelectedDataSource from "@salesforce/apex/BusinessSearchFormController.getSelectedDataSource";
import {ToastEventController} from "c/toastEventController";

import Country from '@salesforce/label/c.Country';
import Select_a_Country from '@salesforce/label/c.Select_a_Country';

export default class BusinessSearchForm extends LightningElement {

    label = {
        Country,
        Select_a_Country
    }

    isLoading = false;

    countries = [];


    _selectedCountry;
    @api
    get selectedCountry() { // default is set in the flow
        return this._selectedCountry;
    }
    set selectedCountry(value) {
        this._selectedCountry = value;
        this.loadDataSource(value);
    }

    _dataSource;
    @api
    get source() {
        if (!this._dataSource && this.selectedCountry) {
            this._dataSource = this.loadDataSource(this.selectedCountry)
            return this._dataSource;
        } else {
            return this._dataSource;
        }
    }
    set source(value) {
        this._dataSource = value;
    }

    async loadDataSource(alpha2CountryCode) {
        try {
            this.isLoading = true;
            this._dataSource = await getSelectedDataSource({alpha2CountryCode: alpha2CountryCode});
            return this._dataSource;
        } catch(error) {
            new ToastEventController(this).showErrorToastMessage(null,error.message);
        } finally {
            this.isLoading = false;
        }
    }


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

    get isSelectedDatasourceDutchChamberOfCommerce() {
        return this._dataSource === 'Dutch_Chamber_of_Commerce';
    }

    get isSelectedDatasourceCreditSafe() {
        return this._dataSource === 'Creditsafe';
    }

    get isSelectedDatasourceDunBradstreet() {
        return this._dataSource === 'Dun_Bradstreet';
    }

    get moreThanOneCountryOption() {
        return (this.countries != null && this.countries.length > 1);
    }

    /**
     * @deprecated
     */
    @api
    get isNlSelected() {
        return this.selectedCountry === 'NL';
    }

    /**
     * @deprecated
     */
    @api
    get isGbSelected() {
        return this.selectedCountry === 'GB';
    }

    /**
     * @deprecated
     */
    @api
    get isBeSelected() {
        return this.selectedCountry === 'BE';
    }

    /**
     * @deprecated
     */
    @api
    get isDeSelected() {
        return this.selectedCountry === 'DE';
    }

    /**
     * @deprecated
     */
    @api
    get isFrSelected() {
        return this.selectedCountry === 'FR';
    }

    /**
     * @deprecated
     */
    @api
    get isSeSelected() {
        return this.selectedCountry === 'SE';
    }

    /**
     * @deprecated
     */
    @api
    get isIeSelected() {
        return this.selectedCountry === 'IE';
    }

    /**
     * @deprecated
     */
    @api
    get isItSelected() {
        return this.selectedCountry === 'IT';
    }

    /**
     * @deprecated
     */
    @api
    get isNoSelected() {
        return this.selectedCountry === 'NO';
    }

    /**
     * @deprecated
     */
    @api
    get isDkSelected() {
        return this.selectedCountry === 'DK';
    }

    /**
     * @deprecated
     */
    @api
    get isEsSelected() {
        return this.selectedCountry === 'ES';
    }

    connectedCallback() {
        registerListener('validationRequest', this.handleValidationRequest, this);
        registerListener('componentRegistrationOpen', this.handleComponentRegistrationOpen, this);
        if (this.street) this.assignStreetAndHouseNumber(this.street);
        this.loadCountryOptions();
    }

    disconnectedCallback() {
        unregisterAllListeners(this);
    }

    loadCountryOptions() {
        this.isLoading = true;
        getCountryOptions()
            .then(result=>{
                this.countries = result;
            })
            .catch(error=>{
                new ToastEventController(this).showErrorToastMessage(null,error.body.message);
            })
            .finally(()=>{
                this.isLoading = false;
            })
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