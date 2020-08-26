/**
 * Created by Hugo on 25/08/2020.
 */

import {LightningElement, api, wire} from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import {ToastEventController} from "c/toastEventController";
import {FlowAttributeChangeEvent, FlowNavigationBackEvent, FlowNavigationNextEvent,
    FlowNavigationPauseEvent, FlowNavigationFinishEvent} from 'lightning/flowSupport';

import Success from '@salesforce/label/c.Success';
import Finish from '@salesforce/label/c.Finish';
import Successfully_Inserted_Business_Dossiers from '@salesforce/label/c.Successfully_Inserted_Business_Dossiers';
import Business_Dossier_Object from '@salesforce/schema/Business_Dossier__c';


export default class FindBusinessInsertResult extends LightningElement {
    @api insertedBusinessDossiers;
   insertedBusinessDossiersEnriched;

    labels = {
        Success,
        Finish,
        Successfully_Inserted_Business_Dossiers
    }

    availableFooterActions = [
        'NEXT'
    ]

    showFooterCancelButton = false;



    businessDossierFieldInfo;
    @wire(getObjectInfo, { objectApiName: Business_Dossier_Object })
    retrievebusinessDossierObjectInfo(response){
        if(response){
            if(response.data){
                this.businessDossierFieldInfo = response.data.fields;
            }else if(response.error){
                new ToastEventController(this).showErrorToastMessage(null, response.error);
            }
        }
    }

    hasRecords(){
        if(this.insertedBusinessDossiers != null && this.insertedBusinessDossiers.length > 0){
            return true;
        }
        return false;
    }

    connectedCallback() {
        this.createDossierLinks();
    }
    createDossierLinks(){
        this.insertedBusinessDossiersEnriched = JSON.parse(JSON.stringify(this.insertedBusinessDossiers));
        this.insertedBusinessDossiersEnriched.forEach((item, index)=>{
           item['IdLink'] = '/' + item['Id'];
        });
        console.log(this.insertedBusinessDossiersEnriched);
    }

    handleFooterNextClick(){
        const navigateNextEvent = new FlowNavigationNextEvent();
        this.dispatchEvent(navigateNextEvent);
    }
}