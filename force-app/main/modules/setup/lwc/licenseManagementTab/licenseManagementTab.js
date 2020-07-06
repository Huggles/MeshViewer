/**
 * Created by jaapbranderhorst on 05/05/2020.
 */

import {LightningElement, wire} from 'lwc';
import {ToastEventController} from "c/toastEventController";
import {handleResponse} from "c/auraResponseWrapperHandler";

import getLicenseTypes from '@salesforce/apex/LicenseManagementTabController.getLicenseTypes';

import Loading from '@salesforce/label/c.Loading';
import Error from '@salesforce/label/c.Error';

export default class LicenseManagementTab extends LightningElement {
    label = {
        Loading,
        Error
    }

    licenseTypes;
    isLoading = false;

    connectedCallback() {
        //When the licenseTypes have not been loaded yet, show loading icon.
        //They can already be loaded during connectedCallback, as the getLicenseTypes is cachable and thus fires first.
        if(!this.licenseTypes){
            this.isLoading = true;
            getLicenseTypes()
                .then(result => {return handleResponse(result)})
                .then(data => {
                    this.licenseTypes = [];
                    for (const dataElement of data) {
                        this.licenseTypes = this.licenseTypes.concat({id: dataElement, name: dataElement});
                    }
                })
                .catch(error => {
                    let message;
                    if (error.message) {
                        message = error.message;
                    } else {
                        if (error.body.message) {
                            message = error.body.message;
                        }
                    }
                    new ToastEventController(this).showErrorToastMessage(this.label.Error, message);
                })
                .finally(() => {
                    this.isLoading = false
                });
        }
    }
}