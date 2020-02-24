/**
 * Created by appsolutely on 20/02/2020.
 */

import {api, LightningElement, wire} from 'lwc';

export default class InternationalAddressCardTile extends LightningElement {
    @api iconname = 'action:new_note';
    @api internationalAddressData ;

    handleClick(event){
        event.preventDefault();
        this.iconname = 'action:approval';
        const selectIconEvent = new CustomEvent('selectitem', {detail: this.internationalAddressData});
        this.dispatchEvent(selectIconEvent);
   }


}