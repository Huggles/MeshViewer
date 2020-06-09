/**
 * Created by tejaswinidandi on 26/05/2020.
 */

import {LightningElement, track, api, wire} from 'lwc';
import {FlowAttributeChangeEvent, FlowNavigationNextEvent, FlowNavigationFinishEvent} from 'lightning/flowSupport';
import { NavigationMixin } from 'lightning/navigation';
import {registerListener} from "c/pubsub";
import { ShowToastEvent } from 'lightning/platformShowToastEvent'

import createDuplicateAccount from '@salesforce/apex/CreateDuplicatesController.createDuplicateAccount';

import Duplicates_Found_Message from '@salesforce/label/c.Duplicates_Found_Message';
import Duplicate_Account_Created from '@salesforce/label/c.Duplicate_Account_Created';
import Create_New_Account from '@salesforce/label/c.Create_New_Account';
import Update_Duplicate_Account from '@salesforce/label/c.Update_Duplicate_Account';
import Success from '@salesforce/label/c.Success';
import Error from '@salesforce/label/c.Error';
import Cancel from '@salesforce/label/c.Cancel';

export default class AccountListTable extends NavigationMixin(LightningElement) {

    @api accountList;
    @api selectedResult;
    @api showCreateNewAccount;
    @api newAccount;
    @api updateDuplicateAccount = false;
    @api cancelClicked = false;

    @track disableUpdate = true;

    label = {
        Duplicates_Found_Message,
        Create_New_Account,
        Update_Duplicate_Account,
        Cancel
    }

    connectedCallback() {
        registerListener('resultselected', this.handleResultSelected, this);
        registerListener('resultunselected', this.handleResultUnSelected, this);
        this.data = this.accountList;
    }

    handleClickDuplicateAccount() {
        this.updateDuplicateAccount = true;
        const attributeChangeEvent = new FlowAttributeChangeEvent('updateDuplicateAccount', this.updateDuplicateAccount);
        this.dispatchEvent(attributeChangeEvent);
        this.dispatchEvent(new FlowNavigationNextEvent());
    }

    handleClickCreateNewAccount() {
        createDuplicateAccount({account: this.newAccount}).then(result => {
            if (result) {
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: result,
                        actionName: 'view',
                    },
                });
                this.showToast(Success, Duplicate_Account_Created, 'success');
            }
        }).catch(error => {
            this.error = error;
            this.showToast(Error, error, 'error');
        })
    }

    handleClickCancel() {
        this.cancelClicked = true;
        const attributeChangeEvent = new FlowAttributeChangeEvent('cancelClicked', this.cancelClicked);
        this.dispatchEvent(attributeChangeEvent);
        this.dispatchEvent(new FlowNavigationNextEvent());
    }

    handleResultSelected(event) {
        this.disableUpdate = false;
    }

    handleResultUnSelected(event) {
        this.disableUpdate = true;
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            "title": title,
            "message": message,
            "variant": variant
        });
        this.dispatchEvent(event);
    }

}