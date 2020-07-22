/**
 * Created by hugovankrimpen on 17/03/2020.
 */

import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { getFieldValue } from 'lightning/uiRecordApi';
import { refreshApex } from "@salesforce/apex";
import { ToastEventController } from "c/toastEventController";
import { FlowAttributeChangeEvent, FlowNavigationNextEvent} from 'lightning/flowSupport';
import { Features, checkAccess} from "c/featureAccessControl";
import { fireEvent} from "c/pubsub";

//Object fields
import BUSINESS_DOSSIER from '@salesforce/schema/Business_Dossier__c';
import BUSINESS_DOSSIER_POSITIONS_UPDATED_DATE from '@salesforce/schema/Business_Dossier__c.Business_Positions_Updated_Date__c';
import BUSINESS_DOSSIER_VAT from '@salesforce/schema/Business_Dossier__c.VAT_Number__c';
import BUSINESS_DOSSIER_NO_VAT from '@salesforce/schema/Business_Dossier__c.No_VAT_Number__c';
import BUSINESS_DOSSIER_COUNTRY from '@salesforce/schema/Business_Dossier__c.Registration_Country__c';
import BUSINESS_DOSSIER_CREDITSAFE_COMPANY_REPORT from '@salesforce/schema/Business_Dossier__c.Creditsafe_Company_Report__c';
import BUSINESS_DOSSIER_RECORD_TYPE from '@salesforce/schema/Business_Dossier__c.RecordType.DeveloperName';
import BUSINESS_DOSSIER_DEEPLINK from '@salesforce/schema/Business_Dossier__c.Deeplink_URL__c';

//Apex controllers
import updateDossierWithVAT from '@salesforce/apex/CompanyDetailsController.updateDossierWithVAT';
import updateDossierWithPositions from '@salesforce/apex/CompanyDetailsController.updateDossierWithPositions';
import deleteDossier from '@salesforce/apex/SearchAgainButtonController.deleteDossier';

//Static resources
import companyInfoLogoSmall from '@salesforce/resourceUrl/companyInfoLogoSmall';

//Labels
import Yes from '@salesforce/label/c.Yes';
import No from '@salesforce/label/c.No';
import Success from '@salesforce/label/c.Success';
import Error from '@salesforce/label/c.Error';
import VAT_Retrieve from '@salesforce/label/c.VAT_Retrieve';
import VAT_Not_Found from '@salesforce/label/c.VAT_Not_Found';
import Dossier_Account_Update_Completed from '@salesforce/label/c.Dossier_Account_Update_Completed';
import Get_Creditsafe_Report from '@salesforce/label/c.Get_Creditsafe_Report';
import Get_Positions from '@salesforce/label/c.Get_Positions';
import Business_Positions_Retrieved_Succesfully from '@salesforce/label/c.Business_Positions_Retrieved_Succesfully';
import Company_Info_Online_Portal_Button_Label from '@salesforce/label/c.Company_Info_Online_Portal_Button_Label';
import Search_Reset from '@salesforce/label/c.Search_Reset';
import Search_Again_Confirmation_Dialog_Message from '@salesforce/label/c.Search_Again_Confirmation_Dialog_Message';
import Search_Again_Confirmation_Dialog_Title from '@salesforce/label/c.Search_Again_Confirmation_Dialog_Title';



const OPTIONAL_BUSINESS_DOSSIER_RECORD_FIELDS = [
    BUSINESS_DOSSIER_VAT,
    BUSINESS_DOSSIER_NO_VAT,
    BUSINESS_DOSSIER_COUNTRY,
    BUSINESS_DOSSIER_CREDITSAFE_COMPANY_REPORT,
    BUSINESS_DOSSIER_POSITIONS_UPDATED_DATE,
    BUSINESS_DOSSIER_RECORD_TYPE,
    BUSINESS_DOSSIER_DEEPLINK
]

const CREDITSAFE_DOSSIER_RECORD_TYPE_NAME = 'Creditsafe';
const DUTCH_BUSINESS_DOSSIER_RECORD_TYPE_NAME = 'Dutch_Business';

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
     * Logic activates with this field being NULL, so setting default to false instead.
     */
    businessPositionsUpdatedDate = false;

    /**
     * The deeplink URL to the online portal.
     */
    deepLinkURL;

    /**
     * The retrieved business dossier
     */
    businessDossier;

    /**
     * boolean whether the component is loading something or not. Shows a spinner.
     */
    isLoading = false;

    /**
     * Booleans to define whether we can access certain elements or not.
     */
    _getPositionsAccess = false;
    _VATAccess = false;
    _CreditSafeAccess = false;
    _CIOnlineAccess = false;


    _businessDossierRecordResponse;

    /**
     * The name of the record type of the business dossier
     */
    _recordTypeName;

    @wire(getRecord, {recordId: '$businessDossierId',fields: [],optionalFields: OPTIONAL_BUSINESS_DOSSIER_RECORD_FIELDS})
    businessDossierRecord(response) {
        this._businessDossierRecordResponse = response;
        let error = response.error;
        let data = response.data;
        if (error) {
            let message = 'Unknown error';
            if (Array.isArray(error.body)) {
                message = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                message = error.body.message;
            }
            new ToastEventController(this).showErrorToastMessage(this.label.Error, error);
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
                if (this.businessDossier.fields.appsolutely__Deeplink_URL__c) {
                    this.deepLinkURL = this.businessDossier.fields.appsolutely__Deeplink_URL__c.value;
                }
                // if (this.businessDossier.fields.RecordType.DeveloperName) {
                    this._recordTypeName = getFieldValue(this.businessDossier, BUSINESS_DOSSIER_RECORD_TYPE);
                // }
            }
        }
    };

    label = {
        Yes,
        No,
        Error,
        Success,
        VAT_Retrieve,
        VAT_Not_Found,
        Dossier_Account_Update_Completed,
        Get_Creditsafe_Report,
        Get_Positions,
        Business_Positions_Retrieved_Succesfully,
        Company_Info_Online_Portal_Button_Label,
        Search_Reset,
        Search_Again_Confirmation_Dialog_Title,
        Search_Again_Confirmation_Dialog_Message,
    }
    staticResource = {
        companyInfoLogoSmall,
    }



    connectedCallback() {
        this.checkFeatureAccess();
    }

    renderedCallback() {
        if(this._confirmationDialog == null){
            this._confirmationDialog = this.template.querySelector('c-confirmation-dialog[data-name="searchAgainConfirmationModal"]');
        }
    }


    checkFeatureAccess(){
        Promise.all([
            checkAccess(Features.DUTCH_BUSINESS_POSITIONS),
            checkAccess(Features.DUTCH_VAT),
            checkAccess(Features.CREDITSAFE_GET_REPORT),
            checkAccess(Features.COMPANY_INFO_ONLINE)
        ])
            .then(results => {
                if(results != null && results.length == 4){
                    this._getPositionsAccess = results[0];
                    this._VATAccess = results[1];
                    this._CreditSafeAccess = results[2];
                    this._CIOnlineAccess = results[3];
                }
            })
            .catch(error => {
                new ToastEventController(this).showErrorToastMessage(this.label.Error, error);
            });
    }

    get showVATButton(){
        return (this._recordTypeName === DUTCH_BUSINESS_DOSSIER_RECORD_TYPE_NAME && this._VATAccess && !this.noVAT && (this.VATNumber == undefined || this.VATNumber == null || this.VATNumber == ''));
    }
    get showCreditSafeReportButton(){
        return (this._CreditSafeAccess && (this.creditSafeReport == undefined || this.creditSafeReport == null));
    }
    get showGetPositionsButton(){
        return (this._recordTypeName === DUTCH_BUSINESS_DOSSIER_RECORD_TYPE_NAME && this._getPositionsAccess && (this.businessPositionsUpdatedDate == null) );
    }
    get showCIOnlineButton(){
        return (this._recordTypeName === DUTCH_BUSINESS_DOSSIER_RECORD_TYPE_NAME && this._CIOnlineAccess);
    }

    handleMenuSelect(event){
        let selectedItemValue = event.detail.value;
        if(selectedItemValue === 'OnlinePortal'){
            this.handleOnCIOnlineClicked();
        }else if(selectedItemValue === 'GetPositions'){
            this.handleOnGetPositionsClicked();
        }else if(selectedItemValue === 'CreditSafeReport'){
            this.handleOnGetCreditsafeReport();
        }else if(selectedItemValue === 'VATRetrieve'){
            this.handleOnClickVAT();
        }else if(selectedItemValue === 'SearchAgain'){
            this.handleOnSearchAgainClicked();
        }

    }
    handleOnCIOnlineClicked(){
        if(this.deepLinkURL != null){
            window.open(this.deepLinkURL, '_blank');
        }
    }
    handleOnClickVAT() {
        this.retrieveVAT();
    }
    handleOnGetPositionsClicked(){
        this.retrievePositions();
    }
    handleOnGetCreditsafeReport() {
        //throw an event to the child component(getCreditsafeReportChildComponent) of the aura component(getCreditsafeReportAction)
        fireEvent(null, 'getreportclicked');
    }
    handleOnSearchAgainClicked(){
        this._confirmationDialog.show();
    }

    handleOnClickConfirmationDialog(event) {
        this._confirmationDialog.hide();
        if (event.detail.status != null && event.detail.status === 'confirm' && this.businessDossierId != null) {
            this.deleteCurrentDossier()
                .then(()=>{
                    this.searchAgainClicked = true;
                    const attributeChangeEvent = new FlowAttributeChangeEvent('searchAgainClicked', this.searchAgainClicked);
                    this.dispatchEvent(attributeChangeEvent);
                    //we throw an event because the flow needs to show a search form
                    this.dispatchEvent(new FlowNavigationNextEvent());
                });
        }
    }
    async deleteCurrentDossier(){
        this.isLoading = true;
        deleteDossier({dossierId: this.businessDossierId}).then(result => {
            Promise.resolve(result);
        }).catch(error => {
            new ToastEventController(this).showErrorToastMessage(this.label.Error, error);
            this.dispatchEvent(event);
            Promise.reject(error);
        }).finally(()=>{
            this.isLoading = false;
        })
    }

    retrieveVAT(){
        this.isLoading = true;
        updateDossierWithVAT({
            dossierId: this.businessDossierId
        })
            .then(data => {
                if (data.appsolutely__VAT_Number__c !== undefined) {
                    new ToastEventController(this).showSuccessToastMessage(this.label.Success, this.label.Dossier_Account_Update_Completed);
                    this.VATUpdated = true;
                    //we throw an event because we want to refresh the Account details view after VAT is updated
                    this.dispatchEvent(new FlowNavigationNextEvent());
                } else {
                    new ToastEventController(this).showErrorToastMessage(this.label.Error, this.label.VAT_Not_Found);
                }
            })
            .catch(error => {
                new ToastEventController(this).showErrorToastMessage(this.label.Error, error);
            })
            .finally(()=>{
                this.isLoading = false;
            });
    }

    retrievePositions(){
        this.isLoading = true;
        updateDossierWithPositions({
            dossierId: this.businessDossierId
        })
            .then(result => {
                new ToastEventController(this).showSuccessToastMessage(this.label.Success,this.label.Business_Positions_Retrieved_Succesfully);
                //Reload the business dossier to reload the buttons
                refreshApex(this._businessDossierRecordResponse);
            })
            .catch(error => {
                new ToastEventController(this).showErrorToastMessage(this.label.Error,error);
            })
            .finally(()=>{
                this.isLoading = false;
            })
    }

}