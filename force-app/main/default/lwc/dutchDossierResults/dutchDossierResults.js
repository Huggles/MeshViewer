/**
 * Created by jaapbranderhorst on 19/02/2020.
 */

import {LightningElement, api, track} from 'lwc';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent, FlowNavigationFinishEvent } from 'lightning/flowSupport';
import {fireEvent, registerListener} from "c/pubsub";

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
    handleSelected(event) {
        // search for the right record
        const id = event.detail.recordSelected;
        const dutchDossierSearchResultCards = [...this.template.querySelectorAll('c-dutch-dossier-search-result-card')];
        const dutchDossierSearchResultCard = dutchDossierSearchResultCards.find(card => card.searchResultId === id);
        // set the result param, this is done here because this component knows the type
        const attributeChangeEvent = new FlowAttributeChangeEvent('selectedResult', dutchDossierSearchResultCard.searchResult);
        this.dispatchEvent(attributeChangeEvent);
        fireEvent(null, 'resultSelected', {selectedResult: event.detail.recordSelected}); // let the world know something is selected
        // // go to the next step
        // if (this.availableActions.find(action => action === 'NEXT')) {
        //     // navigate to the next screen
        //     const navigateNextEvent = new FlowNavigationNextEvent();
        //     this.dispatchEvent(navigateNextEvent);
        // } else {
        //     if (this.availableActions.find(action => action === 'FINISH')) {
        //         const navigateFinishEvent = new FlowNavigationFinishEvent();
        //         this.dispatchEvent(navigateFinishEvent);
        //     }
        // }
    }

}