/**
 * Created by appsolutely on 19/02/2020.
 */

import {LightningElement, track, wire} from 'lwc';
import search from '@salesforce/apex/InternationalAddressController.search';
import getCountries from '@salesforce/apex/InternationalAddressController.getCountries';

export default class DisplayInternationalAddress extends LightningElement {

    @track _organization = '';
    @track _building = '';
    @track _street = '';
    @track _housenr = '';
    @track _postcode = '';
    @track _locality = '';
    @track _province = '';
    @track _pobox = '';
    @track _language = '';
    @track _txtBoxVal = '';
    @track _country = '';

    retData ;
    error;
    @wire(getCountries) countries;



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
    handleClick() {
        this.error = 'undefined';

        countries(data);{

        }
       /* search({
            organization: this._organization,
            building: this._building,
            street: this._street,
            houseNumber: this._housenr,
            pobox: this._pobox,
            locality: this._locality,
            postcode: this._postcode,
            province: this._province,
            country: this._country,
            language: this._language,
            countryFormat: this._country
        })
        if (data) {
            //this.retData = data;
            this.error = 'undefined';
        } else if (error) {
            this.retData = undefined;
            this.error = error;
        }*/

    }
}