/**
 * Created by tejaswinidandi on 19/06/2020.
 */
import {LightningElement} from 'lwc';
import {fireEvent} from "c/pubsub";
import {FlowAttributeChangeEvent, FlowNavigationNextEvent, FlowNavigationFinishEvent} from 'lightning/flowSupport';

const tileSelected = (id, searchResultTiles, component) => {
    var selectedResult;
    var houseNumberAddition;
    var streetName;

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


export {tileSelected}