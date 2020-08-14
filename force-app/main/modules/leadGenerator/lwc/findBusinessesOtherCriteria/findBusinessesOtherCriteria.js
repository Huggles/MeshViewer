/**
 * Created by hugovankrimpen on 12/08/2020.
 */

import {LightningElement, track} from 'lwc';
import {loadScript, loadStyle} from "lightning/platformResourceLoader";
import noUISliderRef from '@salesforce/resourceUrl/noUISlider';

export default class FindBusinessesOtherCriteria extends LightningElement {

    @track criteriaValueMap = {
        sbi_match_type: 'ALL',
        economically_active: 'active',
        financial_status: 'solvent',
        primary_sbi_only: false,
        legal_forms: [],
        changed_since: '',
        new_since: '',
        cities: '',
        postcodes: ''
    };




    connectedCallback() {
        this.loadSlider();
    }

    sliderHTMLElement;
    sliderHTMLElementLoaded = false;
    sliderLibraryLoaded = false;
    async loadSlider(){
        Promise.all([
            loadScript(this, noUISliderRef + '/nouislider.js'),
            loadStyle(this, noUISliderRef + '/nouislider.css'),
        ]).then((results)=>{
            this.sliderLibraryLoaded = true;
            this.createSlider();
        })
    }
    renderedCallback() {
        this.sliderHTMLElement = this.template.querySelector('[data-id="employeeSlider"]');
        this.createSlider();
    }



    employeesSliderSelectedMinValue;
    employeesSliderSelectedMaxValue;
    createSlider(){
        if(this.sliderHTMLElement == null ||  this.sliderLibraryLoaded == false || this.sliderHTMLElementLoaded == true) {
            return;
        }
        let maxValue = 500;
        let minValue = 0;
        noUiSlider.cssClasses.handle += ' sliderHandleCSS'
        noUiSlider.create(this.sliderHTMLElement, {
            range: {
                'min': minValue,
                'max': maxValue
            },
            step: 1,
            connect: true,
            tooltips: [false, false],
            margin: 1,
            format: {
              to: (value) =>{
                  if(value === maxValue ) return "∞";
                  if(isNaN(value)) return value;
                  return value.toFixed(0).toString();
              },
              from:(value) => {
                  if(value === "∞" ) return maxValue;
                  if(isNaN(value)) return value;
                  return parseInt(value).toFixed(0);
              }
            },
            start: [0, "∞"],
        });
        this.sliderHTMLElement.noUiSlider.on('update', (values, handle) => {
            this.employeesSliderSelectedMinValue = values[0];
            this.criteriaValueMap['employees_min'] = values[0] ;

            this.employeesSliderSelectedMaxValue = values[1];
            this.criteriaValueMap['employees_max'] = (values[1] == "∞" ? maxValue : values[1]);
        });
        this.sliderHTMLElementLoaded = true;
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
    logData(event){
        console.log(JSON.parse(JSON.stringify(this.criteriaValueMap)));
    }

    not_selected_option = { label: '-', value: 'none' };

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

    get sbi_match_type_options(){
        return [
            { label: 'SBI codes are matched against all known SBI sources.', value: 'ALL' },
            { label: 'SBI codes are matched against the default SBI source.', value: 'WS' },
            { label: 'SBI codes are matched against the extra Company.info SBI source.', value: 'CI' },
        ];
    }
    get economically_active_options(){
        return [
            { label: 'Only economically active businesses.', value: 'active' },
            { label: 'Only economically inactive businesses.', value: 'inactive' },
        ];
    }
    get financial_status_options(){
        return [
            { label: 'Only businesses which are neither bankrupt nor debtor in possession. ', value: 'solvent' },
            { label: 'Only businesses which are either bankrupt or debtor in possession.', value: 'insolvent' },
            { label: 'Only bankrupt businesses.', value: 'bankrupt' },
            { label: 'Only businesses which are debtor in possession.', value: 'dip' },
        ];
    }


}