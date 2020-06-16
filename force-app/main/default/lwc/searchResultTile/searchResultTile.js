/**
 * Created by jaapbranderhorst on 19/02/2020.
 */

import {LightningElement, api, track} from 'lwc';

import {fireEvent} from "c/pubsub";

export default class SearchResultTile extends LightningElement {

    /**
     * Contains the search result (in fact a business data SObject)
     */
    m_searchResult;
    @api
    get searchResult(){
        return this.m_searchResult;
    }
    set searchResult(value){
        this.m_searchResult = value;
        this.loadTile();
    }

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
        this.loadTile();
    }


    @api
    loadTile(){
        if (this.labelsAndFields != null &&
            this.labelsAndFields.data != null &&
            this.m_searchResult != null) {
            this.labelsAndFields.data.forEach((value, index) => {
                let fieldValue =  {
                    index: index,
                    label: value.label,
                    value: this.m_searchResult[value.apiName]
                };
                this.fieldValues.push(fieldValue);
            });
        }
    }

    /**
     * Returns the values of the fields in the fieldset with the given fieldsetname
     */
    @track
    fieldValues = [];

    /**
     * The icon state to be shown
     */
    get iconState() {
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