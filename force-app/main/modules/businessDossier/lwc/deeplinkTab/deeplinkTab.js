/**
 * Created by tejaswinidandi on 19/05/2020.
 */

import {LightningElement, api, track, wire} from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import BUSINESS_DOSSIER from '@salesforce/schema/Account.Business_Dossier__c';
import DEEPLINK_URL from '@salesforce/schema/Account.Business_Dossier__r.Deeplink_URL__c';
import COUNTRY from '@salesforce/schema/Account.Business_Dossier__r.Registration_Country__c';

import Deeplink_Only_for_NL_Dossiers from '@salesforce/label/c.Deeplink_Only_for_NL_Dossiers';
import Create_Business_Dossier from '@salesforce/label/c.Create_Business_Dossier';
import Error from '@salesforce/label/c.Error';
import {ToastEventController} from "c/toastEventController";

export default class DeeplinkTab extends LightningElement {

    @api recordId;

    //deeplink value
    @track deeplinkUrl;

    //account record
    account;

    //business dossier record
    businessDossier;

    //dossier country
    country;

    label = {
        Create_Business_Dossier,
        Deeplink_Only_for_NL_Dossiers,
        Error
    }

    @wire(getRecord, { recordId: '$recordId', fields: [BUSINESS_DOSSIER, DEEPLINK_URL, COUNTRY] })
    accountRecord({ error, data }) {
        if (error) {
            let message = 'Unknown error';
            if (Array.isArray(error.body)) {
                message = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                message = error.body.message;
            }
            new ToastEventController(this).showErrorToastMessage(Error, message);
        } else if (data) {
            this.account = data;
            if (this.account.fields) {
                this.businessDossier = this.account.fields.appsolutely__Business_Dossier__c.value;

                let businessDossierRelation = this.account.fields.appsolutely__Business_Dossier__r.value;
                if (businessDossierRelation && businessDossierRelation.fields) {
                    this.country = businessDossierRelation.fields.appsolutely__Registration_Country__c.value;
                    this.deeplinkUrl = businessDossierRelation.fields.appsolutely__Deeplink_URL__c.value;
                }
            }
        }
    }
    
    get isDeeplinkUrlAvailable() {
        if (this.country == 'NL' && this.deeplinkUrl) {
            return true;
        }
        else {
            return false;
        }
    }


}