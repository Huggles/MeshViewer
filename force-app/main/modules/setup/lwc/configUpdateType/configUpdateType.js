/**
 * Created by Hugo on 02/06/2020.
 */

import { LightningElement, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

import getUpdateSettings from '@salesforce/apex/UpdateSettingSelector.getUpdateSettings';
import setUpdateSettings from '@salesforce/apex/UpdateSettingSelector.setUpdateSettings';

export default class ConfigUpdateType extends LightningElement {
    @track options = [];
    @track values = [];

    connectedCallback() {
        this.retrieveUpdateSettings();

    }

    retrieveUpdateSettings(){
        getUpdateSettings({})
            .then(result => {
                let items = [];
                for (const property in result) {
                    console.log(property);
                    if(property.includes('appsolutely__')){
                        console.log('pushing!');
                        this.options.push({
                            label: property,
                            value: property
                        });
                    }
                }
            })
            .catch(error => {
                console.log(error);
            })
    }
    setupDualListBox(){

    }

}