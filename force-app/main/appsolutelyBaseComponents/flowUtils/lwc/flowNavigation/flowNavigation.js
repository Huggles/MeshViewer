/**
 * Created by tejaswinidandi on 10/03/2020.
 */

import { LightningElement, track, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Creditsafe_Report_Created from '@salesforce/label/c.Creditsafe_Report_Created';

export default class FlowNavigation extends NavigationMixin(LightningElement) {

    @api recordId;
    @api message;
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
            const event = new ShowToastEvent({
                "message": this.message,
                "variant": this.variant
            });
            this.dispatchEvent(event);
        })
    }

}