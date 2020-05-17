/**
 * Created by tejaswinidandi on 01/05/2020.
 */

import {LightningElement, api} from 'lwc';

export default class FlowSuccessHandler extends LightningElement {

    @api
    availableActions;

    @api title = 'Sample Title';
    @api message = 'Sample Message';

    toastRendered = false;

    renderedCallback() {
        if (!this.toastRendered) {
            this.template.querySelector('c-custom-toast').showToast();
            this.toastRendered = true;
        }
    }

}