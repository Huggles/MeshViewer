/**
 * Created by jaapbranderhorst on 26/06/2020.
 */

import {LightningElement, track} from 'lwc';
import {ToastEventController} from "c/toastEventController";

export default class ConfigOrganizationPerCountryDataSource extends LightningElement {

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

    @track dataSourcePerCountry = []; // array of objects with a property country, an array of possible datasources (property datasource) and the chosen data source for the country
    async retrieveDataSourcesPerCountry(){
        await getDataSourcesPerCountry({})
            .then(result => {
                this.dataSourcePerCountry = result;
                Promise.resolve(result);
            })
            .catch(error => {
                Promise.reject(error);
            })
    }

}