/**
 * Created by jaapbranderhorst on 08/02/2020.
 */

import {LightningElement, api} from 'lwc';

export default class OrganisationSearchForm extends LightningElement {
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

}