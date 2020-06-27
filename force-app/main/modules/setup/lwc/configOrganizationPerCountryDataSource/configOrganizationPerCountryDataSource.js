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

    connectedCallback() {
        this.isLoading = true;
        this.retrieveDataSourcesPerCountry()
            .catch(error =>{
                new ToastEventController(this).showErrorToastMessage(null,error.message.body);
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    @track dataSourcesPerCountry = []; // array of objects with a property country, an array of possible datasources (property datasource) and the chosen data source for the country
    async retrieveDataSourcesPerCountry(){
        await getDataSourcesPerCountry({})
            .then(result => {
                this.dataSourcesPerCountry = result;
                Promise.resolve(result);
            })
            .catch(error => {
                Promise.reject(error);
            })
    }

}