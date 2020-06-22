/**
 * Created by tejaswinidandi on 17/04/2020.
 */

import { LightningElement, api, wire, track } from 'lwc';
import {FlowAttributeChangeEvent, FlowNavigationNextEvent} from 'lightning/flowSupport';

//Static resources
import companyInfoLogoSmall from '@salesforce/resourceUrl/companyInfoLogoSmall';

export default class AccountEnrichmentHeaderInternationalAddress extends LightningElement {
    @api internationalAddressId;
    @api searchAgainClicked;

    staticResource = {
        companyInfoLogoSmall,
    }

    handleSearchAgainClicked(event) {
        this.searchAgainClicked = true;
        const attributeChangeEvent = new FlowAttributeChangeEvent('searchAgainClicked', this.searchAgainClicked);
        this.dispatchEvent(attributeChangeEvent);
        //we throw an event because the flow needs to show a search form
        this.dispatchEvent(new FlowNavigationNextEvent());
    }
}