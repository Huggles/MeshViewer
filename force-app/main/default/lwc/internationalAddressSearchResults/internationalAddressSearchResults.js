/**
 * Created by jaapbranderhorst on 12/03/2020.
 */

import {api, LightningElement} from 'lwc';

export default class InternationalAddressSearchResults extends LightningElement {
    @api
    availableActions = [];

    @api
    searchResults;

    @api
    selectedResult;
}