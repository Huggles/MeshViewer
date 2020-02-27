/**
 * Created by jaapbranderhorst on 27/02/2020.
 */

import {api, LightningElement, track} from 'lwc';

export default class CreditSafeDossierSearchResultCard extends LightningElement {
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
    @track
    icon = 'action:record';

    /**
     * The title of the card
     */
    @track
    title = 'title';

    handleOnClick(event) {
        this.icon = 'action:approval';
        const selectedEvent = new CustomEvent('selected', {detail : {recordSelected: this.searchResultId}});
        this.dispatchEvent(selectedEvent);
    }

}