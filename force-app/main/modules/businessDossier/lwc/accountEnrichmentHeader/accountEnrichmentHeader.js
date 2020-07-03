/**
 * Created by hugovankrimpen on 17/03/2020.
 */

import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
import {FlowAttributeChangeEvent, FlowNavigationNextEvent} from 'lightning/flowSupport';
import {Features, checkAccess} from "c/featureAccessControl";
import {fireEvent} from "c/pubsub";

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
    businessDossier;

    @wire(getRecord, { recordId: '$businessDossierId', fields: [], optionalFields: [BUSINESS_DOSSIER_VAT, BUSINESS_DOSSIER_NO_VAT, BUSINESS_DOSSIER_COUNTRY, BUSINESS_DOSSIER_CREDITSAFE_COMPANY_REPORT] })
    businessDossierRecord({error, data}) {
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
            }
        }
    };

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

    _VATAccess;

    _CreditSafeAccess;

    connectedCallback() {
        checkAccess(Features.CREDITSAFE_GET_REPORT).then(result => {this._CreditSafeAccess = result});
        checkAccess(Features.DUTCH_VAT).then(result => {this._VATAccess = result});
    }

    get showVATButton() {
        return (this._VATAccess && !this.noVAT && (this.VATNumber === undefined || this.VATNumber === null || this.VATNumber === ''));
    }


    get showGetCreditsafeReportButton() {
        return this._CreditSafeAccess && (this.creditSafeReport == undefined || this.creditSafeReport == null);
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
        //throw an event to the child component(getCreditsafeReportChildComponent) of the aura component(getCreditsafeReportAction)
        fireEvent(null, 'getreportclicked');
    }

}