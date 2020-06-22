/**
 * Created by tejaswinidandi on 12/06/2020.
 */

import {LightningElement, api, track, wire} from 'lwc';
import {FlowAttributeChangeEvent, FlowNavigationNextEvent, FlowNavigationFinishEvent} from 'lightning/flowSupport';
import getFieldSetFieldDescriptions from '@salesforce/apex/FieldSetHelper.getFieldSetFieldDescriptions';
import {fireEvent} from "c/pubsub";

import searchResultsLimitedCL from '@salesforce/label/c.Search_Results_Limited';
import searchNoResultsCL from '@salesforce/label/c.Search_No_Results';

import DESERT_ILLUSTRATION from '@salesforce/resourceUrl/Desert';
import {ShowToastEvent} from "lightning/platformShowToastEvent";

export default class SearchResultTilesList extends LightningElement {
    @api
    availableActions = [];

    /**
     * Illustration initialization
     */
    desertIllustration = DESERT_ILLUSTRATION + '#desert';

    /**
     * Label for when no results have been found.
     */
    noDataLabel = searchNoResultsCL;

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
     * The field containing the title of the card. Defaults to Name
     */
    @api
    titleField = 'Name';

    get searchCriteriaName() {
        let criteriaName = '';
        if (this.searchResults && this.searchResults.length > 0) {
            criteriaName = 'Results by ' + this.searchResults[0].appsolutely__Search_Criteria_Name__c;
        }
        return criteriaName;
    }

    /**
     * The search results to be displayed
     */
    @api searchResults;

    /**
     * Are there any results?
     */
    get hasResults() {
        if(this.searchResults == null || this.searchResults == undefined){
            return false;
        }
        if(this.searchResults.length == 1  &&
            this.searchResults[0].appsolutely__Matchrate__c != null &&
            this.searchResults[0].appsolutely__Matchrate__c == 0){
            //Company info returns the info from the request with a matchrate of 0 when no results are found.
            //We do not want to show that as an actual result.
            return false;
        }
        return true;
    }

    /**
     *
     * @returns true if search criteria name is undefined
     */
    get isSearchCriteriaNameEmpty() {
        if (this.searchResults[0].appsolutely__Search_Criteria_Name__c) {
            return false;
        }
        else
            return true;
    }

    /**
     * Local key attributes
     */
    localKey = -1;

    get ourKey() {
        this.localKey++;
        return this.localKey;
    }

    /**
     * Loads the label/fieldname combination from the fieldset
     */
    @api labelsAndFields;

    renderedCallback() {
        //we get the labels and fields in the rendered callback because we want to fill in the 'fieldValues' property for each tile.
        //the server call is only done once when the component is rendered
        getFieldSetFieldDescriptions({objectName: this.sObjectName, fieldSetName: this.fieldSetName})
            .then(result =>{
                this.labelsAndFields = result;
                this.fillSearchResults();
            }).catch(error =>{
                this.showToast(e);
        });
    }

    fillSearchResults() {
        if (this.searchResults) {
            const tiles = this.querySelectorAll('[data-name="tile"]');
            if (tiles != null && tiles.length > 0) {
                tiles.forEach((tile, index) => {
                    try {
                        let fieldValues = [];
                        tile.labelsAndFields = this.labelsAndFields;
                        tile.searchResult = this.searchResults[index];
                        tile.searchResultId = index;
                        tile.titleField = this.titleField;
                        tile.title = tile.searchResult[this.titleField];
                        this.labelsAndFields.forEach((value, index) => {
                            let fieldValue =  {index: index, label: value.label, value: tile.searchResult[value.apiName]};
                            fieldValues.push(fieldValue);
                        });
                        tile.fieldValues = fieldValues;
                    }
                    catch (e) {
                        this.showToast(e);
                    }
                });
            }
        }
    }

    showToast(error) {
        const event = new ShowToastEvent({
            message: error,
            variant: 'error'
        });
        component.dispatchEvent(event);
    }

}
