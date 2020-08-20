/**
 * Created by Hugo on 20/08/2020.
 */


import {LightningElement, track, api} from 'lwc';
import {FlowAttributeChangeEvent, FlowNavigationBackEvent, FlowNavigationNextEvent,
    FlowNavigationPauseEvent, FlowNavigationFinishEvent} from 'lightning/flowSupport';

import Search_Confirm from '@salesforce/label/c.Search_Confirm';
import Cancel from '@salesforce/label/c.Cancel';
import Previous from '@salesforce/label/c.Previous';
import Find_Businesses_Title from '@salesforce/label/c.Find_Businesses_Title';
import Find_Businesses_Criteria_Help_Text from '@salesforce/label/c.Find_Businesses_Criteria_Help_Text';

export default class FindBusinessesContainer extends LightningElement {

    @api criteriaMap;
    @api selectedCriteria456;

    activeSections = [];
    handleSectionToggle(event){
        if(this.activeSections.includes('Location') && !event.detail.openSections.includes('Location')){
            //Location tab was closed. Retrieve selected provinces.
            this.selectedLocations = this.locationHTMLElement.getLocationArray();
        }
        this.activeSections = event.detail.openSections;
    }
    get isStepLocation(){
        if(this.activeSections != null){
            return this.activeSections.includes("Location");
        }return false;
    }

    labels = {
        Search_Confirm,
        Cancel,
        Previous,
        Find_Businesses_Title,
        Find_Businesses_Criteria_Help_Text
    }

    availableFooterActions = [
        'NEXT',
        'FINISH'
    ]
    showFooterCancelButton = true;

    sbiHTMLElement;
    locationHTMLElement;
    otherCriteriaHTMLElement;

    @track selectedSBIs = [];
    @track selectedLocations = [];
    @track selectedOtherCriteria = {};


    renderedCallback() {
        this.sbiHTMLElement = this.template.querySelector('c-find-businesses-standard-industrial-classifications');
        this.locationHTMLElement = this.template.querySelector('c-find-businesses-location');
        this.otherCriteriaHTMLElement = this.template.querySelector('c-find-businesses-other-criteria');
    }

    handleFooterNextClick(event){
        this.selectedSBIs = this.sbiHTMLElement.getSBIArray();
        if(this.locationHTMLElement != null)
            this.selectedLocations = this.locationHTMLElement.getLocationArray(); //Only runs when the location accordion item is still open.
        this.selectedOtherCriteria = this.otherCriteriaHTMLElement.getCriteriaMap();

        let selectedSBIsFiltered = [];
        this.selectedSBIs.forEach((item,index)=>{
            if(item.length === 1 && item.match(/[a-zA-Z]/i) != null){} //Dont include the category, this throws an error on company.info side. }
            else{
                selectedSBIsFiltered.push(item);
            }

        });
        let legalForms = [];
        this.selectedOtherCriteria.legal_forms.forEach((item,index)=>{
            legalForms.push(item.value);
        });

        let FindBusinessCriteriaModel = {
            sbiList :                   selectedSBIsFiltered,
            legal_forms :               legalForms,
            provinces :                 JSON.parse(JSON.stringify(this.selectedLocations)),
            employees_min :             this.selectedOtherCriteria.employees_min,
            employees_max :             this.selectedOtherCriteria.employees_max,
            primary_sbi_only :          this.selectedOtherCriteria.primary_sbi_only,
            economically_active :       this.selectedOtherCriteria.economically_active,
            financial_status :          this.selectedOtherCriteria.financial_status,
            changed_since :             this.selectedOtherCriteria.changed_since,
            new_since :                 this.selectedOtherCriteria.new_since,
            sbi_match_type :            this.selectedOtherCriteria.sbi_match_type,
            max_number_of_results :     this.selectedOtherCriteria.max_number_of_results

        }
        this.criteriaMap = FindBusinessCriteriaModel;
        const attributeChangeEvent = new FlowAttributeChangeEvent('criteriaMap', FindBusinessCriteriaModel);

        console.log('FindBusinessCriteriaModel');
        console.log(FindBusinessCriteriaModel);
        const navigateNextEvent = new FlowNavigationNextEvent();
        this.dispatchEvent(navigateNextEvent);
    }

}