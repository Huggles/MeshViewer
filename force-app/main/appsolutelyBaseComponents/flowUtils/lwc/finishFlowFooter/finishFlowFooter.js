/**
 * Created by tejaswinidandi on 09/03/2020.
 */

import {api, LightningElement} from 'lwc';
import Cancel from '@salesforce/label/c.Cancel';
import {FlowAttributeChangeEvent} from 'lightning/flowSupport';

export default class FinishFlowFooter extends LightningElement {
    @api
    availableActions = [];
    @api
    showNextButton = false;
    @api cancelPressed;

    label = {
        Cancel
    }

    handleCancelClick() {
        this.cancelPressed = true;
        const attributeChangeEvent = new FlowAttributeChangeEvent('cancelPressed', this.cancelPressed);
        this.dispatchEvent(attributeChangeEvent);
    }

}