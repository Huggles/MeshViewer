/**
 * Created by jaapbranderhorst on 19/02/2020.
 */

import {LightningElement, api, track, wire} from 'lwc';
import getFieldSetFieldDescriptions from '@salesforce/apex/FieldSetHelper.getFieldSetFieldDescriptions';

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
     * The title of the card
     */
    @api
    title

    /**
     * The namespaced api name of the fieldset (for instance 'appsolutely__Dutch_Business')
     */
    @api
    fieldSetName;

    /**
     * The namespaced api name of the sObject (for instance 'appsolutely__Business_Dossier__c')
     */
    @api
    sObjectName;

    /**
     * Loads the fieldset
     */
    @wire(getFieldSetFieldDescriptions, {objectName: '$sObjectName', fieldSetName: '$fieldSetName'})
    loadFieldValues({error, data}) {
        if (data && this.searchResult) {
            data.forEach((value, index) => this.fieldValues.push({index: index, label: value.label, value: this.searchResult[value.apiName]}));
        } else if (error) {
            const errorEvent = new CustomEvent('error', {detail: error});
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