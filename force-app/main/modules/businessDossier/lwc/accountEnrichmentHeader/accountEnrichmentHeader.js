/**
 * Created by hugovankrimpen on 17/03/2020.
 */

import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
import {FlowAttributeChangeEvent, FlowNavigationNextEvent} from 'lightning/flowSupport';

//Object fields
import BUSINESS_DOSSIER_VAT from '@salesforce/schema/Business_Dossier__c.VAT_Number__c';
import BUSINESS_DOSSIER_NO_VAT from '@salesforce/schema/Business_Dossier__c.No_VAT_Number__c';
import BUSINESS_DOSSIER_COUNTRY from '@salesforce/schema/Business_Dossier__c.Registration_Country__c';
import BUSINESS_DOSSIER_CREDITSAFE_COMPANY_REPORT from '@salesforce/schema/Business_Dossier__c.Creditsafe_Company_Report__c';

//Apex controllers
import updateDossierWithVAT from '@salesforce/apex/CompanyDetailsController.updateDossierWithVAT';
import updateDossierWithPositions from '@salesforce/apex/CompanyDetailsController.updateDossierWithPositions';

//Static resources
import companyInfoLogoSmall from '@salesforce/resourceUrl/companyInfoLogoSmall';

//Labels
import VAT_Retrieve from '@salesforce/label/c.VAT_Retrieve';
import Success from '@salesforce/label/c.Success';
import Dossier_Account_Update_Completed from '@salesforce/label/c.Dossier_Account_Update_Completed';
import VAT_Not_Found from '@salesforce/label/c.VAT_Not_Found';
import Error from '@salesforce/label/c.Error';
import Error_Unknown from '@salesforce/label/c.Error_Unknown';
import Error_Incomplete from '@salesforce/label/c.Error_Incomplete';
import Get_Creditsafe_Report from '@salesforce/label/c.Get_Creditsafe_Report';
import Get_Positions from '@salesforce/label/c.Get_Positions';
import No from '@salesforce/label/c.No';
import Yes from '@salesforce/label/c.Yes';

export default class AccountEnrichmentHeader extends LightningElement {

    @api
    businessDossierId;

    @api
    accountRecord;

    @api
    searchAgainClicked;

    @api
    getCreditsafeReportClicked = false;

    @wire(getRecord, { recordId: '$businessDossierId', fields: [BUSINESS_DOSSIER_VAT, BUSINESS_DOSSIER_NO_VAT, BUSINESS_DOSSIER_COUNTRY, BUSINESS_DOSSIER_CREDITSAFE_COMPANY_REPORT] })
    businessDossierRecord;

    @api VATUpdated = false;

    m_getPositionsConfirmDialogVisible = false;
    @api
    get getPositionsConfirmDialogVisible(){
        return this.m_getPositionsConfirmDialogVisible;
    }
    set getPositionsConfirmDialogVisible(value){
        this.m_getPositionsConfirmDialogVisible = value;
    }

    label = {
        VAT_Retrieve,
        Success,
        Dossier_Account_Update_Completed,
        VAT_Not_Found,
        Error,
        Error_Unknown,
        Error_Incomplete,
        Get_Creditsafe_Report,
        Get_Positions,
        Yes,
        No,
    }
    staticResource = {
        companyInfoLogoSmall,
    }

    get showVATButton() {
        if(this.businessDossierRecord != null && this.businessDossierRecord.data != undefined) {
            //If there is no VAT Number and the No_VAT_Number__c(known) is false and only for NL companies
            if(this.businessDossierRecord.data.fields.appsolutely__Registration_Country__c.value == 'NL' &&
                !this.businessDossierRecord.data.fields.appsolutely__VAT_Number__c.value &&
                !this.businessDossierRecord.data.fields.appsolutely__No_VAT_Number__c.value ){
                return true;
            }
            else {
                return false;
            }
        }
    }

    get showGetCreditsafeReportButton() {
        if (this.businessDossierRecord != null && this.businessDossierRecord.data != undefined) {
            //if there is already a relation, then do not show the button
            if (this.businessDossierRecord.data.fields.appsolutely__Creditsafe_Company_Report__c.value != null &&
                this.businessDossierRecord.data.fields.appsolutely__Creditsafe_Company_Report__c.value != undefined) {
                return false;
            }
            else {
                return true;
            }
        }
    }

    handleOnClickVAT(event) {
        updateDossierWithVAT({
            dossierId: this.businessDossierId
        })
            .then(data => {
                if (data.response.appsolutely__VAT_Number__c !== undefined) {
                    this.showToast(this.label.Success, this.label.Dossier_Account_Update_Completed, 'success');
                    this.VATUpdated = true;
                    //we throw an event because we want to refresh the Account details view after VAT is updated
                    this.dispatchEvent(new FlowNavigationNextEvent());
                } else {
                    this.showToast(this.label.Error, this.label.VAT_Not_Found);
                }
            })
            .catch(error => {
                this.showToast(this.label.Error, this.label.Error_Unknown, 'error');
            });
    }

    handleSearchAgainClicked(event) {
        this.searchAgainClicked = true;
        //we throw an event because the flow needs to show a search form
        this.dispatchEvent(new FlowNavigationNextEvent());
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

    handleOnGetCreditsafeReport(event) {
        this.getCreditsafeReportClicked = true;
        //we throw an event because the flow needs to show a search form
        this.dispatchEvent(new FlowNavigationNextEvent());
    }


    handleOnGetPositionsClicked(event){
        let confirmationDialog = this.template.querySelector('c-confirmation-dialog');

        confirmationDialog.show();
    }
    handleOnClickConfirmationDialog(event){

        if(event.detail.status == 'cancel'){
            let confirmationDialog = this.template.querySelector('c-confirmation-dialog');
            confirmationDialog.hide();
        }
        if(event.detail.status == 'confirm'){
            this.retrievePositions();
        }
    }
    retrievePositions(){
        console.log('retrievePositions');
        console.log(this.businessDossierId);
        updateDossierWithPositions({
            dossierId: this.businessDossierId
        })
            .then(result => {
                console.log(JSON.parse(result));
            })
            .catch(error => {
                console.log(error);
            })
            .finally(()=>{
                let confirmationDialog = this.template.querySelector('c-confirmation-dialog');
                confirmationDialog.hide();
            })
    }

}