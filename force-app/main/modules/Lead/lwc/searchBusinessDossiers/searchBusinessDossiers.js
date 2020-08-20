/**
 * Created by vishalshete on 10/08/2020.
 */

import {LightningElement, track, wire, api} from 'lwc';
import searchDutchBusinessDossiers from '@salesforce/apex/SearchBusinessDossiersController.searchDutchBusinessDossiers';
import {FlowAttributeChangeEvent, FlowNavigationBackEvent, FlowNavigationNextEvent,
    FlowNavigationPauseEvent, FlowNavigationFinishEvent} from 'lightning/flowSupport';

import {ToastEventController} from "c/toastEventController";
import Loading from '@salesforce/label/c.Loading';
import CurrentlyShowing from '@salesforce/label/c.Currently_showing';
import Records from '@salesforce/label/c.Record';
import Error from '@salesforce/label/c.Error';
import Cancel from '@salesforce/label/c.Cancel';
import Success from '@salesforce/label/c.Success';
import Previous from '@salesforce/label/c.Previous';
import BusinessDossierqueued from '@salesforce/label/c.Business_Dossier_queued';
import CreateBusinessDossiers from '@salesforce/label/c.Create_Business_Dossiers';
import NorowselectedMessage from '@salesforce/label/c.No_row_selected_Message';
import DuplicateOf from '@salesforce/label/c.Duplicate_of';
import Found from '@salesforce/label/c.Found';
import FastSearch from '@salesforce/label/c.Fast_search';



const columns = [
    {label: 'Dossier Number', fieldName: 'appsolutely__Dossier_Number__c', type: 'number', sortable: false},
    {label: 'Establishment Number', fieldName: 'appsolutely__Establishment_Number__c', type: 'text', sortable: false},
    {label: 'Name', fieldName: 'Name', type: 'text', sortable: false},
    // {label: 'Trade Name Full', fieldName: 'appsolutely__Trade_Name_Full__c', type: 'text', sortable: true},
    {label: 'Establishment City', fieldName: 'appsolutely__Establishment_City__c', type: 'text', sortable: false},
    {label: 'Establishment Street', fieldName: 'appsolutely__Establishment_Street__c', type: 'text', sortable: false},
    {label: 'Correspondence City', fieldName: 'appsolutely__Correspondence_City__c', type: 'text', sortable: false},
    {label: 'Correspondence Street', fieldName: 'appsolutely__Correspondence_Street__c', type: 'text', sortable: false},
    {label: 'Economically Active', fieldName: 'appsolutely__Indication_Economically_Active__c', type: 'boolean', sortable: false},
    {label: 'Existing Business Dossier', fieldName: 'existingDossier', type: 'boolean', sortable: false}
];


export default class SearchBusinessDossiers extends LightningElement {
/*
Input search criteria from search Lwc
*/
    @api searchCriteria;
/*
Datatable columns for showing list of Business dossiers
*/
    columns = columns;

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
     page_x;
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
    @track maxPaqge


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


    label = { Loading,CurrentlyShowing,
        Records,Error, Cancel,
        Previous,CreateBusinessDossiers,Success,
        BusinessDossierqueued,NorowselectedMessage,
        DuplicateOf,Found,FastSearch
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
        if(this.searchCriteria.page_x!=undefined)                   this.page_x = this.searchCriteria.page_x;
        if(this.searchCriteria.provinces!=undefined)                this.provinces = this.searchCriteria.provinces;
        if(this.searchCriteria.sbi_match_type!=undefined)           this.sbi_match_type =this.searchCriteria.sbi_match_type;
        if(this.searchCriteria.max_number_of_results!=undefined)    this.maxRecords =this.searchCriteria.max_number_of_results;
    }

    connectedCallback() {
        this.businessDossiers = [];
        this.validateInput();
        this.makeCallout().catch(error => {
            new ToastEventController(this).showErrorToastMessage(null,error.message);
        }).finally(result=>{this.businessDossiers = this.dossiers});
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
            this.error = e.message;
        }
    }

    handleSelectedRows(selectedRecords){
        try {
            let filteredArray = [];
            filteredArray = selectedRecords.filter(dossier=>
                dossier.existingDossier == false
            );
            this.businessDossiersToInsert = this.unFlattenRecords(filteredArray);

            const navigateNextEvent = new FlowNavigationNextEvent();
            new ToastEventController(this).showSuccessToastMessage(this.label.Success,this.label.Found+' '+ (selectedRecords.length - filteredArray.length)+' '+this.label.DuplicateOf+' '+selectedRecords.length +' '+this.label.BusinessDossierqueued);
            this.dispatchEvent(navigateNextEvent);
        } catch (e){
            this.error = e.message;
        }
    }

     async makeCallout(){
          searchDutchBusinessDossiers({
            "cities": this.cities, "postcodes": this.postcodes,
            "sbiList": this.sbiList, "primary_sbi_only": this.primary_sbi_only,
            "legal_forms": this.legal_forms, "employees_min": this.employees_min,
            "employees_max": this.employees_max, "economically_active": this.economically_active,
            "financial_status": this.financial_status, "changed_since": this.changed_since,
            "new_since": this.new_since, "page_x": this.page_x,
            "provinces": this.provinces, "sbi_match_type": this.sbi_match_type,
       })
        .then(result => {
            if(this.businessDossiers.length==0) {
                let dossierArray = this.flattenRecords(result.businessDossierWrappers);
                this.businessDossiers = dossierArray;
                this.dossiers = dossierArray;
            }
            else {
                let dossierArray = this.flattenRecords(result.businessDossierWrappers);
                this.businessDossiers = this.businessDossiers.concat(dossierArray);
                this.dossiers = this.businessDossiers;
            }
            this.maxPaqge = result.numpages;
            this.page_x = result.curpage;
            this.page_x++
            if( !(this.page_x<=this.maxPaqge)){
                this.page_x = 0;
            }
            this.isLoading = false;
            this.showDatatableSpinner = false;
            Promise.resolve(result);
        })
        .catch(error => {
            this.error = error.message;
            Promise.reject(error);
        })
    }
    handleLoadMore(){
        if(this.dossiers.length<this.maxRecords && this.page_x<= this.maxPaqge){
            this.showDatatableSpinner = true;
            this.makeCallout();
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

    set error(value){
        if (!value) return;
        new ToastEventController(this).showErrorToastMessage(this.label.Error, value );
    }
}