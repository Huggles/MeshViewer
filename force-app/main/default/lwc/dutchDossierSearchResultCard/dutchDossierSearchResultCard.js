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
    @track
    icon = 'action:record';

    /**
     * The title of the card
     */
    @track
    title = 'searchResult.Name + searchResult.Dossier_Number + searchResult.Establishment_Number';

    handleOnClick(event) {
        this.icon = 'action:approval';
        const selectedEvent = new CustomEvent('selected', {detail : {recordSelected: this.searchResultId}});
        this.dispatchEvent(selectedEvent);
    }
}