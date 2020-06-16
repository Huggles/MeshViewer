/**
 * Created by jaapbranderhorst on 05/05/2020.
 */

import {LightningElement, wire} from 'lwc';
import getLicenseTypes from '@salesforce/apex/LicenseManagementTabController.getLicenseTypes';

export default class LicenseManagementTab extends LightningElement {

    licenseTypes = [];

    error;

    @wire(getLicenseTypes)
    getLicenseTypes({error, data}) {
        if (data) {
            for (const dataElement of data) {
                this.licenseTypes = this.licenseTypes.concat({id: dataElement, name: dataElement});
            }
            this.error = undefined;
        }
        if (error) {
            this.error = error;
        }
    }



}