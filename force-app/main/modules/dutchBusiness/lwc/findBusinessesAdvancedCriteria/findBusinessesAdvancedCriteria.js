/**
 * Created by hugovankrimpen on 12/08/2020.
 */

import {LightningElement, track, api} from 'lwc';
import {loadScript, loadStyle} from "lightning/platformResourceLoader";

import Find_Dutch_Businesses_Advanced_Criteria_Help_Text from "@salesforce/label/c.Find_Dutch_Businesses_Advanced_Criteria_Help_Text"

export default class FindBusinessesOtherCriteria extends LightningElement {

    @track criteriaValueMap = {
        sbi_match_type: 'ALL',
        economically_active: 'active',
        financial_status: 'solvent',
        primary_sbi_only: false,
        max_number_of_results : 10000
    };
    @api getCriteriaMap(){
        return this.criteriaValueMap;
    }

    labels = {
        Find_Dutch_Businesses_Advanced_Criteria_Help_Text
    }

    connectedCallback() {

    }

    renderedCallback() {
    }

    handleSBIMatchTypeChange(event){
        this.criteriaValueMap['sbi_match_type'] = event.detail.checked;
    }
    handleEconomicallyActiveChange(event){
        this.criteriaValueMap['economically_active'] = event.detail.value;
    }
    handleFinancialStatusChange(event){
        this.criteriaValueMap['financial_status'] = event.detail.value;
    }
    handlePrimarySBIOnlyChange(event){
        this.criteriaValueMap['primary_sbi_only'] = event.detail.value;
    }
    handleMaximumNumberOfRecordsChanged(event){
        let maximumNumberOfResults = event.detail.value;
        let maximumNumberOfResultsInteger = parseInt(maximumNumberOfResults);
        this.criteriaValueMap['max_number_of_results'] = maximumNumberOfResultsInteger;
    }

    get sbi_match_type_options(){
        return [
            { label: 'All sources', value: 'ALL' },
            { label: 'Only Chamber of Commerce', value: 'WS' },
            { label: 'Only Company.Info', value: 'CI' },
        ];
    }
    get economically_active_options(){
        return [
            { label: 'Only Active', value: 'active' },
            { label: 'Only Inactive', value: 'inactive' },
            { label: 'Either Active or Inactive', value: null },
        ];
    }
    get financial_status_options(){
        return [
            { label: 'Solvent', value: 'solvent' },
            { label: 'Insolvent', value: 'insolvent' },
            { label: 'Only Bankrupt', value: 'bankrupt' },
            { label: 'Only Debtor in Possession.', value: 'dip' },
        ];
    }


}