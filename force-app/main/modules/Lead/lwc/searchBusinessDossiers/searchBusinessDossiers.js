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
import Previous from '@salesforce/label/c.Previous';
import CreateBusinessDossiers from '@salesforce/label/c.Create_Business_Dossiers';


export default class SearchBusinessDossiers extends LightningElement {


    @api searchCriteria;

    @api cities='Utrecht';
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
        'NEXT',
        'FINISH'
    ]
    showFooterCancelButton = true;

    label = { Loading,CurrentlyShowing,
        Records,Error, Cancel,
        Previous,CreateBusinessDossiers
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
                this.businessDossiers = result.businessDossiers;
                this.dossiers = result.businessDossiers;
            }
            else {
                this.dossiers =this.dossiers.concat(result.businessDossiers);
                // this.businessDossiers = this.businessDossiers.concat(result.businessDossiers);
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
    set error(value){
        if (!value) return;
        new ToastEventController(this).showErrorToastMessage(this.label.Error, this.label.Error, value );
    }
    @api businessDossiersToInsert

    handleSelectedRows(event){
        try {
            this.businessDossiersToInsert = event.detail;
            if(!this.businessDossiersToInsert)
                new ToastEventController(this).showErrorToastMessage(this.label.Error, this.label.Error, value );
            else {
                const navigateNextEvent = new FlowNavigationNextEvent();
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