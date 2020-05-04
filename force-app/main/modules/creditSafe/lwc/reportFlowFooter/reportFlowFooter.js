/**
 * Created by tejaswinidandi on 09/03/2020.
 */

import {api, LightningElement} from 'lwc';
import Cancel from '@salesforce/label/c.Cancel';
import Get_Creditsafe_Report from '@salesforce/label/c.Get_Creditsafe_Report';
import {FlowNavigationNextEvent, FlowNavigationFinishEvent, FlowAttributeChangeEvent} from 'lightning/flowSupport';

export default class ReportFlowFooter extends LightningElement {
    @api
    availableActions = [];

    @api cancelPressed;

    label = {
        Cancel,
        Get_Creditsafe_Report
    }

    handleNextClick(event) {
        const navigateNextEvent = new FlowNavigationNextEvent();
        this.dispatchEvent(navigateNextEvent);
    }

    handleCancelClick() {
        this.cancelPressed = true;
        const attributeChangeEvent = new FlowAttributeChangeEvent('cancelPressed', this.cancelPressed);
        this.dispatchEvent(attributeChangeEvent);
    }

}