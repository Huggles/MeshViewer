/**
 * Created by jaapbranderhorst on 27/02/2020.
 */

import {api, LightningElement} from 'lwc';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent, FlowNavigationFinishEvent } from 'lightning/flowSupport';
import {fireEvent, registerListener} from "c/pubsub";

export default class CreditSafeDossierSearchResults extends LightningElement {
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
    handleSelected(event) {
        // search for the right record
        const id = event.detail.recordSelected;
        const creditSafeDossierSearchResultCards = [...this.template.querySelectorAll('c-credit-safe-dossier-search-result-card')];
        const creditSafeDossierSearchResultCard = creditSafeDossierSearchResultCards.find(card => card.searchResultId === id);
        // set the result param, this is done here because this component knows the type
        const attributeChangeEvent = new FlowAttributeChangeEvent('selectedResult', creditSafeDossierSearchResultCard.searchResult);
        this.dispatchEvent(attributeChangeEvent);
        fireEvent(null, 'resultSelected', {selectedResult: event.detail.recordSelected}); // let the world know something is selected
    }

}