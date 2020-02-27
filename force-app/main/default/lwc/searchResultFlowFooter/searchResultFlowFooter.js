/**
 * Created by jaapbranderhorst on 27/02/2020.
 */

import {api, LightningElement} from 'lwc';
import Search_Confirm from '@salesforce/label/c.Search_Confirm';
import Cancel from '@salesforce/label/c.Cancel';
import Search_Reset from '@salesforce/label/c.Search_Reset';
import {registerListener, unregisterAllListeners} from "c/pubsub";
import {FlowNavigationNextEvent, FlowNavigationFinishEvent} from 'lightning/flowSupport';

export default class SearchResultFlowFooter extends LightningElement {

    @api
    availableActions = [];

    label = {
        Search_Confirm,
        Cancel,
        Search_Reset
    }

    connectedCallback() {
        registerListener('resultSelected', this.handleResultSelected, this);
    }

    disconnectedCallback() {
        unregisterAllListeners(this);
    }

    handleResultSelected(event) {
        const nextButtonDisabled = this.template.querySelector('c-flow-footer').nextButtonDisabled;
        this.template.querySelector('c-flow-footer').nextButtonDisabled = !nextButtonDisabled;
    }

    handleNextClick(event) {
        const nextButtonDisabled = this.template.querySelector('c-flow-footer').nextButtonDisabled;
        if (!nextButtonDisabled && (this.availableActions.find(action => action === 'NEXT') || this.availableActions.find(action => action === 'FINISH'))) {
            if (this.availableActions.find(action => action === 'NEXT')) {
                const navigateNextEvent = new FlowNavigationNextEvent();
                this.dispatchEvent(navigateNextEvent);
            } else { // FINISH
                const navigateFinishEvent = new FlowNavigationFinishEvent();
                this.dispatchEvent(navigateFinishEvent);
            }
        }
    }

}