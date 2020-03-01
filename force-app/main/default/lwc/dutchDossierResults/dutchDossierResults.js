/**
 * Created by jaapbranderhorst on 19/02/2020.
 */

import {LightningElement, api, track} from 'lwc';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent, FlowNavigationFinishEvent } from 'lightning/flowSupport';
import {fireEvent} from "c/pubsub";

export default class DutchDossierResults extends LightningElement {
    @api
    availableActions = [];

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

    /**
     * Handler to handle the selection of a search result.
     * @param event
     */
    handleCardClicked(event) {
        // search for the right record
        const id = event.detail.id;
        const dutchDossierSearchResultCards = [...this.template.querySelectorAll('c-dutch-dossier-search-result-card')];
        let cardClicked = dutchDossierSearchResultCards.find(card => card.searchResultId === id);
        // (un)select the cards
        if (!cardClicked.selected) { // current 'old' state is unselected, user wants to select this card
            const unselectedCards = dutchDossierSearchResultCards.filter(value => value !== cardClicked);
            unselectedCards.forEach(value => value.selected = false);
            // set the result param, this is done here because this component knows the type
            const attributeChangeEvent = new FlowAttributeChangeEvent('selectedResult', cardClicked.searchResult);
            this.dispatchEvent(attributeChangeEvent);
            fireEvent(null, 'resultselected', {selectedResult: event.detail.recordSelected}); // let the world know something is selected
        } else {
            const attributeChangeEvent = new FlowAttributeChangeEvent('selectedResult', null);
            this.dispatchEvent(attributeChangeEvent);
            fireEvent(null, 'resultunselected');
        }
        cardClicked.selected = !cardClicked.selected; // select or unselect the card
    }

}