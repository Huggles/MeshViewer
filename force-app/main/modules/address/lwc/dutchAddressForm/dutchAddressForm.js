/**
 * Created by tejaswinidandi on 23/06/2020.
 */

import {api, track, wire, LightningElement} from 'lwc';
import {fireEvent, registerListener, unregisterAllListeners} from "c/pubsub";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {FlowAttributeChangeEvent, FlowNavigationNextEvent} from 'lightning/flowSupport';

import Street from '@salesforce/label/c.Street';
import Locality from '@salesforce/label/c.Locality';
import Postcode from '@salesforce/label/c.Postal_Code';
import Province from '@salesforce/label/c.Province';
import House_Number from '@salesforce/label/c.House_Number';
import Locality_Help_Text from '@salesforce/label/c.Locality_Help_Text';
import House_Number_Addition from '@salesforce/label/c.House_Number_Addition';
import Letter_Combination from '@salesforce/label/c.Letter_Combination';
import Address_Type from '@salesforce/label/c.Address_Type';
import Municipality from '@salesforce/label/c.Municipality';
import Address_Type_Help_Text from '@salesforce/label/c.Address_Type_Help_Text';
import Postal_code_pattern_mismatch_message from '@salesforce/label/c.Postal_code_pattern_mismatch_message';
import Letter_Combination_pattern_mismatch_message from '@salesforce/label/c.Letter_Combination_pattern_mismatch_message';
import Odd from '@salesforce/label/c.Odd';
import Even from '@salesforce/label/c.Even';

export default class DutchAddressForm extends LightningElement {
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
    @api housenrAddition;
    @api lettercombination;
    @api addresstype;
    @api municipality;

    label = {
        Street,
        House_Number,
        Locality,
        Postcode,
        Province,
        Locality_Help_Text,
        House_Number_Addition,
        Letter_Combination,
        Address_Type,
        Municipality,
        Address_Type_Help_Text,
        Postal_code_pattern_mismatch_message,
        Letter_Combination_pattern_mismatch_message
    }

    get addressTypes() {
        let addressTypes = [
            { label: Even, value: '0' },
            { label: Odd, value: '1' }
        ];
        return addressTypes;
    }

    handleOnChange(event) {
        this.dispatchFlowAttributeChangeEvent(event.target.name, event.target.value);
    }

    dispatchFlowAttributeChangeEvent(attributeName, attributeValue) {
        const attributeChangeEvent = new FlowAttributeChangeEvent(attributeName, attributeValue);
        this.dispatchEvent(attributeChangeEvent);
    }

}