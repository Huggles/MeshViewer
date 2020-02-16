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
import {fireEvent, registerListener, unregisterAllListeners} from 'c/pubsub';

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
    @api
    cancelPressed = false;

    connectedCallback() {
        // the theory is that components fire a registration event AFTER the listener has been registered. For that the firing needs to be done from the renderedCallback method
        registerListener('componentRegistration', this.handleComponentRegistration, this);
        registerListener('componentValidationDone', this.handleComponentValidationDone, this);
        // open up registration of components
        fireEvent(this.pageRef, 'componentRegistrationOpen', this);
    }

    disconnectedCallback() {
        // unsubscribe from searchKeyChange event
        unregisterAllListeners(this);
    }

    registeredComponents = new Set();

    /**
     * Handle the registration of a component. The component will be notified if the user tries to press the next button
     * after which the component needs to validate himself and send an event back with the validation status
     * @param component
     */
    handleComponentRegistration(event) {
        if (event.component)
            this.registeredComponents.add(event.component);
    }

    validatedComponents;

    handleComponentValidationDone(event) {
        if (this.availableActions.find(action => action === 'NEXT')) { // should be true but just to be certain
            // check if validatedComponents exists, if not initialize it
            const component = event.component;
            const isValid = event.isValid;
            if (!this.validatedComponents) {
                this.validatedComponents = new Map();
                for (const registeredComponent of this.registeredComponents) {
                    this.validatedComponents.set(registeredComponent, {validated: false, isValid: false});
                }
            }
            this.validatedComponents.set(component, {validated: true, isValid: isValid});
            // check if all components have been validated and if they are all true. If so navigate to next

            let allValid = true;
            for (const validatedComponent of this.validatedComponents.values()) { // go through all values and see if all components are validated and valid
                if (!validatedComponent.validated || !validatedComponent.isValid) {
                    allValid = false;
                    break; // don't need to look further. We are not finished yet.
                }
            }
            if (allValid) { // ok everything is fine and we can move to the next thing in the flow
                const navigateNextEvent = new FlowNavigationNextEvent();
                this.dispatchEvent(navigateNextEvent);
            }
            // reset this.validatedComponents if necessary
            let resetValidationComponents = true;
            for (const validatedComponent of this.validatedComponents) {
                if (!validatedComponent.validated) {
                    resetValidationComponents = false;
                    break;
                }
            }
            if (resetValidationComponents) {
                this.validatedComponents = null;
            }

        }
    }

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
        if (this.availableActions.find(action => action === 'FINISH')) {
            const navigateFinishEvent = new FlowNavigationFinishEvent();
            this.dispatchEvent(navigateFinishEvent);
        } else { // no finish means next?
            this.cancelPressed = true;
            const navigateNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(navigateNextEvent);
        }
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
            // fire validationRequest, pageRef is undefined but just adhering to the current pubsup module,
            // makes it easier as soon as pageRef is supported on flow
            fireEvent(this.pageRef, 'validationRequest');
        }
    }


}