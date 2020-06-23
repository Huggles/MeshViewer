/**
 * Created by jaapbranderhorst on 12/03/2020.
 */

import {api, LightningElement} from 'lwc';
import {fireEvent} from "c/pubsub";
import {FlowAttributeChangeEvent, FlowNavigationNextEvent, FlowNavigationFinishEvent} from 'lightning/flowSupport';
import {showToastMessageForMoreResults, tileSelected} from "c/resultTileFunctionality";

export default class InternationalAddressSearchResults extends LightningElement {
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
        let tileClicked = searchResultTiles.find(card => card.searchResultId === id);
        let result = tileSelected(id, searchResultTiles, this);
        this.selectedResult = result.selectedResult;
    }
}