/**
 * Created by tejaswinidandi on 19/06/2020.
 */
import {LightningElement} from 'lwc';
import {fireEvent} from "c/pubsub";
import {FlowAttributeChangeEvent, FlowNavigationNextEvent, FlowNavigationFinishEvent} from 'lightning/flowSupport';
import More_than_20_results_message from '@salesforce/label/c.More_than_20_results_message';
import {ShowToastEvent} from "lightning/platformShowToastEvent";

const tileSelected = (id, searchResultTiles, component) => {
    var selectedResult;

    let tileClicked = searchResultTiles.find(card => card.searchResultId === id);
    selectedResult = tileClicked.searchResult;

    // (un)select the cards
    if (!tileClicked.selected) { // current 'old' state is unselected, user wants to select this card
        const unselectedTiles = searchResultTiles.filter(value => value !== tileClicked);
        unselectedTiles.forEach(value => value.selected = false);

        // set the result param, this is done here because this component knows the type
        const attributeChangeEvent = new FlowAttributeChangeEvent('selectedResult', tileClicked.searchResult);
        component.dispatchEvent(attributeChangeEvent);

        fireEvent(null, 'resultselected', {selectedResult: tileClicked.searchResult});
    }
    else {
        const attributeChangeEvent = new FlowAttributeChangeEvent('selectedResult', selectedResult);
        component.dispatchEvent(attributeChangeEvent);

        fireEvent(null, 'resultunselected');
    }
    tileClicked.selected = !tileClicked.selected; // select or unselect the card

    return {selectedResult: selectedResult};
};

const showToastMessageForMoreResults = (searchResults, component) => {
    if (searchResults && searchResults instanceof Array && searchResults.length >= 20) {
        const event = new ShowToastEvent({
            message: More_than_20_results_message
        });
        component.dispatchEvent(event);
    }
}


export {tileSelected, showToastMessageForMoreResults}