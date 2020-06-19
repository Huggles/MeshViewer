/**
 * Created by jaapbranderhorst on 19/02/2020.
 */

import {LightningElement, api, track} from 'lwc';

import {fireEvent} from "c/pubsub";

export default class SearchResultTile extends LightningElement {

    /**
     * Contains the search result (in fact a business data SObject)
     */
    @api searchResult;

    /**
     * Contains a - within the searchResults - unique id for the search Result
     */
    @api searchResultId;

    /**
     * The field containing the title of the card. Defaults to Name
     */
    @api
    titleField = 'Name';

    /**
     * An object containing a data structure with a label and a field
     */
    @api labelsAndFields;

    /**
     * Contains the title of the tile
     */
    @api title;


    /**
     * Returns the values of the fields in the fieldset with the given fieldsetname
     */
    @api fieldValues = [];

    /**
     * The icon state to be shown
     */
    get iconState() {
        console.log('ART iconState');
        if (!this.selected) {
            return false;
        } else {
            return true;
        }
    }

    /**
     * True if the card is selected, otherwise false
     */
    @api
    selected;

    handleOnClick(event) {
        // this.selected = !this.selected;
        const cardClickedEvent = new CustomEvent('cardclicked', {detail : {id: this.searchResultId}});
        this.dispatchEvent(cardClickedEvent);
    }

}