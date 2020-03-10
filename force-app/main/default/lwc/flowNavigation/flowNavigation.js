/**
 * Created by tejaswinidandi on 10/03/2020.
 */

import { LightningElement, track, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class Example extends NavigationMixin(LightningElement) {

    @api
    recordId;

    connectedCallback() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                actionName: 'view',
            },
        });
    }
}