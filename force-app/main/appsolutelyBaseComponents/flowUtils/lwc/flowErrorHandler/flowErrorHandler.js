/**
 * Created by jaapbranderhorst on 23/02/2020.
 */

import {LightningElement, api} from 'lwc';

export default class FlowErrorHandler extends LightningElement {

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