/**
 * Created by jaapbranderhorst on 19/02/2020.
 */

import {LightningElement, api, track} from 'lwc';

export default class DutchDossierResults extends LightningElement {
    @api
    searchResults;

    @api
    selectedResult;

    localKey = -1;

    get ourKey()
    {
        this.localKey++;
        return this.localKey;
    }

    handleSelected(event) {

    }


}