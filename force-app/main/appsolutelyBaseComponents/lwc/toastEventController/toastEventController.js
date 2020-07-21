/**
 * Created by Hugo on 22/06/2020.
 */

import {ShowToastEvent} from "lightning/platformShowToastEvent";

import Success from '@salesforce/label/c.Success';
import Error from '@salesforce/label/c.Error';
import {LightningElement} from "lwc";

class ToastEventController {
    caller;
    constructor(caller) {
        this.caller = caller;
    }


    ToastMessageVariant = {
        INFO : 'info',
        SUCCESS : 'success',
        WARNING : 'warning',
        ERROR : 'error'
    }
    ToastMessageMode = {
        DISMISSABLE : 'dismissable ', //remains visible until you click the close button or 3 seconds has elapsed, whichever comes first;
        PESTER : 'pester', //remains visible for 3 seconds and disappears automatically. No close button is provided;
        STICKY : 'sticky' //remains visible until you click the close button.
    }

    showToastMessage = (title, message, variant, mode) => {
        let payload = {}
        //Title
        if (title != null && title.length > 0) {
            payload['title'] = title;
        } else {
            if(variant == this.ToastMessageVariant.SUCCESS) {
                payload['title'] = Success;
            }
            if(variant == this.ToastMessageVariant.ERROR) {
                payload['title'] = Error;
            }
        }
        //Message
        if(message != null){
            if(typeof message === 'string' && message.length > 0){
                payload['message'] = message;
            }else if(typeof message === 'object' && message.body != null && message.body.message != null) {
                payload['message'] = message.body.message;
            }
        }

        //Variant
        if(variant != null && variant.length > 0){
            payload['variant'] = variant;
        }else{
            payload['variant'] = this.ToastMessageMode.DISMISSABLE;
        }

        //Mode
        if(mode != null && mode.length > 0){
            payload['mode'] = mode;
        }

        const evt = new ShowToastEvent(payload);
        this.caller.dispatchEvent(evt);
    }


    showSuccessToastMessage = (title, message) => {
        this.showToastMessage(title,message,this.ToastMessageVariant.SUCCESS,null);
    }
    showSuccessToastMessageDismissable = (title, message) => {
        this.showToastMessage(title,message,this.ToastMessageVariant.SUCCESS,this.ToastMessageMode.DISMISSABLE);
    }
    showErrorToastMessage = (title, message) => {
        this.showToastMessage(title,message,this.ToastMessageVariant.ERROR,null);
    }
    showErrorToastMessageDismissable = (title, message) => {
        this.showToastMessage(title,message,this.ToastMessageVariant.ERROR,this.ToastMessageMode.DISMISSABLE);
    }
}
export { ToastEventController }