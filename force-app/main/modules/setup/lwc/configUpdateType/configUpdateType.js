/**
 * Created by Hugo on 02/06/2020.
 */

import { LightningElement, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import {ShowToastEvent} from "lightning/platformShowToastEvent";


//Labels
import Error from '@salesforce/label/c.Error';
import Success from '@salesforce/label/c.Success';
import Update_types from '@salesforce/label/c.Update_types';


//Apex Classes
import getUpdateTypes from '@salesforce/apex/CompanyInfoUpdateTypeController.getUpdateTypes';
import setUpdateTypes from '@salesforce/apex/CompanyInfoUpdateTypeController.setUpdateTypes';

export default class ConfigUpdateType extends LightningElement {
    @track options = [];
    @track values = [];

    isLoading = false;

    labels = {
        Error,
        Success,
        Update_types
    }

    connectedCallback() {
        this.isLoading = true;
        this.retrieveUpdateTypes();
    }

    @track updateTypes = [];
    retrieveUpdateTypes(){
        getUpdateTypes({})
            .then(result => {
                console.log(result);
                this.updateTypes = result;
                this.isLoading = false;
            })
            .catch(error => {
                const event = new ShowToastEvent({
                    title: this.labels.Error,
                    message: error,
                    variant: 'error'
                });
                this.dispatchEvent(event);
                this.isLoading = false;
            })
    }
    handleUpdateTypesSave(event){
        this.isLoading = true;
        let toggles = this.template.querySelectorAll("lightning-input[data-classification=update_type_toggle]");
        if(toggles != null){
            let payload = [];
            toggles.forEach((toggle, index) => {
                let payloadItem = {
                    checked : toggle.checked,
                    developerName : toggle.dataset.developerName,
                    label : toggle.dataset.masterlabel
                }
                payload.push(payloadItem);
            });
            setUpdateTypes({payload : payload})
                .then(result =>{
                    const event = new ShowToastEvent({
                        title: this.labels.Success,
                        variant: 'success'
                    });
                    this.dispatchEvent(event);
                    this.isLoading = false;
                })
                .catch(error =>{
                    const event = new ShowToastEvent({
                        title: this.labels.Error,
                        message: error,
                        variant: 'error'
                    });
                    this.dispatchEvent(event);
                    this.isLoading = false;
                })
        }

    }

}