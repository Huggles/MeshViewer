/**
 * Created by Hugo on 02/06/2020.
 */

import { LightningElement, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import {ShowToastEvent} from "lightning/platformShowToastEvent";


//Labels
import Error from '@salesforce/label/c.Error';
import Save from '@salesforce/label/c.Save';
import Update_types from '@salesforce/label/c.Update_types';
import Update_types_explanation from '@salesforce/label/c.Update_types_explanation';

//Apex Classes
import getUpdateTypes from '@salesforce/apex/CompanyInfoUpdateTypeController.getUpdateTypes';
import setUpdateTypes from '@salesforce/apex/CompanyInfoUpdateTypeController.setUpdateTypes';

export default class ConfigUpdateType extends LightningElement {
    @track options = [];
    @track values = [];

    isLoading = false;

    labels = {
        Error,
        Save,
        Update_types,
        Update_types_explanation
    }

    connectedCallback() {
        this.isLoading = true;
        this.retrieveUpdateTypes();
    }

    @track updateTypes = [];
    retrieveUpdateTypes(){
        getUpdateTypes({})
            .then(result => {
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
        let tiles = this.template.querySelectorAll("c-update-type-tile[data-identifier='updateType'");
        if(tiles != null){
            let payload = [];
            tiles.forEach((tile, index) => {
                let tileStatus = tile.getStatus();
                let payloadItem = {
                    checked : tileStatus.checked,
                    developerName : tileStatus.developerName,
                    label : tileStatus.label
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