/**
 * Created by appsolutely on 18/02/2020.
 */

import {LightningElement, track, api, wire} from 'lwc';
import {FlowAttributeChangeEvent, FlowNavigationNextEvent} from 'lightning/flowSupport';
import getCountries from '@salesforce/apex/InternationalAddressController.getCountries';

export default class SearchInternationalAddress extends LightningElement {

    @api organization;
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

    @api availableActions = [];

    @track selectOptions = [];
    @track value = 'EN';

    @wire(getCountries)
    countries({ error, data }){
        if(data){
            for(var i=0; i < data.length; i++){
                const option = {
                    label: data[i],
                    value: data[i]
                };
                this.selectOptions = [...this.selectOptions, option];
            }
        }
    }

    handleChange(event) {
        const attributeChangeEvent = new FlowAttributeChangeEvent(event.target.name, event.target.value);
        this.dispatchEvent(attributeChangeEvent);
    }
}