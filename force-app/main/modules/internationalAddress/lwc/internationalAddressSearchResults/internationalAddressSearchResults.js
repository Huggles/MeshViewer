/**
 * Created by jaapbranderhorst on 12/03/2020.
 */

import {api, LightningElement} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import More_than_20_results_message from '@salesforce/label/c.More_than_20_results_message';

export default class InternationalAddressSearchResults extends LightningElement {
    @api
    availableActions = [];

    @api
    searchResults;

    @api
    selectedResult;

    @api
    country;

    connectedCallback() {
        if (this.searchResults && this.searchResults instanceof Array && this.searchResults.length >= 20) {
            const event = new ShowToastEvent({
                message: More_than_20_results_message
            });
            this.dispatchEvent(event);
            this.errorMessage = null;
        }
    }

    get isNlSelected() {
        return this.country === 'NLD';
    }
}