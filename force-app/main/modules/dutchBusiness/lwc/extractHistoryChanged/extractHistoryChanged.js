/**
 * Created by Hugo on 12/06/2020.
 */

import {LightningElement, api, wire} from 'lwc';

import getExtractHistoryChanged from '@salesforce/apex/ExtractHistoryChangedController.getExtractHistoryChanged';
import {getRecord} from "lightning/uiRecordApi";

//Object fields
import ACCOUNT_NAME_FIELD from '@salesforce/schema/Account.Name';
import DOSSIER_NUMBER from '@salesforce/schema/Account.Business_Dossier__r.Dossier_Number__c';
import {ShowToastEvent} from "lightning/platformShowToastEvent";

export default class ExtractHistoryChanged extends LightningElement {


    isLoading;
    confirmationModalElement;

    @api recordId

    constructor() {
        super();
        this.isLoading = true;
    }
    renderedCallback() {
        this.confirmationModalElement = this.template.querySelector('c-modal');
    }

    m_accountRecord;
    @wire(getRecord, {recordId: '$recordId',fields: [ACCOUNT_NAME_FIELD,DOSSIER_NUMBER] })
    accountRecord({ error, data }) {
        this.isLoading = false;
        if(data){
           this.m_accountRecord = data;
        }
        else if(error){

        }
    }

    get hasBusinessDossierNumber(){
        if(this.m_accountRecord != null &&
            this.m_accountRecord.fields.appsolutely__Business_Dossier__r != null &&
            this.m_accountRecord.fields.appsolutely__Business_Dossier__r.value != null){
            return true;
        }
        return false;
    }
    get hasExtractHistory(){
        if(this.extractHistory != null &&
            this.extractHistory.references != null &&
            this.extractHistory.references.item  != null &&
            this.extractHistory.references.item.length  > 0){
            return true;
        }
        return false;
    }



    extractHistory;
    retrieveExtractHistory(){
        if(this.hasBusinessDossierNumber){
            this.isLoading = true;
            let dossier_number = this.m_accountRecord.fields.appsolutely__Business_Dossier__r.value.fields.appsolutely__Dossier_Number__c.value;
            let payload = {
                'dossier_number' : dossier_number,
                'start_period' : new Date(2016,1,1),
                'end_period' : new Date(2020,12,6),
            }
            getExtractHistoryChanged(payload)
                .then((result) => {
                    this.isLoading = false;
                    let parsed_result = JSON.parse(result);
                    this.extractHistory = parsed_result;
                })
                .catch((error) => {
                    this.isLoading = false;
                    this.showToast('Error', error, 'error', null);
                })
        }
    }

    selectedExtractId;
    retrieveExtract(event){
        let extractId = event.target.name;
        this.selectedExtractId = extractId;
        this.confirmationModalElement.show();
    }


    handleConfirmationModalClosed(){
        if(this.confirmationModalElement){
            this.confirmationModalElement.hide();
        }
    }
    handleConfirmationModalAccepted(){
        //TODO:go fetch extract
        console.log('go fetch extract id: ' + this.selectedExtractId);
    }



    showToast(title, message, type, mode) {
        const event = new ShowToastEvent({
            "title": title,
            "message": message,
            "variant": (type == null ? 'info' : type),
            "mode": (mode == null ? ((type == 'info' || type == 'success' || type == null) ? 'dismissable' : 'sticky') : mode)
        });
        this.dispatchEvent(event);
    }


}