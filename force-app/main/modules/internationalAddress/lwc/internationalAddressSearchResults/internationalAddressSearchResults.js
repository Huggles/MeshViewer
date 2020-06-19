/**
 * Created by jaapbranderhorst on 12/03/2020.
 */

import {api, LightningElement} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import More_than_20_results_message from '@salesforce/label/c.More_than_20_results_message';
import {fireEvent} from "c/pubsub";
import {FlowAttributeChangeEvent, FlowNavigationNextEvent, FlowNavigationFinishEvent} from 'lightning/flowSupport';
import {tileSelected} from "c/resultTileFuntionality";

export default class InternationalAddressSearchResults extends LightningElement {
    @api
    availableActions = [];

    @api
    searchResults;

    @api
    selectedResult;

    connectedCallback() {
        if (this.searchResults && this.searchResults instanceof Array && this.searchResults.length >= 20) {
            const event = new ShowToastEvent({
                message: More_than_20_results_message
            });
            this.dispatchEvent(event);
            this.errorMessage = null;
        }
    }

    handleOnCardClick(event) {
        console.log('ALT handleOnCardClick');
        // search for the right record
        const id = event.detail.id;
        const searchResultTiles = [...this.template.querySelectorAll('c-search-result-tile')];
        let tileClicked = searchResultTiles.find(card => card.searchResultId === id);
        let result = tileSelected(id, searchResultTiles, this);
        this.selectedResult = result.selectedResult;

        // this.selectedResult = tileClicked.searchResult;
        // // (un)select the cards
        // if (!tileClicked.selected) { // current 'old' state is unselected, user wants to select this card
        //     const unselectedTiles = searchResultTiles.filter(value => value !== tileClicked);
        //     unselectedTiles.forEach(value => value.selected = false);
        //     // set the result param, this is done here because this component knows the type
        //     const attributeChangeEvent = new FlowAttributeChangeEvent('selectedResult', tileClicked.searchResult);
        //     this.dispatchEvent(attributeChangeEvent);
        //     fireEvent(null, 'resultselected', {selectedResult: tileClicked.searchResult});
        // }
        // else {
        //     const attributeChangeEvent = new FlowAttributeChangeEvent('selectedResult', this.selectedResult);
        //     this.dispatchEvent(attributeChangeEvent);
        //     fireEvent(null, 'resultunselected');
        // }
        // tileClicked.selected = !tileClicked.selected; // select or unselect the card
    }
}