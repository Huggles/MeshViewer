/**
 * Created by vishalshete on 10/08/2020.
 */

import {LightningElement, track, wire, api} from 'lwc';
// import searchDutchBusinessDossiers from '@salesforce/apex/SearchBusinessDossiersInvocable.searchDutchBusinessDossiers';
import searchDutchBusinessDossiers from '@salesforce/apex/SearchBusinessDossiersController.searchDutchBusinessDossiers';
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import Loading from '@salesforce/label/c.Loading';

export default class SearchBusinessDossiers extends LightningElement {

    @api cities = 'Utrecht';
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

    @track businessDossiers = [];
    @track isDataTableLoading = false;
    enableInfiniteLoading = true;
    @track isLoading = true;

    get isInitializing(){
        return this.isLoading;
    }

    label = { Loading
    }

    handleChange(event) {
        if (event.target.name === 'cities') {
            this.cities = event.target.value;
        } else if  (event.target.name === 'postcodes') {
            this.postcodes = event.target.value;
        }else if  (event.target.name === 'sbiList') {
            this.sbiList = event.target.value;
        }else if  (event.target.name === 'primary_sbi_only') {
            this.primary_sbi_only = event.target.value;
        }else if  (event.target.name === 'legal_forms') {
            this.legal_forms = event.target.value;
        }else if  (event.target.name === 'employees_min') {
            this.employees_min = event.target.value;
        }else if  (event.target.name === 'employees_max') {
            this.employees_max = event.target.value;
        }else if  (event.target.name === 'economically_active') {
            this.economically_active = event.target.value;
        }else if  (event.target.name === 'financial_status') {
            this.financial_status = event.target.value;
        }else if  (event.target.name === 'changed_since') {
            this.changed_since = event.target.value;
        }else if  (event.target.name === 'new_since') {
            this.new_since = event.target.value;
        }else if  (event.target.name === 'page_x') {
            this.page_x = event.target.value;
        }else if  (event.target.name === 'provinces') {
            this.provinces = event.target.value;
        }else if  (event.target.name === 'sbi_match_type') {
            this.sbi_match_type = event.target.value;
        }
    }
    validateInput(){
        if(this.cities==undefined) this.cities =null;
        if(this.postcodes==undefined) this.postcodes =null;
        if(this.sbiList==undefined) this.sbiList =null;
        if(this.primary_sbi_only==undefined) this.primary_sbi_only =null;
        if(this.legal_forms==undefined) this.legal_forms =null;
        if(this.employees_min==undefined) this.employees_min =null;
        if(this.employees_max==undefined) this.employees_max =null;
        if(this.economically_active==undefined) this.economically_active =null;
        if(this.financial_status==undefined) this.financial_status =null;
        if(this.changed_since==undefined) this.changed_since =null;
        if(this.new_since==undefined) this.new_since =null;
        if(this.page_x==undefined) this.page_x =null;
        if(this.provinces==undefined) this.provinces =null;
        if(this.sbi_match_type==undefined) this.sbi_match_type =null;
    }

    handleClick(event){
        this.businessDossiers = [];
        this.validateInput();
        this.makeCallout();
    }
    //called from showBusinessDossierDataTable
    handleLoadMore(){
        this.isDataTableLoading = true;
        this.enableInfiniteLoading = true;
        this.continueSearchBusinessDossier();
    }

    continueSearchBusinessDossier(){
    //increase page to call next page
        this.page_x++;
        this.makeCallout();
    }
    makeCallout(){
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
            if(this.businessDossiers==undefined)this.businessDossiers = result.businessDossiers;
            else this.businessDossiers = this.businessDossiers.concat(result.businessDossiers);

            let totalPage = result.numpages;
            this.page_x = result.curpage;
            this.isDataTableLoading = false;
            if( !(this.page_x<=totalPage)){
                this.page_x = 0;
                this.enableInfiniteLoading = false;
            }
            this.isLoading = false;//stop showing initial spinner
        })
        .catch(error => {
            this.error = error
        })
    }

    set error(value){
        if (!value) return;
        this.fireToast('error', 'Error', value );
    }
    fireToast(type, title, message) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: type,
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }


    get results(){
        if(this.businessDossier){
            return this.businessDossier;
        }
    }
}