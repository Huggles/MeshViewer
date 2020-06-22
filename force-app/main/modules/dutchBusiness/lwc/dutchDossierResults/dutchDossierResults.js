/**
 * Created by jaapbranderhorst on 19/02/2020.
 */

import {LightningElement, api} from 'lwc';
import {fireEvent, registerListener} from "c/pubsub";
import {FlowAttributeChangeEvent, FlowNavigationNextEvent, FlowNavigationFinishEvent} from 'lightning/flowSupport';
import {tileSelected, showToastMessageForMoreResults} from "c/resultTileFuntionality";
export default class DutchDossierResults extends LightningElement {
    @api
    availableActions = [];

    @api
    searchResults;

    @api
    selectedResult;

    connectedCallback() {
        //if results are more than 20, show a toast
        showToastMessageForMoreResults(this.searchResults, this);
    }

    handleOnCardClick(event) {
        // search for the right record
        const id = event.detail.id;
        const searchResultTiles = [...this.template.querySelectorAll('c-search-result-tile')];
        let result = tileSelected(id, searchResultTiles, this);
        this.selectedResult = result.selectedResult;
    }

}