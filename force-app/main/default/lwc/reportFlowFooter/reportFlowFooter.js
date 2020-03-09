/**
 * Created by tejaswinidandi on 09/03/2020.
 */

import {api, LightningElement} from 'lwc';
import Cancel from '@salesforce/label/c.Cancel';
import Previous from '@salesforce/label/c.Previous';
import {FlowNavigationNextEvent, FlowNavigationFinishEvent} from 'lightning/flowSupport';

export default class ReportFlowFooter extends LightningElement {
    @api
    availableActions = [];

    @api cancelPressed;
    @api showCancelButton;

    label = {
        Cancel,
        Previous
    }

    handleNextClick(event) {
        const navigateNextEvent = new FlowNavigationNextEvent();
        this.dispatchEvent(navigateNextEvent);

    }

}