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


import Find_Businesses_Title from '@salesforce/label/c.Find_Businesses_Title';
import BusinessDossierqueued from '@salesforce/label/c.Business_Dossier_queued';
import CreateBusinessDossiers from '@salesforce/label/c.Create_Business_Dossiers';
import NorowselectedMessage from '@salesforce/label/c.No_row_selected_Message';
import DuplicateOf from '@salesforce/label/c.Duplicate_of';
import Found from '@salesforce/label/c.Found';
import Dutch_Business_Dossier_Exists from '@salesforce/label/c.Dutch_Business_Dossier_Exists';

import Business_Dossier_Object from '@salesforce/schema/Business_Dossier__c';


export default class FindBusinessesSearchResults extends LightningElement {

    columns;

    /*
    Input search criteria from search Lwc
    */
    @api searchCriteria;

    /*
    List of all input criteria for Soap service
    */
    cities;
    postcodes;
    sbiList;
    primary_sbi_only;
    legal_forms;
    employees_min;
    employees_max;
    economically_active;
    financial_status;
    changed_since;
    new_since;
    provinces;
    sbi_match_type;

    /*
    Maximum no. of records to show in datatable
    */
    maxRecords=10000;

    /*
    Shows spinner on screen while initial load of data
    */
    @track isLoading = true;

    /*
    Stores list of business dossiers to show on datatable
    */
    @track businessDossiers = [];

    /*
    Stores list of business dossiers as a copy while filtering
    */
    @track dossiers = [];

    /*
    controls enable and disable of infinite loading
    */
    @track enableInfiniteLoading = true;

    /*
    controls spinner on datatable on infinite loading
    */
    showDatatableSpinner = false;

    /*
    controls show hide of cancel button on footer componenet
    */
    showFooterCancelButton = false;

    /*
    Store final list of Business dossiers to insert
    */
    @api businessDossiersToInsert

    /*
     Stores maximum no. of pages found
     */
    @track maxPage = 0;

    /*
     Stores the current number of pages searched
     */
    @track currentPage = 0;


    get isInitializing(){
        return this.isLoading;
    }

    get businessDossierLength(){
        return this.dossiers.length;
    }
    availableFooterActions = [
        'BACK',
        'NEXT'
    ]



    _businessDossierObjectInfo;
    @wire(getObjectInfo, { objectApiName: Business_Dossier_Object })
    businessDossierObjectInfo(response){
        if(response){
            if(response.data){
                this._businessDossierObjectInfo = response.data;
                this.columns = [
                    {label: response.data.fields.Name.label, fieldName: 'Name', type: 'text', sortable: false},
                    {label: response.data.fields.appsolutely__Dossier_Number__c.label, fieldName: 'appsolutely__Dossier_Number__c', type: 'string', sortable: false},
                    {label: response.data.fields.appsolutely__Establishment_Number__c.label, fieldName: 'appsolutely__Establishment_Number__c', type: 'text', sortable: false},
                    {label: response.data.fields.appsolutely__Establishment_City__c.label, fieldName: 'appsolutely__Establishment_City__c', type: 'text', sortable: false},
                    {label: response.data.fields.appsolutely__Establishment_Street__c.label, fieldName: 'appsolutely__Establishment_Street__c', type: 'text', sortable: false},
                    {label: response.data.fields.appsolutely__Indication_Economically_Active__c.label, fieldName: 'appsolutely__Indication_Economically_Active__c', type: 'boolean', sortable: false},
                    {label: this.label.Dutch_Business_Dossier_Exists, fieldName: 'existingDossier', type: 'boolean', sortable: false}
                ];
            }else if(response.error){
                new ToastEventController(this).showErrorToastMessage(null, response.error);
            }
        }
    }

    label = { Loading,CurrentlyShowing,
        Records,Error, Cancel,
        Previous,CreateBusinessDossiers,Success,
        BusinessDossierqueued,NorowselectedMessage,
        DuplicateOf,Found,FastSearch, SearchReset, Find_Businesses_Title, Dutch_Business_Dossier_Exists
    }

    validateInput(){
        if(this.searchCriteria.cities!=undefined)                   this.cities =this.searchCriteria.cities;
        if(this.searchCriteria.postcodes!=undefined)                this.postcodes =this.searchCriteria.postcodes;
        if(this.searchCriteria.sbiList!=undefined)                  this.sbiList =this.searchCriteria.sbiList;
        if(this.searchCriteria.primary_sbi_only!=undefined)         this.primary_sbi_only =this.searchCriteria.primary_sbi_only;
        if(this.searchCriteria.legal_forms!=undefined)              this.legal_forms =this.searchCriteria.legal_forms==undefined;
        if(this.searchCriteria.employees_min!=undefined)            this.employees_min =this.searchCriteria.employees_min;
        if(this.searchCriteria.employees_max!=undefined)            this.employees_max =this.searchCriteria.employees_max;
        if(this.searchCriteria.economically_active!=undefined)      this.economically_active =this.searchCriteria.economically_active;
        if(this.searchCriteria.financial_status!=undefined)         this.financial_status =this.searchCriteria.financial_status;
        if(this.searchCriteria.changed_since!=undefined)            this.changed_since =this.searchCriteria.changed_since;
        if(this.searchCriteria.new_since!=undefined)                this.new_since =this.searchCriteria.new_since;
        if(this.searchCriteria.provinces!=undefined)                this.provinces = this.searchCriteria.provinces;
        if(this.searchCriteria.sbi_match_type!=undefined)           this.sbi_match_type =this.searchCriteria.sbi_match_type;
        if(this.searchCriteria.max_number_of_results!=undefined)    this.maxRecords =this.searchCriteria.max_number_of_results;
    }

    connectedCallback() {
        this.businessDossiers = [];
        this.validateInput();
        this.searchNextPage();
    }

    handleSearchChange(event) {
        let searchString = event.target.value;
        if(!searchString){
            this.businessDossiers = this.dossiers;
            this.enableInfiniteLoading = true;
        } else{
            searchString = searchString.toLowerCase();
            this.businessDossiers = this.dossiers.filter(dossier=>
                dossier.appsolutely__Dossier_Number__c.toLowerCase().includes(searchString)||
                dossier.appsolutely__Establishment_Number__c.toLowerCase().includes(searchString)||
                dossier.Name.toLowerCase().includes(searchString)
            );
            this.enableInfiniteLoading = false;
        }
    }
    handleRowSelection(event) {
        this.selectedRows = event.target.getSelectedRows();
    }
    handleFooterNextClick(event){
        try {
            //this.selectedRows = event.target.getSelectedRows();
            if(!this.selectedRows){
                new ToastEventController(this).showErrorToastMessage(this.label.Error, this.label.NorowselectedMessage);
            }
            else {
                this.handleSelectedRows(this.selectedRows);
            }
        } catch (e){
            new ToastEventController(this).showErrorToastMessage(this.label.Error, e);
        }
    }

    handleSelectedRows(selectedRecords){
        try {
            let filteredArray = [];
            filteredArray = selectedRecords.filter(dossier=>
                dossier.existingDossier == false
            );
            this.businessDossiersToInsert = this.unFlattenRecords(filteredArray);

            const attributeChangeEvent = new FlowAttributeChangeEvent('businessDossiersToInsert', this.businessDossiersToInsert );
            this.dispatchEvent(attributeChangeEvent);
            const navigateNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(navigateNextEvent);
        } catch (e){
            new ToastEventController(this).showErrorToastMessage(this.label.Error, e);
        }
    }

    searchNextPage(){
        this.searchBusinesses()
            .then((result)=>{
                this.businessDossiers = this.businessDossiers.concat(result);
                this.dossiers = this.businessDossiers;
                this.isLoading = false;
                this.showDatatableSpinner = false;
            })
            .catch(error => {
                new ToastEventController(this).showErrorToastMessage(null,error.message);
            });
    }
    async searchBusinesses(){
        let payload = {
            cities : this.cities,
            postcodes: this.postcodes,
            sbiList: this.sbiList,
            primary_sbi_only: this.primary_sbi_only,
            legal_forms: this.legal_forms,
            employees_min: this.employees_min,
            employees_max: this.employees_max,
            economically_active: this.economically_active,
            financial_status: this.financial_status,
            changed_since: this.changed_since,
            new_since: this.new_since,
            page_x: this.currentPage + 1,
            provinces: this.provinces,
            sbi_match_type: this.sbi_match_type,
        }
        return searchDutchBusinessDossiers(payload)
            .then((result) => {
                this.maxPage = result.numpages;
                this.currentPage = result.curpage;
                let dossierArray = this.flattenRecords(result.businessDossierWrappers);
                return dossierArray;
            })
            .catch((error) => {
                new ToastEventController(this).showErrorToastMessage(this.label.Error, error);
                return error;
            })
    }

    handleLoadMore(){
        if(this.dossiers.length < this.maxRecords && this.currentPage < this.maxPage){
            this.showDatatableSpinner = true;
            this.searchNextPage();
        } else{
            this.enableInfiniteLoading = false;
        }
    }
    //below function flatten the nested data
    flattenRecords(wrappers){
        if(wrappers) {
            let dossierArray = []
            wrappers.forEach(wrapper => {
                let data= {};
                data.appsolutely__Dossier_Number__c = wrapper.businessDossier.appsolutely__Dossier_Number__c;
                data.appsolutely__Establishment_Number__c = wrapper.businessDossier.appsolutely__Establishment_Number__c;
                data.Name = wrapper.businessDossier.Name;
                data.appsolutely__Trade_Name_Full__c = wrapper.businessDossier.appsolutely__Trade_Name_Full__c;
                data.appsolutely__Establishment_City__c = wrapper.businessDossier.appsolutely__Establishment_City__c;
                data.appsolutely__Establishment_Street__c = wrapper.businessDossier.appsolutely__Establishment_Street__c;
                data.appsolutely__Correspondence_City__c = wrapper.businessDossier.appsolutely__Correspondence_City__c;
                data.appsolutely__Correspondence_Street__c = wrapper.businessDossier.appsolutely__Correspondence_Street__c;
                data.appsolutely__Indication_Economically_Active__c = wrapper.businessDossier.appsolutely__Indication_Economically_Active__c;
                data.existingDossier = wrapper.existingDossier;
                dossierArray.push(data);
            })
            return dossierArray;
        }
    }
    unFlattenRecords(wrappers){
        if(wrappers) {
            let dossierArray = []
            wrappers.forEach(wrapper => {
                let data= {};
                data.appsolutely__Dossier_Number__c = wrapper.appsolutely__Dossier_Number__c;
                data.appsolutely__Establishment_Number__c = wrapper.appsolutely__Establishment_Number__c;
                data.Name = wrapper.Name;
                data.appsolutely__Trade_Name_Full__c = wrapper.appsolutely__Trade_Name_Full__c;
                data.appsolutely__Establishment_City__c = wrapper.appsolutely__Establishment_City__c;
                data.appsolutely__Establishment_Street__c = wrapper.appsolutely__Establishment_Street__c;
                data.appsolutely__Correspondence_City__c = wrapper.appsolutely__Correspondence_City__c;
                data.appsolutely__Correspondence_Street__c = wrapper.appsolutely__Correspondence_Street__c;
                data.appsolutely__Indication_Economically_Active__c = wrapper.appsolutely__Indication_Economically_Active__c;
                dossierArray.push(data);
            })
            return dossierArray;
        }

    }
}