/**
 * Created by Hugo on 25/06/2020.
 */

import {LightningElement, wire, api} from 'lwc';
import {getRecord} from "lightning/uiRecordApi";

import ACCOUNT_BUSINESS_DOSSIER_FIELD from '@salesforce/schema/Account.Business_Dossier__c';
import {checkAccess, Features} from "c/featureAccessControl";
import {ToastEventController} from "c/toastEventController";

export default class BusinessPositions extends LightningElement {

    @api recordId;

    parentRecordId;
    isLoading = false;

    _hasFeatureAccess = false;
    get hasFeatureAccess(){
        return this._hasFeatureAccess;
    }
    set hasFeatureAccess(value){
        this._hasFeatureAccess = value;
        if(value === true){
            this.loadBusinessPositionRelatedList();
        }
    }

    _businessPositionRelatedList;
    _contactRelatedList;
    _getRecordDataResponse;

    connectedCallback() {
        this.isLoading = true;
        checkAccess(Features.DUTCH_BUSINESS_POSITIONS)
            .then(result => {
                this.hasFeatureAccess = result;
            })
            .catch(error => {
                new ToastEventController(this).showErrorToastMessage('Error', error);
            }).finally(()=>{
                this.isLoading = false;
            })

    }
    renderedCallback() {
        this.loadBusinessPositionRelatedList();
    }

    /*
     * Try and load this component:
     * -When access has been checked
     * -When customRelatedList has been rendered
     */
    loadBusinessPositionRelatedList(){
        this._businessPositionRelatedList = this.template.querySelector("c-custom-related-list[data-identifier='BusinessPositionRelatedList']");
        if(this._businessPositionRelatedList != null && this.hasFeatureAccess == true) {
            this._businessPositionRelatedList.parentRecordId = this.recordId;
            this._businessPositionRelatedList.loadRelatedList();
        }
    }
    businessPositionRelatedListColumnsInitialized(){
        if(this._businessPositionRelatedList != null){
            this._businessPositionRelatedList.setColumnTypeRelativeURL('appsolutely__Filled_By_Id__c','appsolutely__Filled_By__c', false);
            this._businessPositionRelatedList.removeColumn('appsolutely__Filled_By__c');
        }
    }
}