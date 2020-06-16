/**
 * Created by hugovankrimpen on 17/03/2020.
 */

import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
import {FlowAttributeChangeEvent, FlowNavigationNextEvent} from 'lightning/flowSupport';
import {Features, checkAccess} from "c/featureAccessControl";

//Object fields
import BUSINESS_DOSSIER_VAT from '@salesforce/schema/Business_Dossier__c.VAT_Number__c';
import BUSINESS_DOSSIER_NO_VAT from '@salesforce/schema/Business_Dossier__c.No_VAT_Number__c';
import BUSINESS_DOSSIER_COUNTRY from '@salesforce/schema/Business_Dossier__c.Registration_Country__c';
import BUSINESS_DOSSIER_CREDITSAFE_COMPANY_REPORT from '@salesforce/schema/Business_Dossier__c.Creditsafe_Company_Report__c';

//Apex controllers
import updateDossierWithVAT from '@salesforce/apex/CompanyDetailsController.updateDossierWithVAT';

//Static resources
import companyInfoLogoSmall from '@salesforce/resourceUrl/companyInfoLogoSmall';

//Labels
import VAT_Retrieve from '@salesforce/label/c.VAT_Retrieve';
import Success from '@salesforce/label/c.Success';
import Dossier_Account_Update_Completed from '@salesforce/label/c.Dossier_Account_Update_Completed';
import VAT_Not_Found from '@salesforce/label/c.VAT_Not_Found';
import Error from '@salesforce/label/c.Error';
import Get_Creditsafe_Report from '@salesforce/label/c.Get_Creditsafe_Report';



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

    label = {
        VAT_Retrieve,
        Success,
        Dossier_Account_Update_Completed,
        VAT_Not_Found,
        Error,
        Get_Creditsafe_Report
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
        if (checkAccess(Features.CREDITSAFE_GET_REPORT)) {
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
    }

    handleOnClickVAT(event) {
        updateDossierWithVAT({
            dossierId: this.businessDossierId
        })
            .then(data => {
                if (data.appsolutely__VAT_Number__c !== undefined) {
                    this.showToast(this.label.Success, this.label.Dossier_Account_Update_Completed, 'success');
                    this.VATUpdated = true;
                    //we throw an event because we want to refresh the Account details view after VAT is updated
                    this.dispatchEvent(new FlowNavigationNextEvent());
                } else {
                    this.showToast(this.label.Error, this.label.VAT_Not_Found);
                }
            })
            .catch(error => {
                this.showToast(this.label.Error, error, 'error');
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

}