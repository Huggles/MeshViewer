/**
 * Created by Hugo on 25/08/2020.
 */
import {LightningElement, track, wire, api} from 'lwc';
import searchDutchBusinessDossiers from '@salesforce/apex/SearchBusinessDossiersController.searchDutchBusinessDossiers';
import {FlowAttributeChangeEvent, FlowNavigationBackEvent, FlowNavigationNextEvent,
    FlowNavigationPauseEvent, FlowNavigationFinishEvent} from 'lightning/flowSupport';

import {ToastEventController} from "c/toastEventController";
import { getObjectInfo } from 'lightning/uiObjectInfoApi';


import Loading from '@salesforce/label/c.Loading';
import CurrentlyShowing from '@salesforce/label/c.Currently_showing';
import Records from '@salesforce/label/c.Record';
import Error from '@salesforce/label/c.Error';
import Cancel from '@salesforce/label/c.Cancel';
import Success from '@salesforce/label/c.Success';
import Previous from '@salesforce/label/c.Previous';
import FastSearch from '@salesforce/label/c.Fast_search';
import SearchReset from '@salesforce/label/c.Search_Reset';

import DuplicateOf from '@salesforce/label/c.Duplicate_of';
import Found from '@salesforce/label/c.Found';
import Find_Dutch_Businesses_Title from '@salesforce/label/c.Find_Dutch_Businesses_Title';
import BusinessDossierqueued from '@salesforce/label/c.Business_Dossier_queued';
import CreateBusinessDossiers from '@salesforce/label/c.Create_Business_Dossiers';
import NorowselectedMessage from '@salesforce/label/c.No_row_selected_Message';
import Dutch_Business_Dossier_Exists from '@salesforce/label/c.Dutch_Business_Dossier_Exists';

import Business_Dossier_Object from '@salesforce/schema/Business_Dossier__c';


export default class FindBusinessesSearchResults extends LightningElement {

    label = { Loading,CurrentlyShowing,
        Records,Error, Cancel,
        Previous,CreateBusinessDossiers,Success,
        BusinessDossierqueued,NorowselectedMessage,
        DuplicateOf,Found,FastSearch, SearchReset, Find_Dutch_Businesses_Title, Dutch_Business_Dossier_Exists
    }

    /*
    Input search criteria from search Lwc
    */
    @api searchCriteria;

    /*
    Maximum no. of records to show in datatable
    */
    maxRecords=10000;

    /*
    Shows spinner on screen while initial load of data
    */
    @track isLoading = false;

    /*
    Stores map of business dossiers
    */
    @track businessDossiers = {};

    /*
    Calculates list of business dossiers to show on datatable
    */
    get businessDossiersArray(){
        console.log(JSON.parse(JSON.stringify(this.businessDossiers)));
        let returnArray = [];
        for (const [key, value] of Object.entries(this.businessDossiers)) {
            returnArray.push(value);
        }
        return returnArray;
    }

    /*
    Stores map of business dossiers during search
    */
    @track matchingDossiers = {};

    /*
    Calculates list of business dossiers to show on search
    */
    get matchingDossiersArray(){
        let returnArray = [];
        for (const [key, value] of Object.entries(this.matchingDossiers)) {
            returnArray.push(value);
        }
        return returnArray;
    }

    /*
   The dossiers to display, depending on the state of the view.
   */
    get dossiersToDisplay(){
        if(this.isSearching){
            return this.matchingDossiersArray;
        }else{
            return this.businessDossiersArray;
        }

    }

    /*
  Whether the view is in a searching state
  */
    isSearching = false;

    /*
    controls enable and disable of infinite loading
    */
    @track infiniteLoadingEnabled = true;

    /*
    True when more records are being loaded.
    */
    isLoadingMoreRecords = false;

    /*
    controls show hide of cancel button on footer componenet
    */
    showFooterCancelButton = false;

    /*
     Stores maximum no. of pages found
     */
    @track maxPage = 0;

    /*
     Stores the current number of pages searched
     */
    @track currentPage = 0;



    connectedCallback() {
        this.businessDossiers = {};
        this.matchingDossiers = {};
        this.maxRecords = this.searchCriteria.max_number_of_results != null ? this.searchCriteria.max_number_of_results : this.maxRecords;
        this.isLoading = true;
        this.searchNextPage();
    }

    businessDossierFieldInfo;
    @wire(getObjectInfo, { objectApiName: Business_Dossier_Object })
    retrievebusinessDossierObjectInfo(response){
        if(response){
            if(response.data){
                this.businessDossierFieldInfo = response.data.fields;
            }else if(response.error){
                new ToastEventController(this).showErrorToastMessage(null, response.error);
            }
        }
    }

    /*
     * Search Company.Info Functions
     */
    handleLoadMore(){
        if(this.businessDossiersArray.length < this.maxRecords && this.currentPage < this.maxPage && this.isLoadingMoreRecords === false){
            this.isLoadingMoreRecords = true;
            this.searchNextPage();
        } else{
            this.enableInfiniteLoading = false;
        }
    }
    searchNextPage(){
        this.searchBusinesses()
            .then((result)=>{
                Object.assign(this.businessDossiers, result);
            })
            .catch(error => {
                this.businessDossiers = {};
                console.log('a');
                console.log(JSON.parse(JSON.stringify(this.businessDossiers)));
                new ToastEventController(this).showErrorToastMessage(this.label.Error, error);
            })
            .finally(()=>{
                this.isLoading = false;
                this.isLoadingMoreRecords = false;
            })
    }
    async searchBusinesses(){
        let payload = {
            cities : this.searchCriteria.cities,
            postcodes: this.searchCriteria.postcodes,
            sbiList: this.searchCriteria.sbiList,
            primary_sbi_only: this.searchCriteria.primary_sbi_only,
            legal_forms: this.searchCriteria.legal_forms,
            employees_min: this.searchCriteria.employees_min,
            employees_max: this.searchCriteria.employees_max,
            economically_active: this.searchCriteria.economically_active,
            financial_status: this.searchCriteria.financial_status,
            changed_since: this.searchCriteria.changed_since,
            new_since: this.searchCriteria.new_since,
            provinces: this.searchCriteria.provinces,
            sbi_match_type: this.searchCriteria.sbi_match_type,
            page_x: this.currentPage + 1,
        }
        return searchDutchBusinessDossiers(payload)
            .then((result) => {
                this.maxPage = result.numpages;
                this.currentPage = result.curpage;
                let dossierArray = this.processResults(result.businessDossierWrappers);
                return dossierArray;
            })
            .catch((error) => {
                new ToastEventController(this).showErrorToastMessage(this.label.Error, error);
            })
    }
    //below function flatten the nested data
    processResults(wrappers){
        if(wrappers) {
            let dossierArray = {};
            wrappers.forEach(wrapper => {
                let data= {};
                data.name = wrapper.businessDossier.Name;
                data.appsolutely__Dossier_Number__c = wrapper.businessDossier.appsolutely__Dossier_Number__c;
                data.appsolutely__Establishment_Number__c = wrapper.businessDossier.appsolutely__Establishment_Number__c;
                data.appsolutely__Trade_Name_Full__c = wrapper.businessDossier.appsolutely__Trade_Name_Full__c;
                data.appsolutely__Establishment_City__c = wrapper.businessDossier.appsolutely__Establishment_City__c;
                data.appsolutely__Establishment_Street__c = wrapper.businessDossier.appsolutely__Establishment_Street__c;
                data.appsolutely__Correspondence_City__c = wrapper.businessDossier.appsolutely__Correspondence_City__c;
                data.appsolutely__Correspondence_Street__c = wrapper.businessDossier.appsolutely__Correspondence_Street__c;
                data.appsolutely__Indication_Economically_Active__c = wrapper.businessDossier.appsolutely__Indication_Economically_Active__c;
                data.appsolutely__Indication_Economically_Active__c = wrapper.businessDossier.appsolutely__Indication_Economically_Active__c;
                data.existingDossier = wrapper.existingDossier;
                data.recordId = wrapper.existingDossierId;
                data.selected = false;

                let rowIdentifier = data.appsolutely__Dossier_Number__c+data.appsolutely__Establishment_Number__c;
                data['rowId'] = rowIdentifier;

                dossierArray[rowIdentifier] = data;
            })
            console.log(JSON.parse(JSON.stringify(dossierArray)));
            return dossierArray;
        }
    }

    /*
     * Table Functions
     */
    get hasRecords(){
        console.log('hasRecords');
        console.log(this.businessDossiersArray.length);
        if(this.businessDossiersArray.length > 0) return true;
        return false;
    }
    get businessDossierLength(){
        return this.businessDossiersArray.length;
    }
    handleSearchChange(event) {
        let searchString = event.target.value;
        if(searchString != null && searchString.length > 0){
            this.isSearching = true;
            this.infiniteLoadingEnabled = false;
            searchString = searchString.toLowerCase();

            let matchingResults = {};
            for (const [key, value] of Object.entries(this.businessDossiers)) {
                if(value.appsolutely__Dossier_Number__c.toLowerCase().includes(searchString)||
                    value.appsolutely__Establishment_Number__c.toLowerCase().includes(searchString)||
                    value.name.toLowerCase().includes(searchString)){
                    matchingResults[key] = value;
                }
            }
            this.matchingDossiers = matchingResults;
        }else{
            this.isSearching = false;
            this.infiniteLoadingEnabled = true;

        }
    }

    handleRowSelected(event){
        let dossierId = event.target.dataset['identifier'];
        let checked = event.target.checked;
        this.setDossierSelected(dossierId, checked);

    }
    handleAllRowsSelected(event){
        let checked = event.target.checked;
        if(this.isSearching){
            for (const [key, value] of Object.entries(this.matchingDossiers)) {
                this.setDossierSelected(key,checked);
            }
        }else {
            for (const [key, value] of Object.entries(this.businessDossiers)) {
                this.setDossierSelected(key,checked);
            }
        }

    }
    setDossierSelected(dossierId, selected){
        this.businessDossiers[dossierId].selected = selected;
        if(selected == false){
            this.template.querySelector('[data-identifier="selectAllCheckbox"]').checked = false;
        }
    }
    onTableScroll(event){
        let resultTableElement = this.template.querySelector('[data-identifier="resultTable"]');
        let resultTableContainerElement = this.template.querySelector('[data-identifier="resultTableContainer"]');
        if (resultTableContainerElement.offsetHeight + resultTableContainerElement.scrollTop >= resultTableElement.scrollHeight) {
            if(this.infiniteLoadingEnabled){
                // element is at the end of its scroll, load more content
                this.handleLoadMore();
            }
        }
    }



    /*
     * Footer Functions
     */


    /*
    Store final list of Business dossiers to insert
    */
    @api businessDossiersToInsert;

    get selectedRows(){
        let selectedRows = [];
        for (const [key, value] of Object.entries(this.businessDossiers)) {
            if(value.selected){
                selectedRows.push(value);
            }
        }
        return selectedRows;
    }

    availableFooterActions = [
        'BACK',
        'NEXT'
    ]

    handleFooterNextClick(event){
        try {
            if(this.selectedRows.length == 0){
                new ToastEventController(this).showErrorToastMessage(this.label.Error, this.label.NorowselectedMessage);
            }
            else {
                this.businessDossiersToInsert = this.createBusinessDossiers(this.selectedRows);
                const attributeChangeEvent = new FlowAttributeChangeEvent('businessDossiersToInsert', this.businessDossiersToInsert );
                this.dispatchEvent(attributeChangeEvent);
                const navigateNextEvent = new FlowNavigationNextEvent();
                this.dispatchEvent(navigateNextEvent);
            }
        } catch (e){
            new ToastEventController(this).showErrorToastMessage(this.label.Error, e);
        }
    }

    processSelectedRows(selectedRecords){
        try {

            return this.businessDossiersToInsert;
        } catch (e){
            new ToastEventController(this).showErrorToastMessage(this.label.Error, e);
        }
    }
    createBusinessDossiers(rows){
        if(rows != null) {
            let dossierArray = []
            rows.forEach(row => {
                let data= {};
                if(row.recordId != null){
                    data.Id = row.recordId;
                }
                data.Name = row.name;
                data.appsolutely__Dossier_Number__c =                   row.appsolutely__Dossier_Number__c;
                data.appsolutely__Establishment_Number__c =             row.appsolutely__Establishment_Number__c;
                data.appsolutely__Trade_Name_Full__c =                  row.appsolutely__Trade_Name_Full__c;
                data.appsolutely__Establishment_City__c =               row.appsolutely__Establishment_City__c;
                data.appsolutely__Establishment_Street__c =             row.appsolutely__Establishment_Street__c;
                data.appsolutely__Correspondence_City__c =              row.appsolutely__Correspondence_City__c;
                data.appsolutely__Correspondence_Street__c =            row.appsolutely__Correspondence_Street__c;
                data.appsolutely__Indication_Economically_Active__c =   row.appsolutely__Indication_Economically_Active__c;
                dossierArray.push(data);
            })
            return dossierArray;
        }
    }
}