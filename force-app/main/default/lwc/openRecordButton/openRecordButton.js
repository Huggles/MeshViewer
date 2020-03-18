/**
 * Created by hugovankrimpen on 17/03/2020.
 */

import {LightningElement, api} from 'lwc';
import {NavigationMixin} from 'lightning/navigation';

export default class OpenRecordButton extends NavigationMixin(LightningElement) {

    @api
    recordId;

    @api
    label;

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