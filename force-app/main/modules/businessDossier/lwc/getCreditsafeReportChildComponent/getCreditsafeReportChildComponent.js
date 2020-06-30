/**
 * Created by tejaswinidandi on 25/06/2020.
 */

import {LightningElement} from 'lwc';
import {fireEvent, registerListener, unregisterAllListeners} from 'c/pubsub';

export default class GetCreditsafeReportChildComponent extends LightningElement {

    connectedCallback() {
        registerListener('getreportclicked', this.handleGetReport, this);
    }

    handleGetReport() {
        let clicked = true;
        const getReportEvent = new CustomEvent('getreport', {
            detail: {clicked},
        });
        // Fire the custom event
        this.dispatchEvent(getReportEvent);
    }
}