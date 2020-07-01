/**
 * Created by Hugo on 02/06/2020.
 */

import { LightningElement, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import {ToastEventController} from 'c/toastEventController'


//Labels
import Update_types_Saved from '@salesforce/label/c.Update_types_Saved';
import Save from '@salesforce/label/c.Save';
import Update_types from '@salesforce/label/c.Update_types';
import Update_types_explanation from '@salesforce/label/c.Update_types_explanation';
import Update_types_URL from '@salesforce/label/c.Update_types_URL';
import URL_link_text from '@salesforce/label/c.URL_link_text';

//Apex Classes
import getUpdateTypes from '@salesforce/apex/ConfigUpdateTypeController.getUpdateTypes';
import setUpdateTypes from '@salesforce/apex/ConfigUpdateTypeController.setUpdateTypes';


export default class ConfigUpdateType extends LightningElement {
    @track options = [];
    @track values = [];

    isLoading = false;

    labels = {
        Save,
        Update_types,
        Update_types_explanation,
        Update_types_Saved,
        Update_types_URL,
        URL_link_text
    }

    connectedCallback() {
        this.isLoading = true;
        this.retrieveUpdateTypes()
            .catch(error =>{
                new ToastEventController(this).showErrorToastMessage(null,error.message.body);
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    @track updateTypes = [];

    async retrieveUpdateTypes(){
        await getUpdateTypes({})
            .then(result => {
                this.updateTypes = result;
                Promise.resolve(result);
            })
            .catch(error => {
                Promise.reject(error);
            })
    }
    handleUpdateTypesSave(event){
        this.isLoading = true;
        let tiles = this.template.querySelectorAll("c-update-type-tile[data-identifier='updateType']");
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
            this.saveUpdateTypes(payload)
                .then(result =>{
                    new ToastEventController(this).showSuccessToastMessage(null,this.labels.Update_types_Saved);
                })
                .catch(error =>{
                    new ToastEventController(this).showErrorToastMessage(null,error.message.body);
                })
                .finally(() => {
                    this.isLoading = false;
                });
        }
    }
    async saveUpdateTypes(payload){
        await setUpdateTypes({payload : payload})
            .then(result =>{
                Promise.resolve(result);
            })
            .catch(error =>{
                Promise.reject(error);
            })
    }
}