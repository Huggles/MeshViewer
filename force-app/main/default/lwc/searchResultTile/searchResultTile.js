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


    _checkboxHidden = false;
    /**
     * To hide the checkbox or not.
     */
    @api
    get checkboxHidden(){
        let response = this._checkboxHidden;
        return response;
    }
    set checkboxHidden(value){
        if((typeof value) === "string"){
            //This property passed as an DOM attribute is a string.
            this._checkboxHidden = (value === "true");
        }else if((typeof value) === "boolean"){
            this._checkboxHidden = value;
        }
    }


    /**
     * Returns the values of the fields in the fieldset with the given fieldsetname
     */
    @api fieldValues = [];

    _selected;
    _checkboxElement;

    /**
     * True if the card is selected, otherwise false
     */
    @api
    get selected() {
        return this._selected;
    }
    set selected(value) {
        this._selected = value;
        if (this._checkboxElement != null) {
            this._checkboxElement.checked = value;
        }
    }

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

    handleOnClick(event) {
        const cardClickedEvent = new CustomEvent('cardclicked', {detail : {id: this.searchResultId}});
        this.dispatchEvent(cardClickedEvent);
    }


    renderedCallback() {
        this.initCheckbox();
    }
    initCheckbox(){
        this._checkboxElement = this.template.querySelector('[name="card-selected"]');
        if(this._checkboxElement != null){
            this._checkboxElement.checked = this.selected;
        }
    }

}