/**
 * Created by jaapbranderhorst on 03/03/2020.
 */

import {LightningElement, api, track, wire} from 'lwc';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent, FlowNavigationFinishEvent } from 'lightning/flowSupport';
import getFieldSetFieldDescriptions from '@salesforce/apex/FieldSetHelper.getFieldSetFieldDescriptions';
import {fireEvent} from "c/pubsub";

import searchResultsLimitedCL from '@salesforce/label/c.Search_Results_Limited';

export default class SearchResultTilesList extends LightningElement {
    @api
    availableActions = [];

    /**
     * The search results to be displayed
     */
    @api
    searchResults;

    /**
     * The search result selected.
     * TODO: support multiple select
     */
    @api
    selectedResult;

    /**
     * The namespaced api name of the sObject (for instance 'appsolutely__Business_Dossier__c')
     */
    @api
    sObjectName;

    /**
     * The namespaced api name of the fieldset (for instance 'appsolutely__Dutch_Business')
     */
    @api
    fieldSetName;

    /**
     * The title of the search result tile. Defaults to the Name of the sObject
     */
    @api
    title;


    /**
     * Lazy Loading Attributes
     */
    maxNumberOfResults = 30;
    numberOfResultsIncrement = 9;
    numberOfResults = this.numberOfResultsIncrement;
    searchResultsLimited = {
        searchResultsLimitedCL
    }

    @api
    get lazyloadedSearchResults() {
        return this.searchResults.slice(0,this.numberOfResults);
    }
    /**
     * True when the number of results displayed is limited by maxNumberOfResults.
     */
    get displayingMaxNumberOfResults(){
        return (
            this.numberOfResults == this.maxNumberOfResults &&
            this.numberOfResults < this.searchResults.length);
    }

    /**
     * Local key attributes
     */
    localKey = -1;
    get ourKey()
    {
        this.localKey++;
        return this.localKey;
    }

    /**
     * The error message to be shown as toast.
     */
    @track
    error;



    /**
     * Loads the label/fieldname combination from the fieldset
     */
    @wire(getFieldSetFieldDescriptions, {objectName: '$sObjectName', fieldSetName: '$fieldSetName'})
    labelsAndFields;

    /**
     * Handler to handle the selection of a search result.
     * @param event
     */
    handleCardClicked(event) {
        // search for the right record
        const id = event.detail.id;
        const searchResultTiles = [...this.template.querySelectorAll('c-search-result-tile')];
        let tileClicked = searchResultTiles.find(card => card.searchResultId === id);
        // (un)select the cards
        if (!tileClicked.selected) { // current 'old' state is unselected, user wants to select this card
            const unselectedTiles = searchResultTiles.filter(value => value !== tileClicked);
            unselectedTiles.forEach(value => value.selected = false);
            // set the result param, this is done here because this component knows the type
            const attributeChangeEvent = new FlowAttributeChangeEvent('selectedResult', tileClicked.searchResult);
            this.dispatchEvent(attributeChangeEvent);
            fireEvent(null, 'resultselected', {selectedResult: event.detail.recordSelected}); // let the world know something is selected
        } else {
            const attributeChangeEvent = new FlowAttributeChangeEvent('selectedResult', null);
            this.dispatchEvent(attributeChangeEvent);
            fireEvent(null, 'resultunselected');
        }
        tileClicked.selected = !tileClicked.selected; // select or unselect the card
    }
    resultsScrolled(event){
        var element = event.target;
        if (element.scrollHeight - element.scrollTop === element.clientHeight)
        {
            if((this.numberOfResults + this.numberOfResultsIncrement) < this.maxNumberOfResults){
                this.numberOfResults += this.numberOfResultsIncrement;
            }else{
                this.numberOfResults = this.maxNumberOfResults;
            }

        }


    }

    handleError(event) {
        this.error = event.detail.error;
    }

}
