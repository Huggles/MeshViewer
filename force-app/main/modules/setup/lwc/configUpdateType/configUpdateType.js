/**
 * Created by Hugo on 02/06/2020.
 */

import { LightningElement, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';


//Labels
import Error from '@salesforce/label/c.Error';
import Success from '@salesforce/label/c.Success';
import Update_settings from '@salesforce/label/c.Update_settings';
import Update_settings_available from '@salesforce/label/c.Update_settings_available';
import Update_settings_selected from '@salesforce/label/c.Update_settings_selected';
import Update_settings_help from '@salesforce/label/c.Update_settings_help';
import Update_settings_help_link from '@salesforce/label/c.Update_settings_help_link';
import Update_types from '@salesforce/label/c.Update_types';


//Apex Classes
import getUpdateSettings from '@salesforce/apex/UpdateSettingSelector.getUpdateSettings';
import setUpdateSettings from '@salesforce/apex/UpdateSettingSelector.setUpdateSettings';

export default class ConfigUpdateType extends LightningElement {
    @track options = [];
    @track values = [];

    isLoading = false;

    labels = {
        Error,
        Success,
        Update_settings,
        Update_settings_available,
        Update_settings_selected,
        Update_settings_help,
        Update_settings_help_link
    }

    connectedCallback() {
        this.isLoading = true;
        this.retrieveUpdateSettings();
    }

    updateSettingWrappers = [];
    retrieveUpdateSettings(){
        getUpdateSettings({})
            .then(result => {
                this.updateSettingWrappers = result;
                this.setupDualListBox(result);
            })
            .catch(error => {
                console.log(error);
            })
    }
    setupDualListBox(updateSettingWrappers){
        console.log(updateSettingWrappers);
        updateSettingWrappers.forEach((wrapper, index) => {
            this.options.push({
                label: wrapper.label,
                value: wrapper.apiName
            });
            if(wrapper.value == true){
                this.values.push(wrapper.apiName);
            }
            this.isLoading = false;
        });
    }
    handleUpdateSettingChange(event){
        this.isLoading = true;
        let selectedValues = event.detail.value;

        //First get all wrapper objects based on what is selected
        let trueValues = this.updateSettingWrappers.filter(function(wrapper) {
            return selectedValues.includes(wrapper.apiName);
        });
        let falseValues = this.updateSettingWrappers.filter(function(wrapper) {
            return !selectedValues.includes(wrapper.apiName);
        });

        //Then set all wrapper object values based on what is selected
        trueValues.forEach((wrapper, index) => {
            wrapper.value = true;
        });
        falseValues.forEach((wrapper, index) => {
            wrapper.value = false;
        });

        //Combine both arrays
        let allUpdatedValues = trueValues.concat(falseValues);

        //Pass it to the server
        setUpdateSettings({ wrappers : allUpdatedValues })
            .then(result => {
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

}