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

export default class DeeplinkTab extends LightningElement {

    @api recordId;
    @track deeplinkUrl;

    @wire(getRecord, { recordId: '$recordId', fields: [BUSINESS_DOSSIER, DEEPLINK_URL, COUNTRY] })
    accountRecord;

    label = {
        Create_Business_Dossier,
        Deeplink_Only_for_NL_Dossiers
    }


    get isBusinessDossierAvailable() {
        if (this.accountRecord != null && this.accountRecord != undefined && this.accountRecord.data != undefined) {
            if (this.accountRecord.data.fields.appsolutely__Business_Dossier__c.value &&
                this.accountRecord.data.fields.appsolutely__Business_Dossier__c.value != undefined) {
                return true;
            }
            else {
                return false;
            }
        }
    }

    get isDeeplinkUrlAvailable() {
        let businessDossier = this.accountRecord.data.fields.appsolutely__Business_Dossier__r.value.fields;
        if (businessDossier.appsolutely__Registration_Country__c.value == 'NL' &&
            businessDossier.appsolutely__Deeplink_URL__c.value  &&
            businessDossier.appsolutely__Deeplink_URL__c.value != undefined) {
            this.deeplinkUrl = businessDossier.appsolutely__Deeplink_URL__c.value;
            return true;
        }
        else {
            return false;
        }
    }


}