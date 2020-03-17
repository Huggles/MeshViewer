/**
 * Created by jaapbranderhorst on 05/03/2020.
 */

import {LightningElement, api} from 'lwc';
import deleteDossier from '@salesforce/apex/SearchAgainButtonController.deleteDossier';

import No from '@salesforce/label/c.No';
import Yes from '@salesforce/label/c.Yes';
import Search_Reset from '@salesforce/label/c.Search_Reset';
import Search_Again_Confirmation_Dialog_Message from '@salesforce/label/c.Search_Again_Confirmation_Dialog_Message';
import Search_Again_Confirmation_Dialog_Title from '@salesforce/label/c.Search_Again_Confirmation_Dialog_Title';

export default class SearchAgainButton extends LightningElement {

    label = {
        No,
        Yes,
        Search_Reset,
        Search_Again_Confirmation_Dialog_Title,
        Search_Again_Confirmation_Dialog_Message
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
                deleteDossier({dossierId: this.dossierId});
                const recordDeletedEvent = new CustomEvent('dossierdeleted');
                this.dispatchEvent(recordDeletedEvent);
            }
            if (event.detail.status === 'cancel') {
                this.confirmDialogVisible = false;
            }
        }
    }
}