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

    columnKeyIterator = -1;
    get columnKeyIterator(){
        this.columnKeyIterator += 1;
        return this.columnKeyIterator;
    }


    m_numberOfColumns = 4;
    get sldsColumnSize(){
        return 'slds-size_1-of-'+this.m_numberOfColumns;
    }
    get columns(){
        let updateTypesCopy = JSON.parse(JSON.stringify(this.updateTypes));
        let result = [];
        for (let i = this.m_numberOfColumns; i > 0; i--) {
            result.push(updateTypesCopy.splice(0, Math.ceil(updateTypesCopy.length / i)));
        }
        return result;
        /*
        let returnValue = [];
        let itemsPerColumn = Math.ceil(this.updateTypes.length / this.m_numberOfColumns);
        console.log('itemspercolumn' + itemsPerColumn);
        let columnItems = [];
        for (var i = 0; i < this.updateTypes.length; i++) {
            let column = Math.floor(i / itemsPerColumn);
            let columnItemNumber = i % itemsPerColumn;
            columnItems.push(this.updateTypes[i]);
            if(columnItemNumber == 0 && columnItems.length > 0 || i == this.updateTypes.length - 1){
                //start new column || finish loop
                returnValue.push(columnItems);
                columnItems = [];
            }
        }
        console.log(returnValue);
        return returnValue;

         */
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