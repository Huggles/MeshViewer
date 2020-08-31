/**
 * Created by hugovankrimpen on 12/08/2020.
 */

import {LightningElement, track, api} from 'lwc';
import {loadScript, loadStyle} from "lightning/platformResourceLoader";
import {deepCopyFunction} from "c/deepCloneUtils";

export default class FindBusinessesOtherCriteria extends LightningElement {

    @track criteriaValueMap = {
        legal_forms: [],
        changed_since: '',
        new_since: '',
        employees_min: 0,
        employees_max: null,
        cities: '',
        postcodes: ''
    };
    @api getCriteriaMap(){
        let advancedCriteriaMap = this.AdvancedSectionHTMLElement.getCriteriaMap();
        let combinedCriteriaMap = deepCopyFunction(Object.assign(advancedCriteriaMap, this.criteriaValueMap));
        return combinedCriteriaMap;
    }

    connectedCallback() {

    }

    renderedCallback() {
        this.AdvancedSectionHTMLElement = this.template.querySelector('c-find-businesses-advanced-criteria');
        this.minEmployeeSliderHTMLElement = this.template.querySelector('[data-identifier="minEmployeesSilder"]');
        this.maxEmployeeSliderHTMLElement = this.template.querySelector('[data-identifier="maxEmployeesSilder"]');
    }

    AdvancedSectionHTMLElement;

    //****************//
    //Employee Sliders//
    //****************//

    minEmployeeSliderHTML;
    maxEmployeeSliderHTMLElement;
    employeesSliderMinValue = 0;
    employeesSliderMaxValue = 500;

    onMinEmployeesSliderMoved(event){
        let minEmployeeValue = parseInt(this.minEmployeeSliderHTMLElement.value);
        this.minEmployeesValue = minEmployeeValue;
        if(minEmployeeValue > this.maxEmployeesValue) { this.maxEmployeesValue = minEmployeeValue; }
    }
    onMaxEmployeesSliderMoved(event){
        let maxEmployeeValue = parseInt(this.maxEmployeeSliderHTMLElement.value);
        this.maxEmployeesValue = maxEmployeeValue
        if(maxEmployeeValue < this.minEmployeesValue) { this.minEmployeesValue = maxEmployeeValue; }
    }
    get minEmployeesValue(){
        return this.criteriaValueMap['employees_min'];
    }
    set minEmployeesValue(value){
        this.criteriaValueMap['employees_min'] = value;
    }
    get maxEmployeesValue(){
        return this.criteriaValueMap['employees_max'] == null ? 500 : this.criteriaValueMap['employees_max'] ;
    }
    set maxEmployeesValue(value){
        this.criteriaValueMap['employees_max'] = value === 500 ? null : value;
    }
    get maxEmployeesLabel(){
        return this.maxEmployeesValue === 500 ? "∞" : this.maxEmployeesValue;
    }

    //*********************//
    //Input Change Handlers//
    //*********************//

    handleLegalFormChange(event){
        let selectedOptionsList = event.detail;
        this.criteriaValueMap['legal_forms'] = selectedOptionsList;
    }
    handleChangedSinceChange(event){
        this.criteriaValueMap['changed_since'] = event.detail.value;
    }
    handleNewSinceChange(event){
        this.criteriaValueMap['new_since'] = event.detail.value;
    }
    handleCitiesChange(event){
        this.criteriaValueMap['cities'] = event.detail.value;
    }
    handlePostalCodesChange(event){
        this.criteriaValueMap['postcodes'] = event.detail.value;
    }


    get legal_form_options(){
        return [
            {value: "42",label: "Besloten Vennootschap blijkens statuten structuurvennootschap"},
            {value: "41",label: "Besloten Vennootschap met gewone structuur"},
            {value: "95",label: "Buitenlandse EG-vennootschap met hoofdnederzetting in Nederland"},
            {value: "94",label: "Buitenlandse EG-vennootschap met onderneming in Nederland"},
            {value: "97",label: "Buitenlandse op EG-vennootschap lijkende vennootschap met hoofdnederzetting in Nederland"},
            {value: "96",label: "Buitenlandse op EG-vennootschap lijkende vennootschap met onderneming in Nederland"},
            {value: "91",label: "Buitenlandse rechtsvorm met hoofdvestiging in Nederland"},
            {value: "21",label: "Commanditaire Vennootschap met één beherende vennoot"},
            {value: "22",label: "Commanditaire Vennootschap met meer dan één beherende vennoot"},
            {value: "24",label: "Commanditaire vennootschap met rechtspersoonlijkheid"},
            {value: "66",label: "Coöperatie B.A. blijkens statuten structuurcoöperatie"},
            {value: "65",label: "Coöperatie B.A. met gewone structuur"},
            {value: "62",label: "Coöperatie U.A. blijkens statuten structuurcoöperatie"},
            {value: "61",label: "Coöperatie U.A. met gewone structuur"},
            {value: "64",label: "Coöperatie W.A. blijkens statuten structuurcoöperatie"},
            {value: "63",label: "Coöperatie W.A. met gewone structuur"},
            {value: "1",label: "Eenmanszaak"},
            {value: "2",label: "Eenmanszaak met meer dan één eigenaar"},
            {value: "93",label: "Europees Economisch Samenwerkingsverband"},
            {value: "55",label: "Europese naamloze vennootschap (SE)"},
            {value: "56",label: "Europese naamloze vennootschap (SE) blijkens statuten structuurvennootschap"},
            {value: "73",label: "Kerkgenootschap"},
            {value: "7",label: "Maatschap"},
            {value: "53",label: "Naamloze Vennootschap beleggingsmaatschappij met veranderlijk kapitaal"},
            {value: "52",label: "Naamloze Vennootschap blijkens statuten structuurvennootschap"},
            {value: "51",label: "Naamloze Vennootschap met gewone structuur"},
            {value: "92",label: "Nevenvestiging met hoofdvestiging in buitenland"},
            {value: "3",label: "NV / BV in oprichting op A-formulier"},
            {value: "12",label: "NV / BV in oprichting op B-formulier"},
            {value: "23",label: "NV / BV in oprichting op D-formulier"},
            {value: "54",label: "NV beleggingsmaatschappij met veranderlijk kapitaal blijkens statuten structuurvennootschap"},
            {value: "86",label: "Onderlinge waarborgmaatschappij B.A. blijkens statuten structuuronderlinge"},
            {value: "85",label: "Onderlinge waarborgmaatschappij B.A. met gewone structuur"},
            {value: "82",label: "Onderlinge waarborgmaatschappij U.A. blijkens statuten structuuronderlinge"},
            {value: "81",label: "Onderlinge waarborgmaatschappij U.A. met gewone structuur"},
            {value: "84",label: "Onderlinge waarborgmaatschappij W.A. blijkens statuten structuuronderlinge"},
            {value: "83",label: "Onderlinge waarborgmaatschappij W.A. met gewone structuur"},
            {value: "13",label: "Openbare vennootschap"},
            {value: "14",label: "Openbare vennootschap met rechtspersoonlijkheid"},
            {value: "89",label: "Privaatrechtelijke rechtspersoon"},
            {value: "88",label: "Publiekrechtelijke rechtspersoon"},
            {value: "40",label: "Rechtspersoon in oprichting"},
            {value: "5",label: "Rederij"},
            {value: "74",label: "Stichting"},
            {value: "11",label: "Vennootschap onder firma"},
            {value: "72",label: "Vereniging met beperkte rechtsbevoegdheid"},
            {value: "71",label: "Vereniging met volledige rechtsbevoegdheid"},
            {value: "70",label: "Vereniging van Eigenaars"}
        ];
    }




}