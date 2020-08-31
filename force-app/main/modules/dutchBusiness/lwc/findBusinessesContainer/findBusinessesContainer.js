/**
 * Created by Hugo on 20/08/2020.
 */


import {LightningElement, track, api} from 'lwc';
import {FlowAttributeChangeEvent, FlowNavigationBackEvent, FlowNavigationNextEvent,
    FlowNavigationPauseEvent, FlowNavigationFinishEvent} from 'lightning/flowSupport';

import Search_Confirm from '@salesforce/label/c.Search_Confirm';
import Cancel from '@salesforce/label/c.Cancel';
import Previous from '@salesforce/label/c.Previous';
import Find_Dutch_Businesses_Title from '@salesforce/label/c.Find_Dutch_Businesses_Title';
import Find_Dutch_Businesses_Criteria_Help_Text from '@salesforce/label/c.Find_Dutch_Businesses_Criteria_Help_Text';

import Industry_Label from '@salesforce/label/c.Industry_Label';
import Location_Label from '@salesforce/label/c.Location_Label';
import Other_Label from '@salesforce/label/c.Other_Label';

export default class FindBusinessesContainer extends LightningElement {

    @api criteriaMap;

    activeSections = [];
    handleSectionToggle(event){
        /*
        if(this.activeSections.includes('Location') && !event.detail.openSections.includes('Location')){
            //Location tab was closed. Retrieve selected provinces.
            this.selectedLocations = this.locationHTMLElement.getLocationArray();
        }
         */
        this.activeSections = event.detail.openSections;
    }

    _isStepLocation = false;
    get isStepLocation(){
        //Once opened, it should remain open to avoid reloading of the component.
        if(this.activeSections != null && this._isStepLocation == false){
            this._isStepLocation = this.activeSections.includes("Location");
        }
        return this._isStepLocation;
    }

    labels = {
        Search_Confirm,
        Cancel,
        Previous,
        Find_Dutch_Businesses_Title,
        Find_Dutch_Businesses_Criteria_Help_Text,
        Industry_Label,
        Location_Label,
        Other_Label
    }

    availableFooterActions = [
        'NEXT',
    ]
    showFooterCancelButton = true;

    sbiHTMLElement;
    locationHTMLElement;
    otherCriteriaHTMLElement;

    @track selectedSBIs = [];
    @track selectedLocations = {
        type : null,
        locations : []
    };
    @track selectedOtherCriteria = {};


    renderedCallback() {
        this.sbiHTMLElement = this.template.querySelector('c-find-businesses-standard-industrial-classifications');
        this.locationHTMLElement = this.template.querySelector('c-find-businesses-location');
        this.otherCriteriaHTMLElement = this.template.querySelector('c-find-businesses-other-criteria');
    }


    get nextButtonDisabled(){
        let sbis;
        let locationResponse;
        if(this.sbiHTMLElement != null) sbis = this.sbiHTMLElement.getSBIArray();
        if(this.locationHTMLElement != null) locationResponse = this.locationHTMLElement.getLocationArray();
        if( (sbis != null               && sbis.length > 0) || (locationResponse != null && locationResponse.locations.length > 0))
            return false;
        return true;
    }
    handleFooterNextClick(event){
        this.criteriaMap = this.createSearchCriteriaModel();
        const attributeChangeEvent = new FlowAttributeChangeEvent('criteriaMap', this.criteriaMap);
        const navigateNextEvent = new FlowNavigationNextEvent();
        this.dispatchEvent(navigateNextEvent);
    }
    createSearchCriteriaModel(){
        let findBusinessCriteriaModel = {};

        //Process SBI
        if(this.sbiHTMLElement != null){
            this.selectedSBIs = this.sbiHTMLElement.getSBIArray();
            findBusinessCriteriaModel['sbiList'] = this.selectedSBIs;

        }

        //Process location
        if(this.locationHTMLElement != null) {
            this.selectedLocations = this.locationHTMLElement.getLocationArray();
            if(this.selectedLocations.type == "PROVINCE"){
                findBusinessCriteriaModel['provinces'] = JSON.parse(JSON.stringify(this.selectedLocations.locations));
            }else if(this.selectedLocations.type == "POSTALCODE"){
                findBusinessCriteriaModel['postcodes'] = JSON.parse(JSON.stringify(this.selectedLocations.locations));
            }
            else if(this.selectedLocations.type == "CITY"){
                findBusinessCriteriaModel['cities'] = JSON.parse(JSON.stringify(this.selectedLocations.locations));
            }
        }

        //Process Other
        if(this.otherCriteriaHTMLElement != null) {
            this.selectedOtherCriteria = this.otherCriteriaHTMLElement.getCriteriaMap();
            let legalForms = [];
            this.selectedOtherCriteria.legal_forms.forEach((item,index)=>{
                legalForms.push(item.value);
            });
            findBusinessCriteriaModel['legal_forms'] =                     legalForms;
            findBusinessCriteriaModel['employees_min'] =                   this.selectedOtherCriteria.employees_min,
            findBusinessCriteriaModel['employees_max'] =                   this.selectedOtherCriteria.employees_max,
            findBusinessCriteriaModel['primary_sbi_only'] =                this.selectedOtherCriteria.primary_sbi_only,
            findBusinessCriteriaModel['economically_active'] =             this.selectedOtherCriteria.economically_active,
            findBusinessCriteriaModel['financial_status'] =                this.selectedOtherCriteria.financial_status,
            findBusinessCriteriaModel['changed_since'] =                   this.selectedOtherCriteria.changed_since,
            findBusinessCriteriaModel['new_since'] =                       this.selectedOtherCriteria.new_since,
            findBusinessCriteriaModel['sbi_match_type'] =                  this.selectedOtherCriteria.sbi_match_type,
            findBusinessCriteriaModel['max_number_of_results'] =           this.selectedOtherCriteria.max_number_of_results
        }
        return findBusinessCriteriaModel;
    }

}
