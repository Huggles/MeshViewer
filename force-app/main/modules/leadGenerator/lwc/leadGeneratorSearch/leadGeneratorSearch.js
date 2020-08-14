/**
 * Created by Hugo on 11/08/2020.
 */

import {LightningElement, track, api} from 'lwc';
import {FlowAttributeChangeEvent, FlowNavigationBackEvent, FlowNavigationNextEvent,
    FlowNavigationPauseEvent, FlowNavigationFinishEvent} from 'lightning/flowSupport';

import Search_Confirm from '@salesforce/label/c.Search_Confirm';
import Cancel from '@salesforce/label/c.Cancel';
import Previous from '@salesforce/label/c.Previous';



export default class LeadGeneratorSearch extends LightningElement {


    @api selectedCriteria123;
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


    label = {
        Search_Confirm,
        Cancel,
        Previous
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
        this.sbiHTMLElement = this.template.querySelector('c-lead-generator-standard-industrial-classifications');
        this.locationHTMLElement = this.template.querySelector('c-lead-generator-location');
        this.otherCriteriaHTMLElement = this.template.querySelector('c-find-businesses-other-criteria');
    }

    handleFooterNextClick(event){
        this.selectedSBIs = this.sbiHTMLElement.getSBIArray();
        if(this.locationHTMLElement != null)
            this.selectedLocations = this.locationHTMLElement.getLocationArray(); //Only runs when the location accordion item is still open.
        this.selectedOtherCriteria = this.otherCriteriaHTMLElement.getCriteriaMap();

        console.log(JSON.stringify(this.selectedSBIs));
        console.log(JSON.parse(JSON.stringify(this.selectedLocations)));
        console.log(JSON.stringify(this.selectedOtherCriteria));
        let FindBusinessCriteriaModel = {
            sbiList : null,
            legal_forms : null,
            provinces :                 JSON.parse(JSON.stringify(this.selectedLocations)),
            employees_min :             this.selectedOtherCriteria.employees_min,
            employees_max :             this.selectedOtherCriteria.employees_max,
            primary_sbi_only :          this.selectedOtherCriteria.primary_sbi_only,
            economically_active :       this.selectedOtherCriteria.economically_active,
            financial_status :          this.selectedOtherCriteria.financial_status,
            changed_since :             this.selectedOtherCriteria.changed_since,
            new_since :                 this.selectedOtherCriteria.new_since,
            sbi_match_type :            this.selectedOtherCriteria.sbi_match_type
        }
        this.selectedCriteria123 = FindBusinessCriteriaModel;
        const attributeChangeEvent = new FlowAttributeChangeEvent('selectedCriteria123', FindBusinessCriteriaModel);

        console.log('FindBusinessCriteriaModel');
        console.log(FindBusinessCriteriaModel);
        const navigateNextEvent = new FlowNavigationNextEvent();
        this.dispatchEvent(navigateNextEvent);
    }

    /*

steps = [
    {
        label : 'Select SBI\'s',
        value : 'SBI'
    },
    {
        label : 'Select Location',
        value : 'Location'
    },
    {
        label : 'Select Properties',
        value : 'Properties'
    }];




currentstepIndex = 0;
get currentstep(){
    return this.steps[this.currentstepIndex].value;
}
get isStepSBI(){
    return this.currentstep == this.steps[0].value;
}
get isStepLocation(){
    return this.currentstep == this.steps[1].value;
}
get isStepProperties(){
    return this.currentstep == this.steps[2].value;
}

onNextClicked(event){
    if(this.currentstepIndex < this.steps.length - 1){
        this.currentstepIndex += 1;
    }
}
onPreviousClicked(event){
    if(this.currentstepIndex > 0){
        this.currentstepIndex -= 1;
    }
}

 */


}