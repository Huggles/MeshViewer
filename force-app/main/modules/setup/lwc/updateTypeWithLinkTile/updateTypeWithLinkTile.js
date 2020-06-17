/**
 * Created by hugovankrimpen on 17/06/2020.
 */

import {LightningElement, api} from 'lwc';

export default class UpdateTypeWithLinkTile extends LightningElement {
    @api item;

    handleClick(){
        const cardClickedEvent = new CustomEvent('click', { detail : 'abc' });
        console.log(' launching event ');
        this.dispatchEvent(cardClickedEvent);
    }
}