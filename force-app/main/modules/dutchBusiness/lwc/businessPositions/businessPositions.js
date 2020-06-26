/**
 * Created by Hugo on 25/06/2020.
 */

import {LightningElement, wire, api} from 'lwc';
import {getRecord} from "lightning/uiRecordApi";

import ACCOUNT_BUSINESS_DOSSIER_FIELD from '@salesforce/schema/Account.Business_Dossier__c';

export default class BusinessPositions extends LightningElement {

    @api recordId;

    parentRecordId;

    _businessPositionRelatedList;
    _contactRelatedList;


    _getRecordDataResponse;
    @wire(getRecord, { recordId: '$recordId', fields: [ACCOUNT_BUSINESS_DOSSIER_FIELD]})
    recordData(response) {
        this._getRecordDataResponse = response;
        if (response.error) {
            console.log(response.error);
        } else if (response.data) {
            if(response.data.fields[ACCOUNT_BUSINESS_DOSSIER_FIELD.fieldApiName] != null &&
                response.data.fields[ACCOUNT_BUSINESS_DOSSIER_FIELD.fieldApiName].value != null) {
                this.loadBusinessPositionRelatedList();
            }
        }
    }

    renderedCallback() {
        this._businessPositionRelatedList = this.template.querySelector("c-custom-related-list[data-identifier='BusinessPositionRelatedList']");
        this._contactRelatedList = this.template.querySelector("c-custom-related-list[data-identifier='ContactRelatedList']");
        this.loadContactRelatedList();
    }
    loadBusinessPositionRelatedList(){
        if(this._businessPositionRelatedList != null) {
            this._businessPositionRelatedList.parentRecordId = response.data.fields[ACCOUNT_BUSINESS_DOSSIER_FIELD.fieldApiName].value;
            this._businessPositionRelatedList.loadRelatedList();
        }
    }
    loadContactRelatedList(){
        if(this._contactRelatedList != null){
            this._contactRelatedList.loadRelatedList();
        }
    }
    contactRelatedListColumnsInitialized(){
        console.log('contactRelatedListColumnsInitialized');
        if(this._contactRelatedList != null){
            this._contactRelatedList.setColumnType('name','url', { value : 'http://google.nl'});
        }
    }

}