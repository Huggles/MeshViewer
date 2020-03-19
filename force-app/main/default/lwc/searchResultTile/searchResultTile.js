/**
 * Created by jaapbranderhorst on 19/02/2020.
 */

import {LightningElement, api, track} from 'lwc';

export default class SearchResultTile extends LightningElement {

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
     * The field containing the title of the card. Defaults to Name
     */
    @api
    titleField = 'Name';

    /**
     * An object containing a data structure with a label and a field
     */
    @api
    labelsAndFields;

    get title() {
        return this.searchResult[this.titleField];
    }

    connectedCallback() {
        if (this.labelsAndFields.data) {
            this.labelsAndFields.data.forEach((value, index) => this.fieldValues.push({index: index, label: value.label, value: this.searchResult[value.apiName]}));
        }
    }

    /**
     * Returns the values of the fields in the fieldset with the given fieldsetname
     */
    @track
    fieldValues = [];

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

    handleOnClick(event) {
        // this.selected = !this.selected;
        const cardClickedEvent = new CustomEvent('cardclicked', {detail : {id: this.searchResultId}});
        this.dispatchEvent(cardClickedEvent);
    }
}