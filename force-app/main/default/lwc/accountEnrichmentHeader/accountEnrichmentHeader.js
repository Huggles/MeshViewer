/**
 * Created by hugovankrimpen on 17/03/2020.
 */

import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';

//Object fields
import BUSINESS_DOSSIER_VAT from '@salesforce/schema/Business_Dossier__c.VAT_Number__c';
import BUSINESS_DOSSIER_NO_VAT from '@salesforce/schema/Business_Dossier__c.No_VAT_Number__c';

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
import Error_Unknown from '@salesforce/label/c.Error_Unknown';
import Error_Incomplete from '@salesforce/label/c.Error_Incomplete';



export default class AccountEnrichmentHeader extends LightningElement {

    @api
    businessDossierId;

    @api
    accountRecord;

    @wire(getRecord, { recordId: '$businessDossierId', fields: [BUSINESS_DOSSIER_VAT, BUSINESS_DOSSIER_NO_VAT] })
    businessDossierRecord;

    showVAT = false;

    label = {
        VAT_Retrieve,
        Success,
        Dossier_Account_Update_Completed,
        VAT_Not_Found,
        Error,
        Error_Unknown,
        Error_Incomplete
    }
    staticResource = {
        companyInfoLogoSmall,
    }

    get showVATButton() {
        if(this.businessDossierRecord != null && this.businessDossierRecord.data != undefined)        {
            //If there is no VAT Number and the No_VAT_Number__c(known) is false.
            if(!this.businessDossierRecord.data.fields.appsolutely__VAT_Number__c.value &&
                !this.businessDossierRecord.data.fields.appsolutely__No_VAT_Number__c.value){
                return true;
            }
        }
        return false;
    }
    onDossierDeleted(event) {
        //Passing on the event
        const recordDeletedEvent = new CustomEvent('dossierdeleted');
        this.dispatchEvent(recordDeletedEvent);
    }
    handleOnClickVAT(event) {
        console.log('handleOnClickVAT');
        updateDossierWithVAT({
            dossierId: this.businessDossierId
        })
            .then(data => {
                console.log('result:'+ JSON.stringify(data));
                const dossierUpdatedEvent = new CustomEvent('dossierupdated');
                this.dispatchEvent(dossierUpdatedEvent);
                if (data.appsolutely__VAT_Number__c !== undefined) {
                    this.showToast(this.label.Success, this.label.Dossier_Account_Update_Completed, 'success');
                } else {
                    this.showToast(this.label.Success, this.label.VAT_Not_Found);
                }
            })
            .catch(error => {
                console.log('error:'+error);
                this.showToast(this.label.error, this.label.Error_Unknown, 'error');
            });
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