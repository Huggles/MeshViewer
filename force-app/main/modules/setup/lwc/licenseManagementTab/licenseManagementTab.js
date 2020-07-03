/**
 * Created by jaapbranderhorst on 05/05/2020.
 */

import {LightningElement, wire} from 'lwc';
import {ToastEventController} from "c/toastEventController";

import getLicenseTypes from '@salesforce/apex/LicenseManagementTabController.getLicenseTypes';

import Loading from '@salesforce/label/c.Loading';

export default class LicenseManagementTab extends LightningElement {

    label = {
        Loading
    }

    licenseTypes = [];
    isLoading;

    @wire(getLicenseTypes)
    getLicenseTypes({error, data}) {
        this.isLoading = false;
        if (data) {
            for (const dataElement of data) {
                this.licenseTypes = this.licenseTypes.concat({id: dataElement, name: dataElement});
            }
        }
        if (error) {
            new ToastEventController(this).showErrorToastMessage('Error', error.body.message);
        }
    }

    connectedCallback() {
        this.isLoading = true;
    }
}