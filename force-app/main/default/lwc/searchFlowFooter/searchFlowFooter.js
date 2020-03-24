/**
 * Created by jaapbranderhorst on 26/02/2020.
 */

import {LightningElement, api} from 'lwc';
import Search_Confirm from '@salesforce/label/c.Search_Confirm';
import Cancel from '@salesforce/label/c.Cancel';
import Previous from '@salesforce/label/c.Previous';
import {FlowAttributeChangeEvent, FlowNavigationNextEvent, FlowNavigationFinishEvent} from 'lightning/flowSupport';
import {fireEvent, registerListener, unregisterAllListeners} from "c/pubsub";

export default class SearchFlowFooter extends LightningElement {

    @api
    availableActions = [];

    label = {
        Search_Confirm,
        Cancel,
        Previous
    }

    @api cancelPressed;

    @api showCancelButton;

    registeredComponents = new Set();

    validatedComponents;

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

    /**
     * Handle the registration of a component. The component will be notified if the user tries to press the next button
     * after which the component needs to validate himself and send an event back with the validation status
     * @param component
     */
    handleComponentRegistration(event) {
        if (event.component)
            this.registeredComponents.add(event.component);
    }

    handleComponentValidationDone(event) {
        if (this.availableActions.find(action => action === 'NEXT') || this.availableActions.find(action => action === 'FINISH')) { // should be true but just to be certain,
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
                if (this.availableActions.find(action => action === 'NEXT')) {
                    const navigateNextEvent = new FlowNavigationNextEvent();
                    this.dispatchEvent(navigateNextEvent);
                } else { // FINISH
                    const navigateFinishEvent = new FlowNavigationFinishEvent();
                    this.dispatchEvent(navigateFinishEvent);
                }
            }
            // reset this.validatedComponents if necessary
            let resetValidationComponents = true;
            for (const validatedComponent of this.validatedComponents.values()) {
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

    handleNextClick(event) {
        fireEvent(null, 'validationRequest');
    }

    handleCancelClick() {
        this.cancelPressed = true;
        const attributeChangeEvent = new FlowAttributeChangeEvent('cancelPressed', this.cancelPressed);
        this.dispatchEvent(attributeChangeEvent);
    }

}