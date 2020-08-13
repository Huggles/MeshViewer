/**
 * Created by hugovankrimpen on 12/08/2020.
 */

import {LightningElement} from 'lwc';

export default class FindBusinessesOtherCriteria extends LightningElement {


    criteriaValueMap = {};


    not_selected_option = { label: '-', value: 'none' };

    get sbi_match_type_options(){
        return [
            this.not_selected_option,
            { label: 'SBI codes are matched against the default SBI source.', value: 'WS' },
            { label: 'SBI codes are matched against the extra Company.info SBI source.', value: 'CI' },
            { label: 'SBI codes are matched against all known SBI sources.', value: 'ALL' },
        ];
    }
    get economically_active_options(){
        return [
            this.not_selected_option,
            { label: 'Only economically active businesses.', value: 'active' },
            { label: 'Only economically inactive businesses.', value: 'inactive' },
        ];
    }
    get financial_status_options(){
        return [
            this.not_selected_option,
            { label: 'Only bankrupt businesses.', value: 'bankrupt' },
            { label: 'Only businesses which are debtor in possession.', value: 'dip' },
            { label: 'Only businesses which are neither bankrupt nor debtor in possession. ', value: 'solvent' },
            { label: 'Only businesses which are either bankrupt or debtor in possession.', value: 'insolvent' },
        ];
    }

    handleSBIMatchTypeChange(event){
        criteriaValueMap['sbi_match_type'] = event.detail.checked;
    }
    handleEconomicallyActiveChange(event){
        criteriaValueMap['economically_active'] = event.detail.value;
    }
    handleFinancialStatusChange(event){
        criteriaValueMap['financial_status'] = event.detail.value;
    }
    handlePrimarySBIOnlyChange(event){
        criteriaValueMap['primary_sbi_only'] = event.detail.value;
    }
    handleLegalFormChange(event){
        criteriaValueMap['legal_forms'] = event.detail.value;
    }
    handleEmpolyeesMinimalChange(event){
        criteriaValueMap['employees_min'] = event.detail.value;
    }
    handleEmpolyeesMaximalChange(event){
        criteriaValueMap['employees_max'] = event.detail.value;
    }
    handleChangedSinceChange(event){
        criteriaValueMap['changed_since'] = event.detail.value;
    }
    handleNewSinceChange(event){
        criteriaValueMap['new_since'] = event.detail.value;
    }
    handleCitiesChange(event){
        criteriaValueMap['cities'] = event.detail.value;
    }
    handlePostcodesChange(event){
        criteriaValueMap['postcodes'] = event.detail.value;
    }


}