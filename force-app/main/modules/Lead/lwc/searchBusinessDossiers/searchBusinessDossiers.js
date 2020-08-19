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


export default class SearchBusinessDossiers extends LightningElement {


    @api searchCriteria;

    @api cities;
    @api postcodes;
    @api sbiList;
    @api primary_sbi_only;
    @api legal_forms;
    @api employees_min;
    @api employees_max;
    @api economically_active;
    @api financial_status;
    @api changed_since;
    @api new_since;
    @track page_x;
    @api provinces;
    @api sbi_match_type;

    @track maxRecords=200;
    @track isLoading = true;
    @track businessDossiers = [];
    @track dossiers = [];

    get isInitializing(){
        return this.isLoading;
    }
    availableFooterActions = [
        'BACK',
        'NEXT'
    ]
    showFooterCancelButton = false;

    label = { Loading,CurrentlyShowing,
        Records,Error, Cancel,
        Previous,CreateBusinessDossiers,Success,
        BusinessDossierqueued
    }
    searchString;
    handleChange(event) {
        if (event.target.name === 'cities') {
            this.searchString = event.target.value;

            this.template.querySelector("c-show-business-dossier-data-table").fastFilter(this.searchString);
        }
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
    get businessDossierLength(){
        return this.dossiers.length;
    }
    handleClick(){
        this.template.querySelector('c-show-business-dossier-data-table').createDossiers();
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

                this.businessDossiers = dossierArray;//this.dossierData;
                this.dossiers = dossierArray;//this.dossierData;//result.businessDossiers;
            }
            else {
                let dossierArray = this.flattenRecords(result.businessDossierWrappers);
                this.dossiers = this.dossiers.concat(dossierArray);//this.dossierData;//result.businessDossiers;

            }
            let totalPage = result.numpages;
            this.page_x = result.curpage;
            this.page_x++
            if( !(this.page_x<=totalPage)){
                this.page_x = 0;
            }
            this.isLoading = false;
            if(this.dossiers.length<this.maxRecords){
                this.makeCallout();
            } else{
                this.businessDossiers = [];
                this.businessDossiers = this.dossiers;
            }
            //stop showing initial spinner
            Promise.resolve(result);
        })
        .catch(error => {
            this.error = error;
            Promise.reject(error);
        })
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
        new ToastEventController(this).showErrorToastMessage(this.label.Error, this.label.Error, value );
    }
    @api businessDossiersToInsert

    handleSelectedRows(event){
        try {
            let selectedRecords = event.detail;
            if(!selectedRecords)
                new ToastEventController(this).showErrorToastMessage(this.label.Error, this.label.Error, value );
            else {
                // let filteredArray = selectedRecords.filter(dossier=>
                //     dossier.existingDossier == false
                // );
                // this.businessDossiersToInsert = this.unFlattenRecords(filteredArray);
                this.businessDossiersToInsert = this.unFlattenRecords(selectedRecords);

                const navigateNextEvent = new FlowNavigationNextEvent();
                new ToastEventController(this).showSuccessToastMessage(this.label.Success,this.label.BusinessDossierqueued );
                this.dispatchEvent(navigateNextEvent);
            }
        } catch (e){
            this.error = e;
        }
    }
    handleFooterNextClick(){
        try {
            this.template.querySelector('c-show-business-dossier-data-table').createDossiers();

        } catch (e){
            this.error = e;
        }
    }
}