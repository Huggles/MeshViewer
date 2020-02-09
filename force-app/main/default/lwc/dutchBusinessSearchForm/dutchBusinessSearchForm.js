/**
 * Created by jaapbranderhorst on 09/02/2020.
 */

import {api, LightningElement} from 'lwc';

export default class DutchBusinessSearchForm extends LightningElement {
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

    get allValid() {
        const allValid = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
            }, true);
        return allValid;
    }

    handleOnChange(event) {
        const attributeChangeEvent = new FlowAttributeChangeEvent(event.target.name, event.target.value);
        this.dispatchEvent(attributeChangeEvent);
    }

    @api
    validate() {
        if(this.allValid) {
            return { isValid: true };
        }
        else {
            // If the component is invalid, return the isValid parameter
            // as false and return an error message.
            return {
                isValid: false,
                errorMessage: '/*A message in dutch business form that explains what went wrong.*/'
            };
        }
    }

}