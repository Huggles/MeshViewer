/**
 * Created by hugovankrimpen on 17/03/2020.
 */

import {LightningElement, api} from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import Open_Business_Dossier from '@salesforce/label/c.Open_Business_Dossier';

export default class OpenRecordButton extends NavigationMixin(LightningElement) {

    @api
    recordId;

    label = {
        Open_Business_Dossier
    }

    handleOnClick() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                actionName: 'view'
            }
        });
    }
}