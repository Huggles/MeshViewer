/**
 * Created by tejaswinidandi on 12/06/2020.
 */

import {LightningElement, api, track, wire} from 'lwc';
import Update_Duplicate_Account from '@salesforce/label/c.Update_Duplicate_Account';
import getFieldSetFieldDescriptions from '@salesforce/apex/FieldSetHelper.getFieldSetFieldDescriptions';
import {fireEvent} from "c/pubsub";

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AccountResultTile extends LightningElement {
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
    labelsAndFields;
    @wire(getFieldSetFieldDescriptions, {objectName: 'Account', fieldSetName: 'appsolutely__Account_Duplicate_Results_Field_Set'})
    w_labelsAndFields(response){
        if(response.data != null){
            this.labelsAndFields = response;
            this.loadTile();
        }
        if(response.error != null){
            this.showToast('Error', response.error.body.message, 'error');
        }
    }

    m_searchResultTileComponent;
    loadTile(){
        if (this.labelsAndFields != null &&
            this.labelsAndFields.data != null &&
            this.searchResult != null) {
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
    // get title() {
    //     return this.searchResult[this.titleField];
    // }
    @api title;


    /**
     * Returns the values of the fields in the fieldset with the given fieldsetname
     */
    @track fieldValues = [];

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

    labels = {
        Update_Duplicate_Account
    }

    handleOnClick(event) {
        // this.selected = !this.selected;
        const cardClickedEvent = new CustomEvent('cardclicked', {detail : {id: this.searchResult}});
        this.dispatchEvent(cardClickedEvent);
    }



    handleClickDuplicateAccount() {
        fireEvent(null, 'updateAccount', null);
    }

}