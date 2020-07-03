/**
 * Created by jaapbranderhorst on 05/05/2020.
 */

import {LightningElement, wire} from 'lwc';
import {ToastEventController} from "c/toastEventController";

import getLicenseTypes from '@salesforce/apex/LicenseManagementTabController.getLicenseTypes';

import Loading from '@salesforce/label/c.Loading';
import Error from '@salesforce/label/c.Error';

export default class LicenseManagementTab extends LightningElement {
    label = {
        Loading,
        Error
    }

    licenseTypes = [];
    isLoading = false;

    @wire(getLicenseTypes)
    getLicenseTypes({error, data}) {
        this.isLoading = false;
        if (data) {
            for (const dataElement of data) {
                this.licenseTypes = this.licenseTypes.concat({id: dataElement, name: dataElement});
            }
        }
        if (error) {
            new ToastEventController(this).showErrorToastMessage(this.label.Error, error.body.message);
        }
    }

    connectedCallback() {
        //When the licenseTypes have not been loaded yet, show loading icon.
        //They can already be loaded during connectedCallback, as the getLicenseTypes is cachable and thus fires first.
        if(this.licenseTypes != null && this.licenseTypes.length == 0){
            this.isLoading = true;
        }
    }
}