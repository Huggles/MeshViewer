/**
 * Created by hugovankrimpen on 17/06/2020.
 */

import {LightningElement, api} from 'lwc';

export default class UpdateTypeTile extends LightningElement {

    @api item;

    @api
    getStatus(){
        let toggle = this.template.querySelector("lightning-input[data-classification=update_type_toggle]");
        if(toggle != null){
            let response = {
                item : this.item,
                developerName : toggle.dataset.developerName,
                label : toggle.dataset.masterlabel,
                checked : toggle.checked,
            }
            return response;
        }
    }


}