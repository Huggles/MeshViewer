/**
 * Created by jaapbranderhorst on 26/06/2020.
 */

import {LightningElement, track} from 'lwc';

import {ToastEventController} from "c/toastEventController";
import getDataSourcesPerCountry from "@salesforce/apex/ConfigOrgPerCountryDataSourceController.getDataSourcesPerCountry";
import setDataSourcePerCountry from "@salesforce/apex/ConfigOrgPerCountryDataSourceController.setDataSourcePerCountry";
import {handleResponse} from "c/auraResponseWrapperHandler";
import JobSubmitMessage from "@salesforce/label/c.Job_Submitted";

import Save from '@salesforce/label/c.Save';

export default class dataSourcesPerCountryList extends LightningElement {

    labels = {
        Save,JobSubmitMessage
    }

    isLoading = false;

    @track
    _dataSourcesPerCountry;

    get dataSourcesPerCountry() {
        if (!this._dataSourcesPerCountry) {
            this.isLoading = true;
            this.retrieveDataSourcesPerCountry()
                .catch(error => {
                    new ToastEventController(this).showErrorToastMessage(null,error.message);
                })
                .finally(this.isLoading = false);
            return new Array();
        } else {
            return this._dataSourcesPerCountry;
        }
    }

    async retrieveDataSourcesPerCountry(){
        await getDataSourcesPerCountry({})
            .then(result => {
                return handleResponse(result);
            })
            .then(result => {
                this._dataSourcesPerCountry = result;
                Promise.resolve(result);
            })
            .catch(error => {
                Promise.reject(error);
            })
    }

    handleSaveButtonClick(event){
        this.isLoading = true;
        let tiles = this.template.querySelectorAll('c-data-source-per-country-tile[data-identifier="dataSourcePerCountry"]');
        if(tiles != null){
            let payload = [];
            tiles.forEach((tile, index) => {
                let selectedDataSource = tile.selectedDataSource;
                let countryCode = tile.countryCode;
                let payloadItem = {
                    selectedDataSource : selectedDataSource,
                    countryCode : countryCode
                }
                payload.push(payloadItem);
            });
            try {
                this.save(payload);
            } catch(error) {
                new ToastEventController(this).showErrorToastMessage(null,error.message);
            } finally {
                this.isLoading = false;
            }
        }
    }

    async save(payload){
        await setDataSourcePerCountry({dataSourcesPerCountries: payload})
            .then(result =>{
                new ToastEventController(this).showSuccessToastMessage(null,this.labels.JobSubmitMessage);
                return result;
            })
            .catch(error =>{
                return error;
            })
    }

}