/**
 * Created by jaapbranderhorst on 09/02/2020.
 */

/**
 * Flow footer. Gives more flexibility than the standard flow footer. Enables:
 *  - Custom titles of buttons
 *  - Cancel functionality
 *  - Blocking the next action when components on the same page do not validate
 */
import {LightningElement, api, wire} from 'lwc';
import {FlowAttributeChangeEvent, FlowNavigationBackEvent, FlowNavigationNextEvent, FlowNavigationPauseEvent, FlowNavigationFinishEvent} from 'lightning/flowSupport';
import {fireEvent, registerListener, unregisterAllListeners} from 'c/pubsub';

import COMPANY_INFO_LOGO from '@salesforce/resourceUrl/companyInfoLogoSmall'

export default class FlowFooter extends LightningElement {

    companyInfoLogo = COMPANY_INFO_LOGO;

    @api
    availableActions = [];

    get showNextButton() {
        return (this.availableActions.find(action => action === 'NEXT') || this.availableActions.find(action => action === 'FINISH'));
    }

    @api
    nextButtonTitle;
    @api
    nextButtonDisabled;

    get showPreviousButton() {
        return this.availableActions.find(action => action === 'BACK');
    }
    @api
    previousButtonTitle;

    get showPauseButton() {
        return this.availableActions.find(action => action === 'PAUSE');
    }
    @api
    pauseButtonTitle;
    @api
    showCancelButton;
    @api
    cancelButtonTitle;
    @api
    cancelPressed = false;

    /**
     * Handles the click on the pause button. Pauses the flow
     * @param event
     */
    handlePauseClick(event) {
        this.dispatchEvent(new CustomEvent('pauseclick'));
        if (this.availableActions.find(action => action === 'PAUSE')) {
            // navigate to the next screen
            const navigatePauseEvent = new FlowNavigationPauseEvent();
            this.dispatchEvent(navigatePauseEvent);
        }
    }

    handleCancelClick(event) {
        this.dispatchEvent(new CustomEvent('cancelclick'));
        if (this.availableActions.find(action => action === 'FINISH')) {
            const navigateFinishEvent = new FlowNavigationFinishEvent();
            this.dispatchEvent(navigateFinishEvent);
        } else { // no finish means next?
            const navigateNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(navigateNextEvent);
        }
    }

    handlePreviousClick(event) {
        this.dispatchEvent(new CustomEvent('previousclick'));
        if (this.availableActions.find(action => action === 'BACK')) {
            // navigate to the next screen
            const navigateBackEvent = new FlowNavigationBackEvent();
            this.dispatchEvent(navigateBackEvent);
        }
    }

    handleNextClick(event) {
        if (this.availableActions.find(action => action === 'NEXT')) {
            // fire validationRequest, pageRef is undefined but just adhering to the current pubsup module,
            // makes it easier as soon as pageRef is supported on flow
            this.dispatchEvent(new CustomEvent('nextclick'));
        }
    }


}