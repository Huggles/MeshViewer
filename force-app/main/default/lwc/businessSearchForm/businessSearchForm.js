/**
 * Created by jaapbranderhorst on 08/02/2020.
 */

import {LightningElement, api, track} from 'lwc';
import {FlowAttributeChangeEvent} from 'lightning/flowSupport';
import {fireEvent} from 'c/pubsub';

export default class BusinessSearchForm extends LightningElement {
    // TODO: implement validation
    // TODO: introduce labels
    get countries() {
        return [
            { label: 'The Netherlands', value: 'NL' },
            { label: 'Belgium', value: 'BE' },
            { label: 'Germany', value: 'DE' },
            { label: 'France', value: 'FR' },
            { label: 'United Kingdom', value: 'GB' },
            { label: 'Ireland', value: 'IR' },
            { label: 'Sweden', value: 'SE' }
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
    get isNlSelected() {
        return this.selectedCountry === 'NL';
    }
    @api
    get isGbSelected() {
        return this.selectedCountry === 'GB';
    }
    @api
    get isBeSelected() {
        return this.selectedCountry === 'Be';
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

    /**
     * Checks if the input in all input elements in this template is valid
     * @returns true if valid
     */
    get allValid() {
        const allValid = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
            }, true);
        return allValid;
    }

    /**
     * Called by the framework
     * TODO this needs to be called before the next button is entered and not by the flow framework since that overrides the error handling
     */
    @api
    validate() {
        // first check if all input elements here are valid
        // if (this.allValid) {
            // then go over all child templates
        const allValid = [...this.template.querySelectorAll('.searchForm')]
            .reduce((validSoFar, template) => {
                return validSoFar && template.checkValid();
            }, true);
        if (allValid) {
            return { isValid: true};
        }
        else {
            return {
                isValid: false,
                errorMessage: 'test'

            }
        }
        // }

        // if(this.allValid) {
        //     return { isValid: true };
        // }
        // else {
        //     // If the component is invalid, return the isValid parameter
        //     // as false and return an error message.
        //     return {
        //         isValid: false,
        //         errorMessage: '/*A message that explains what went wrong in upper elem.*/'
        //     };
        // }
    }

}