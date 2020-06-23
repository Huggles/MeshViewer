/**
 * Created by tejaswinidandi on 10/03/2020.
 */

import { LightningElement, track, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Creditsafe_Report_Created from '@salesforce/label/c.Creditsafe_Report_Created';

export default class FlowNavigation extends NavigationMixin(LightningElement) {

    @api recordId;

    //Custom message that is shown as the toast message
    @api message;

    //Custom variant that is shown as the toast variant
    @api variant;

    connectedCallback() {
        new Promise((resolve, reject) => {this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                actionName: 'view',
            },
        });
            resolve("Success!")
        }).then((successMessage) => {
            let title = this.variant === 'success' ? 'Success!' : (this.variant === 'info' ? 'Information!' : (this.variant === 'error' ? 'Error!' : (this.variant === 'warning' ? 'Warning!' : '')));
            const event = new ShowToastEvent({
                "title" : title,
                "message": this.message,
                "variant": this.variant
            });
            this.dispatchEvent(event);
        })
    }

}