/**
 * Created by jaapbranderhorst on 26/06/2020.
 */

import {LightningElement, track} from 'lwc';

import {ToastEventController} from "c/toastEventController";
import getDataSourcesPerCountry from "@salesforce/apex/ConfigOrgPerCountryDataSourceController.getDataSourcesPerCountry";

import Save from '@salesforce/label/c.Save';

export default class ConfigOrganizationPerCountryDataSource extends LightningElement {

    labels = {
        Save
    }

    isLoading = false;

    @track
    _dataSourcesPerCountry;

    get dataSourcesPerCountry() {
        if (!this._dataSourcesPerCountry) {
            this.isLoading = true;
            this.retrieveDataSourcesPerCountry()
                .catch(error => {
                    new ToastEventController(this).showErrorToastMessage(null,error.message.body);
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
                this._dataSourcesPerCountry = result;
                Promise.resolve(result);
            })
            .catch(error => {
                Promise.reject(error);
            })
    }

}