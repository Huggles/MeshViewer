/**
 * Created by jaapbranderhorst on 05/03/2020.
 */

import {LightningElement, api} from 'lwc';
import deleteDossier from '@salesforce/apex/SearchAgainButtonController.deleteDossier';

import Cancel from '@salesforce/label/c.Cancel';
import Search_Confirm from '@salesforce/label/c.Search_Confirm';
import Search_Reset from '@salesforce/label/c.Search_Reset';

export default class SearchAgainButton extends LightningElement {

    label = {
        Cancel,
        Search_Confirm,
        Search_Reset
    }

    /**
     * The record id of the dossier to remove
     */
    @api
    dossierId;

    /**
     * True if the confirm dialog is shown
     */
    confirmDialogVisible = false;

    handleOnClick() {
        this.confirmDialogVisible = true; // would be better to encapsulate this in a method on the confirm dialog itself
    }

    handleOnClickConfirmationDialog(event) {
        if (event.detail.status) {
            if (event.detail.status === 'confirm') {
                // delete the record
                deleteDossier(this.dossierId).catch(error => {});
            }
            // we don't care about the other statuses (cancel).
            // this.confirmDialogVisible = false;
        }
    }
}