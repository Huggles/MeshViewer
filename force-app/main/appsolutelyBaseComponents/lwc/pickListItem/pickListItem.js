/**
 * Created by Hugo on 13/08/2020.
 */


import { LightningElement, track, api } from 'lwc';
export default class PickListItem extends LightningElement {
    @api item;

    constructor () {
        super();
    }
    connectedCallback () {
        this._item =  JSON.parse(JSON.stringify (this.item));
    }
    get itemClass () {
        return 'slds-listbox__item ms-list-item' + (this.item.selected ? ' slds-is-selected' : '');
    }
    onItemSelected (event) {
        let payload = {
            detail : {
                item :this.item,
                selected : !this.item.selected
            }
        }

        const evt = new CustomEvent ('items', payload);
        this.dispatchEvent (evt);
        event.stopPropagation();
    }


}