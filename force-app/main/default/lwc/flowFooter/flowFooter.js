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
import {FlowNavigationBackEvent, FlowNavigationNextEvent, FlowNavigationPauseEvent, FlowNavigationFinishEvent} from 'lightning/flowSupport';

export default class FlowFooter extends LightningElement {

    @api
    availableActions = [];

    @api
    get showNextButton() {
        return this.availableActions.find(action => action === 'NEXT');
    }
    @api
    nextButtonTitle = 'Next';
    @api
    get showPreviousButton() {
        return this.availableActions.find(action => action === 'PREVIOUS');
    }
    @api
    previousButtonTitle;
    @api
    get showPauseButton() {
        return this.availableActions.find(action => action === 'PAUSE');
    }
    @api
    pauseButtonTitle = 'Pause';
    @api
    showCancelButton;
    @api
    cancelButtonTitle = 'Cancel';

    /**
     * Handles the click on the pause button. Pauses the flow
     * @param event
     */
    handlePauseClick(event) {
        if (this.availableActions.find(action => action === 'PAUSE')) {
            // navigate to the next screen
            const navigatePauseEvent = new FlowNavigationPauseEvent();
            this.dispatchEvent(navigatePauseEvent);
        }
    }

    handleCancelClick(event) {
        // TODO: check if this always works
        const navigateFinishEvent = new FlowNavigationFinishEvent();
        this.dispatchEvent(navigateFinishEvent);
    }

    handlePreviousClick(event) {
        if (this.availableActions.find(action => action === 'PREVIOUS')) {
            // navigate to the next screen
            const navigateBackEvent = new FlowNavigationBackEvent();
            this.dispatchEvent(navigateBackEvent);
        }
    }

    handleNextClick(event) {
        if (this.availableActions.find(action => action === 'NEXT')) {
            // navigate to the next screen
            const navigateNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(navigateNextEvent);
        }
    }



}