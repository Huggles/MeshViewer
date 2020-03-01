/**
 * Created by jaapbranderhorst on 19/02/2020.
 */

import {LightningElement, api, track} from 'lwc';

export default class DutchDossierSearchResultCard extends LightningElement {

    /**
     * Contains the search result (in fact a business data SObject)
     */
    @api
    searchResult;

    /**
     * Contains a - within the searchResults - unique id for the search Result
     */
    @api
    searchResultId;

    /**
     * The icon to be shown
     */
    get icon() {
        if (!this.selected) {
            return 'action:record';
        } else {
            return 'action:approval';
        }
    }

    /**
     * True if the card is selected, otherwise false
     */
    @api
    selected;

    /**
     * The title of the card
     */
    @track
    title = 'title';

    handleOnClick(event) {
        // this.selected = !this.selected;
        const cardClickedEvent = new CustomEvent('cardclicked', {detail : {id: this.searchResultId}});
        this.dispatchEvent(cardClickedEvent);
    }
}