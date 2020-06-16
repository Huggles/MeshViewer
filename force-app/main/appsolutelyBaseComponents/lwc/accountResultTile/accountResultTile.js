/**
 * Created by tejaswinidandi on 12/06/2020.
 */

import {LightningElement, api, track, wire} from 'lwc';
import Update_Duplicate_Account from '@salesforce/label/c.Update_Duplicate_Account';
import getFieldSetFieldDescriptions from '@salesforce/apex/FieldSetHelper.getFieldSetFieldDescriptions';
import {fireEvent} from "c/pubsub";

export default class AccountResultTile extends LightningElement {

    // /**
    //  * The field containing the title of the card. Defaults to Name
    //  */
    // @api
    // titleField = 'Name';
    //
    // /**
    //  * An object containing a data structure with a label and a field
    //  */
    // @api
    // labelsAndFields;
    //
    // @api
    // searchResultId;
    //
    // @api
    // object;
    //
    // @api
    // ourKey;

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
    // @wire(getFieldSetFieldDescriptions, {objectName: 'Account', fieldSetName: 'appsolutely__Account_Duplicate_Results_Field_Set'})
    @api labelsAndFields;

    // get title() {
    //     return this.searchResult[this.titleField];
    // }

    @api title;

    m_test;
    @api
    get doRender11(){
        // if (this.labelsAndFields.data && this.searchResult) {
        //     this.labelsAndFields.data.forEach((value, index) => this.fieldValues.push({index: index, label: value.label, value: this.searchResult[value.apiName]}));
        // }
    }
    set doRender11(value) {
        this.m_test = value;
        console.log(this.m_test);
    }

    /**
     * Returns the values of the fields in the fieldset with the given fieldsetname
     */
    @api
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
        const cardClickedEvent = new CustomEvent('cardclicked', {detail : {id: this.searchResult}});
        this.dispatchEvent(cardClickedEvent);
    }

    label = {
        Update_Duplicate_Account
    }

    handleClickDuplicateAccount() {
        fireEvent(null, 'updateAccount', null);
    }

}