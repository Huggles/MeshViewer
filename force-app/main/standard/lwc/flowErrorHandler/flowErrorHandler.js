/**
 * Created by jaapbranderhorst on 23/02/2020.
 */

import {LightningElement, api} from 'lwc';

export default class FlowErrorHandler extends LightningElement {

    @api
    availableActions;

    @api title = 'Sample Title';
    @api message = 'Sample Message';
    // @api variant = 'error';
    // @api autoCloseTime = 5000;
    // @api autoClose = false;
    // @api autoCloseErrorWarning = false;

    toastRendered = false;

    renderedCallback() {
        if (!this.toastRendered) {
            this.template.querySelector('c-custom-toast').showToast();
            this.toastRendered = true;
        }
    }

    // showToast() {
    //     const event = new ShowToastEvent({
    //         title: this.title,
    //         message: this.errorMessage
    //     });
    //     this.dispatchEvent(event);
    // }



}