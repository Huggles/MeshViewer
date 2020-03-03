/**
 * Created by appsolutely on 20/02/2020.
 */

import {api, LightningElement, wire} from 'lwc';

export default class InternationalAddressCardTile extends LightningElement {
    @api iconname = 'custom:custom24';
    @api internationalAddressData ;

    get isStreetAvailable() {
        return this.internationalAddressData.appsolutely__Street__c != null && this.internationalAddressData.appsolutely__Street__c != '' ? true : false;
    }
    get isHouseNrAvailable() {
        return this.internationalAddressData.appsolutely__House_Number__c != null && this.internationalAddressData.appsolutely__House_Number__c != '' ? true : false;
    }
    get isPOBoxAvailable() {
        return this.internationalAddressData.appsolutely__POBox__c != null && this.internationalAddressData.appsolutely__POBox__c != '' ? true : false;
    }
    get isLocalityAvailable() {
        return this.internationalAddressData.appsolutely__Locality__c != null && this.internationalAddressData.appsolutely__Locality__c != '' ? true : false;
    }
    get isPostcodeAvailable() {
        return this.internationalAddressData.appsolutely__Postcode__c != null && this.internationalAddressData.appsolutely__Postcode__c != '' ? true : false;
    }
    get isProvinceAvailable() {
        return this.internationalAddressData.appsolutely__Province__c != null && this.internationalAddressData.appsolutely__Province__c != '' ? true : false;
    }
    get isCountryAvailable() {
        return this.internationalAddressData.appsolutely__Country__c != null && this.internationalAddressData.appsolutely__Country__c != '' ? true : false;
    }
    get isCountrySpecificLocalityAvailable() {
        return this.internationalAddressData.appsolutely__Country_Specific_Locality__c != null && this.internationalAddressData.appsolutely__Country_Specific_Locality__c != '' ? true : false;
    }
    get isDeliveryAddressAvailable() {
        return this.internationalAddressData.appsolutely__Delivery_Address__c != null && this.internationalAddressData.appsolutely__Delivery_Address__c != '' ? true : false;
    }
    get isFormattedAddressAvailable() {
        return this.internationalAddressData.appsolutely__Formatted_Address__c != null && this.internationalAddressData.appsolutely__Formatted_Address__c != '' ? true : false;
    }

    handleClick(event){
        event.preventDefault();
        this.iconname = 'action:approval';
        const selectIconEvent = new CustomEvent('selectitem', {detail: this.internationalAddressData});
        this.dispatchEvent(selectIconEvent);
   }


}