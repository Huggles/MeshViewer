/**
 * Created by hugovankrimpen on 17/06/2020.
 */

import {LightningElement, api} from 'lwc';

import {deepCopyFunction} from 'c/deepCloneUtils';


export default class HorizontalGrid extends LightningElement {

    _numberOfColumns;
    @api
    get numberOfColumns(){
        return this._numberOfColumns;
    }
    set numberOfColumns(value){
        if((typeof value) === "string"){
            //This property passed as an DOM attribute is a string.
            this._numberOfColumns = parseInt(value);
        }
        if((typeof value) === "number"){
            this._numberOfColumns = value;
        }
    }

    /**
     * The 'raw' items. The items stored in this property are not distributed over rows or columns
     */
    _items;

    @api
    get items() {
        return this._items;
    };
    set items(value) {
        if (value && Array.isArray(value)) {
            // add keys to the items
            const items = deepCopyFunction(value);
            let counter = 0;
            items.forEach(item => {
                item.key = counter;
                counter++;
            });
            this._items = items;
        }else {
            throw 'value ' + value + ' is null or not an array';
        }
    }

    @api identifier;

    renderedCallback() {
        this.loadChildData();
    }

    /**
     * flag indicating if the children have been loaded (true) or not (false)
     * @type {boolean}
     * @private
     */
    _loadedChildren = false;

    loadChildData(){
        //if children havn't been rendered yet, do not try to load them.
        let selector = '[data-identifier=\"'+this.identifier+'\"]';
        let tiles = this.querySelectorAll(selector);
        if(tiles != null && tiles.length > 0){
            //Only load them once.
            if(this._loadedChildren === false){
                this._loadedChildren = true;
                tiles.forEach((tile, tileIndex) => {
                    tile.item = this.items[tileIndex];
                });
            }
        }
    }

    @api
    reloadChildData(){
        this._loadedChildren = false;
        this.loadChildData();
    }

    get tileContainerCss(){
        return 'slds-col slds-size_1-of-'+this._numberOfColumns;
    }


}