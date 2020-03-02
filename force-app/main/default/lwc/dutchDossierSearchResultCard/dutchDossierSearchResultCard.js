/**
 * Created by jaapbranderhorst on 19/02/2020.
 */

import {LightningElement, api, track, wire} from 'lwc';
import getFieldSetFieldDescriptions from '@salesforce/apex/FieldSetHelper.getFieldSetFieldDescriptions';

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
     * The api name of the fieldset
     */
    @api
    fieldSetName = 'appsolutely__Dutch_Business';

    /**
     * The api name of the sObject (appsolutely__Business_Dossier__c)
     */
    @api
    sObjectName = 'appsolutely__Business_Dossier__c';

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