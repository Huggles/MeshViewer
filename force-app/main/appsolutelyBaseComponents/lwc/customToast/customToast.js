/**
 * Created by jaapbranderhorst on 23/02/2020.
 */

import {api, LightningElement} from 'lwc';

export default class CustomToast extends LightningElement {

    @api title = 'Sample Title';
    @api variant = 'error';
    @api autoCloseTime = 5000;
    @api autoClose = false;
    @api autoCloseErrorWarning = false;
    @api message;
    @api showOnLoad;

    initialRendered;

    @api
    showToast() {
        const toastModel = this.template.querySelector('[data-id="toastModel"]');
        toastModel.className = 'slds-show';

        if(this.autoClose)
            if( (this.autoCloseErrorWarning && this.variant !== 'success') || this.variant === 'success') {
                this.delayTimeout = setTimeout(() => {
                    const toastModel = this.template.querySelector('[data-id="toastModel"]');
                    toastModel.className = 'slds-hide';
                }, this.autoCloseTime);

            }
    }

    renderedCallback() {
        if (this.showOnLoad && !this.initialRendered) {
            this.showToast();
            this.initialRendered = true;
        }
    }

    closeModel() {
        const toastModel = this.template.querySelector('[data-id="toastModel"]');
        this.message = null;
        toastModel.className = 'slds-hide';
    }

    get mainDivClass() {
        return 'slds-notify slds-notify_toast slds-theme_'+this.variant;
    }

    get messageDivClass() {
        return 'slds-icon_container slds-icon-utility-'+this.variant+' slds-icon-utility-success slds-m-right_small slds-no-flex slds-align-top';
    }
    get iconName() {
        return 'utility:'+this.variant;
    }

}