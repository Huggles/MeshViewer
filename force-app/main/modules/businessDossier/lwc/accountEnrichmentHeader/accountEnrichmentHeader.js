/**
 * Created by hugovankrimpen on 17/03/2020.
 */

import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
import {FlowAttributeChangeEvent, FlowNavigationNextEvent} from 'lightning/flowSupport';
import {Features, checkAccess} from "c/featureAccessControl";

//Object fields
import BUSINESS_DOSSIER_POSITIONS_UPDATED_DATE from '@salesforce/schema/Business_Dossier__c.Business_Positions_Updated_Date__c';
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
import Get_Creditsafe_Report from '@salesforce/label/c.Get_Creditsafe_Report';
import Get_Positions from '@salesforce/label/c.Get_Positions';
import No from '@salesforce/label/c.No';
import Yes from '@salesforce/label/c.Yes';

const OPTIONAL_BUSINESS_DOSSIER_RECORD_FIELDS = [
    BUSINESS_DOSSIER_VAT,
    BUSINESS_DOSSIER_NO_VAT,
    BUSINESS_DOSSIER_COUNTRY,
    BUSINESS_DOSSIER_CREDITSAFE_COMPANY_REPORT,
    BUSINESS_DOSSIER_POSITIONS_UPDATED_DATE
]

export default class AccountEnrichmentHeader extends LightningElement {

    @api
    businessDossierId;

    @api
    accountRecord;

    @api
    searchAgainClicked;

    @api
    getCreditsafeReportClicked = false;

    @api
    VATUpdated = false;

    /**
     * Contains the VAT number
     */
    VATNumber;

    /**
     * True if no vat number is known. If VAT number is null and no vat is true, there is no vat number known.
     */
    noVAT;

    /**
     * The country of the business dossier
     */
    country;

    /**
     * The creditsafe report id
     */
    creditSafeReport;

    /**
     * The retrieved business dossier
     */
    businessPositionsUpdatedDate;

    /**
     * The retrieved business dossier
     */
    businessDossier;

    //
    _getPositionsAccess = false;
    _VATAccess = false;
    _CreditSafeAccess = false;


    @wire(getRecord, {
        recordId: '$businessDossierId',
        fields: [],
        optionalFields: OPTIONAL_BUSINESS_DOSSIER_RECORD_FIELDS
    })
    businessDossierRecord({error, data}) {
        console.log(data);
        console.log(error);
        if (error) {
            let message = 'Unknown error';
            if (Array.isArray(error.body)) {
                message = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                message = error.body.message;
            }
            this.showToast(this.label.Error, error, 'error');
        } else if (data) {
            this.businessDossier = data;
            if (this.businessDossier.fields) {
                if (this.businessDossier.fields.appsolutely__Registration_Country__c) {
                    this.country = this.businessDossier.fields.appsolutely__Registration_Country__c.value;
                }
                if (this.businessDossier.fields.appsolutely__VAT_Number__c) {
                    this.VATNumber = this.businessDossier.fields.appsolutely__VAT_Number__c.value;
                }
                if (this.businessDossier.fields.appsolutely__No_VAT_Number__c) {
                    this.noVAT = this.businessDossier.fields.appsolutely__No_VAT_Number__c.value;
                }
                if (this.businessDossier.fields.appsolutely__Creditsafe_Company_Report__c) {
                    this.creditSafeReport = this.businessDossier.fields.appsolutely__Creditsafe_Company_Report__c.value;
                }
                if (this.businessDossier.fields.appsolutely__Business_Positions_Updated_Date__c) {
                    this.businessPositionsUpdatedDate = this.businessDossier.fields.appsolutely__Business_Positions_Updated_Date__c.value;
                }
            }
        }
    };

    label = {
        VAT_Retrieve,
        Success,
        Dossier_Account_Update_Completed,
        VAT_Not_Found,
        Error,
        Get_Creditsafe_Report,
        Get_Positions,
        Yes,
        No,

    }
    staticResource = {
        companyInfoLogoSmall,
    }

    connectedCallback() {
        this.checkFeatureAccess();
    }
    checkFeatureAccess(){
        Promise.all([
            checkAccess(Features.DUTCH_BUSINESS_POSITIONS),
            checkAccess(Features.DUTCH_VAT),
            checkAccess(Features.CREDITSAFE_GET_REPORT)
        ])
            .then(results => {
                if(results != null && results.length == 3){
                    this._getPositionsAccess = results[0];
                    this._VATAccess = results[1];
                    this._CreditSafeAccess = results[2];
                }
            })
            .catch(error => {
                this.showToast(this.label.Error, error, 'error');
            });
    }

    get showVATButton(){
        return (this._VATAccess && !this.noVAT && (this.VATNumber == undefined || this.VATNumber == null || this.VATNumber == ''));
    }
    get showCreditSafeReportButton(){
        return (this._CreditSafeAccess && (this.creditSafeReport == undefined || this.creditSafeReport == null));
    }
    get showGetPositionsButton(){
        return (this._getPositionsAccess && (this.businessPositionsUpdatedDate == null) );
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
        const attributeChangeEvent = new FlowAttributeChangeEvent('searchAgainClicked', this.searchAgainClicked);
        this.dispatchEvent(attributeChangeEvent);
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
        const attributeChangeEvent = new FlowAttributeChangeEvent('getCreditsafeReportClicked', this.getCreditsafeReportClicked);
        this.dispatchEvent(attributeChangeEvent);
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