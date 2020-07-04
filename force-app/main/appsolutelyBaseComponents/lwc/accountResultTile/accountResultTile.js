/**
 * Created by tejaswinidandi on 12/06/2020.
 */

import {LightningElement, api, track, wire} from 'lwc';
import Update_Duplicate_Account from '@salesforce/label/c.Update_Duplicate_Account';
import {fireEvent} from "c/pubsub";

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AccountResultTile extends LightningElement {
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
     * True if the card is selected, otherwise false
     */
    @api
    selected;

    labels = {
        Update_Duplicate_Account
    }

    handleOnClick(event) {
        const cardClickedEvent = new CustomEvent('cardclicked', {detail : {id: this.searchResultId}});
        this.dispatchEvent(cardClickedEvent);
    }

    handleClickDuplicateAccount() {
        fireEvent(null, 'updateAccount', null);
    }

}