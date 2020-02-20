/**
 * Created by appsolutely on 18/02/2020.
 */

import {LightningElement, track, api, wire} from 'lwc';
import {FlowAttributeChangeEvent, FlowNavigationNextEvent} from 'lightning/flowSupport';
import getCountries from '@salesforce/apex/InternationalAddressController.getCountries';

export default class Lwc_TextBox extends LightningElement {
    @track _organization = '';
    @track _building = '';
    @track _street = '';
    @track _housenr = '';
    @track _postcode = '';
    @track _locality = '';
    @track _province = '';
    @track _pobox = '';
    @track _language = '';
    @track _country = '';
    @track _txtBoxVal = '';

    @api availableActions = [];


    @track selectOptions = [];
    @track value = 'en';
    @track org = '';

    @wire(getCountries)
    countries({ error, data }){
        if(data){
            for(const list of data){
                const option = {
                    label: list.appsolutely__Country_Format__c,
                    value: list.appsolutely__Country_Format__c
                };
                this.selectOptions = [...this.selectOptions, option];

            }

        }
    }

    @api
    get txtBoxVal(){
        return this._organization;
    }

    set txtBoxVal(val){
        this._organization = val;
    }

    @api
    get organization(){
        return this._organization;
    }

    set organization(val){
        this._organization = val;
    }

    @api
    get building(){
        return this._building;
    }

    set building(val){
        this._building = val;
    }

    @api
    get street(){
        return this._street;
    }

    set street(val){
        this._street = val;
    }

    @api
    get housenr(){
        return this._housenr;
    }

    set housenr(val){
        this._housenr = val;
    }

    @api
    get pobox(){
        return this._pobox;
    }

    set pobox(val){
        this._pobox = val;
    }

    @api
    get locality(){
        return this._locality;
    }

    set locality(val){
        this._locality = val;
    }

    @api
    get postcode(){
        return this._postcode;
    }

    set postcode(val){
        this._postcode = val;
    }

    @api
    get province(){
        return this._province;
    }

    set province(val){
        this._province = val;
    }

    @api
    get language(){
        return this._language;
    }

    set language(val){
        this._language = val;
    }



    handleChange(event) {
        if(event.target.name == 'organization') {
            this._organization = event.target.value;
        }
        else if(event.target.name == 'building'){
            this._building = event.target.value;
        }
        else if(event.target.name == 'street'){
            this.street = event.target.value;
        }
        else if(event.target.name == 'housenr'){
            this._housenr = event.target.value;
        }
        else if(event.target.name == 'pobox'){
            this._pobox = event.target.value;
        }else if(event.target.name == 'locality'){
            this._locality = event.target.value;
        }
        else if(event.target.name == 'postcode'){
            this._postcode = event.target.value;
        }
        else if(event.target.name == 'province'){
            this._province = event.target.value;
        }
        else if(event.target.name == 'language'){
            this._language = event.target.value;
        }
        else if(event.target.name == 'country'){
            this._country = event.target.value;
        }


    }

    //Change attribute on Flow
    handleClick(event) {
        const attributeChangeEvent = new FlowAttributeChangeEvent('organization', this._organization);
        this.dispatchEvent(attributeChangeEvent);
    }

    //Hook to Flow's Validation engine
    @api
    validate() {
        if(!this._organization.includes('oracle')) {
            return { isValid: true };
        }
        //If the component is invalid, return the isValid parameter as false and return an error message.
        return {
            isValid: false,
            errorMessage:  'You cannot have string oracle in String'
        };
    }

    //Go to Next screen of Flow
    handleNext(event){
        const nextNavigationEvent = new FlowNavigationNextEvent();
        this.dispatchEvent(nextNavigationEvent);
    }
}