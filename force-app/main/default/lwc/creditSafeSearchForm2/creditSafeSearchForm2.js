/**
 * Created by jaapbranderhorst on 23/02/2020.
 */

import {api, LightningElement, track} from 'lwc';
import Country_Belgium from '@salesforce/label/c.Country_Belgium';
import Country_France from '@salesforce/label/c.Country_France';
import Country_Germany from '@salesforce/label/c.Country_Germany';
import Country_Ireland from '@salesforce/label/c.Country_Ireland';
import Country_Netherlands from '@salesforce/label/c.Country_Netherlands';
import Country_United_Kingdom from '@salesforce/label/c.Country_United_Kingdom';
import Country_Sweden from '@salesforce/label/c.Country_Sweden';

export default class CreditSafeSearchForm2 extends LightningElement {

    @api selectedCountry;

    @api name;
    @api status;
    @api creditSafeId;
    @api registrationNumber;
    @api vatNumber;
    @api province;
    @api city;
    @api street;
    @api postalCode;

    @track errorMessage;
    @track errorTitle;

    labels = {
        Country_Belgium,
        Country_France,
        Country_Germany,
        Country_Ireland,
        Country_United_Kingdom,
        Country_Sweden
    }

    get countries() {
        return [
            { label: Country_Belgium, value: 'BE' },
            { label: Country_Germany, value: 'DE' },
            { label: Country_France, value: 'FR' },
            { label: Country_United_Kingdom, value: 'GB' },
            { label: Country_Ireland, value: 'IE' },
            { label: Country_Sweden, value: 'SE' }
        ];
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

    get statuses() {
        let statuses;
        if (this.isFrSelected) {
            statuses = [
                { label: 'Active', value: 'Active' },
                { label: 'NonActive', value: 'NonActive'},
                { label: 'Active, NonActive', value: 'Active, NonActive' }
            ];
        }
        if (this.isSeSelected || this.isIeSelected || this.isGbSelected || this.isDeSelected) {
            statuses = [
                { label: 'Active', value: 'Active' },
                { label: 'Active, NonActive', value: 'Active, NonActive' }
            ];
        }
        return statuses;
    }

    @api
    allValid() {
        let valid = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
            }, true);
        if (this.isBeSelected) {
           // if (!this.creditSafeId && !this.registrationNumber && !this.vatNumber && ())

        }
        if (this.isDeSelected) {

        }
        if (this.isFrSelected) {

        }
        if (this.isGbSelected) {

        }
        if (this.isIeSelected) {

        }
        if (this.isSeSelected) {

        }
        // if the errorMessage is set, this will return false
        valid = valid && !this.errorMessage;
        return valid;
    }

    handleOnChange(event) {
        const attributeChangeEvent = new FlowAttributeChangeEvent(event.target.name, event.target.value);
        this.dispatchEvent(attributeChangeEvent);
    }

    handleSelectedCountryChange(event) {
        this.selectedCountry = event.target.value;
    }

    handleStatusOnChange(event) {
        this.status = event.target.value;
        this.handleOnChange(event);
    }

}