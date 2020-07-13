/**
 * Created by jaapbranderhorst on 05/03/2020.
 */

import {LightningElement, api} from 'lwc';
import deleteDossier from '@salesforce/apex/SearchAgainButtonController.deleteDossier';
import deleteInternationalAddress from '@salesforce/apex/SearchAgainButtonController.deleteInternationalAddress';

import No from '@salesforce/label/c.No';
import Yes from '@salesforce/label/c.Yes';
import Search_Reset from '@salesforce/label/c.Search_Reset';
import Error_Title from '@salesforce/label/c.Error_Title';
import Search_Again_Confirmation_Dialog_Message from '@salesforce/label/c.Search_Again_Confirmation_Dialog_Message';
import Search_Again_Confirmation_Dialog_Title from '@salesforce/label/c.Search_Again_Confirmation_Dialog_Title';
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import {refreshApex} from "@salesforce/apex";

export default class SearchAgainButton extends LightningElement {

    label = {
        No,
        Yes,
        Search_Reset,
        Search_Again_Confirmation_Dialog_Title,
        Search_Again_Confirmation_Dialog_Message,
        Error_Title
    }

    /**
     * The record id of the dossier to remove
     */
    @api
    dossierId;

    /**
     * The record id of the international address to remove
     */
    @api
    internationalAddressId;

    @api
    searchAgainClicked = false;

    isLoading = false;

    _confirmationDialog;

    renderedCallback() {
        if(this._confirmationDialog == null){
            this._confirmationDialog = this.template.querySelector('c-confirmation-dialog');
        }
    }

    handleOnClick() {
        this._confirmationDialog.show();
    }

    handleOnClickConfirmationDialog(event) {
        this._confirmationDialog.hide();
        if (event.detail.status) {
            if (event.detail.status === 'confirm') {
                // delete the record
                if (this.dossierId) {
                    this.isLoading = true;
                    deleteDossier({dossierId: this.dossierId}).then(result => {
                        this.searchAgainClicked = true;
                        this.dispatchEvent(new CustomEvent('searchagainclicked'));
                    }).catch(error => {
                        this.error = error;
                        const event = new ShowToastEvent({
                            "title": this.label.Error_Title,
                            "message": this.error,
                            "variant": 'error',
                            "mode": 'sticky'
                        });
                        this.dispatchEvent(event);
                    }).finally(()=>{
                        this.isLoading = false;
                    })
                }
                if (this.internationalAddressId) {
                    this.isLoading = true;
                    deleteInternationalAddress({internationalAddressId: this.internationalAddressId}).then(result => {
                        this.searchAgainClicked = true;
                        this.dispatchEvent(new CustomEvent('searchagainclicked'));
                    }).catch(error => {
                        this.error = error;
                        const event = new ShowToastEvent({
                            "title": this.label.Error_Title,
                            "message": this.error,
                            "variant": 'error',
                            "mode": 'sticky'
                        });
                        this.dispatchEvent(event);
                    }).finally(()=>{
                        this.isLoading = false;
                    })
                }
            }
        }
    }
}