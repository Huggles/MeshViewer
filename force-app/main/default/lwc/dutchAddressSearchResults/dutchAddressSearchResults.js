/**
 * Created by tejaswinidandi on 17/05/2020.
 */

import {LightningElement, api} from 'lwc';

export default class DutchAddressSearchResults extends LightningElement {
    @api
    availableActions = [];

    @api
    searchResults;

    @api
    selectedResult;
}