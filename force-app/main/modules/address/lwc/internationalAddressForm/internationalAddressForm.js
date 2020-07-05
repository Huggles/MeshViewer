/**
 * Created by tejaswinidandi on 23/06/2020.
 */

import {LightningElement, track, api, wire} from 'lwc';
import {FlowAttributeChangeEvent, FlowNavigationNextEvent} from 'lightning/flowSupport';
import {fireEvent, registerListener, unregisterAllListeners} from "c/pubsub";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {sanitizeStreet} from "c/inputSanitization";

import Building from '@salesforce/label/c.Building';
import Street from '@salesforce/label/c.Street';
import POBox from '@salesforce/label/c.POBox';
import Locality from '@salesforce/label/c.Locality';
import Postcode from '@salesforce/label/c.Postal_Code';
import Province from '@salesforce/label/c.Province';
import House_Number from '@salesforce/label/c.House_Number';
import Country from '@salesforce/label/c.Country';
import Locality_Help_Text from '@salesforce/label/c.Locality_Help_Text';

export default class InternationalAddressForm extends LightningElement {
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
        Building,
        Street,
        House_Number,
        POBox,
        Locality,
        Postcode,
        Province,
        Country,
        Locality_Help_Text
    }

    handleOnChange(event) {
        this.dispatchFlowAttributeChangeEvent(event.target.name, event.target.value);
    }

    dispatchFlowAttributeChangeEvent(attributeName, attributeValue) {
        const attributeChangeEvent = new FlowAttributeChangeEvent(attributeName, attributeValue);
        this.dispatchEvent(attributeChangeEvent);
    }
}