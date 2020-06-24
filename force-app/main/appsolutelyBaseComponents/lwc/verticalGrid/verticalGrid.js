/**
 * Created by hugovankrimpen on 17/06/2020.
 */

import {LightningElement, api} from 'lwc';

export default class VerticalGrid extends LightningElement {

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

    @api items;
    @api identifier;


    _loadedChildren = false;
    renderedCallback() {
        this.loadChildData();
    }
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

    @api
    get numberOfItems(){
        return this.items.length;
    }

    columnKeyIterator = -1;
    get columnKeyIterator(){
        this.columnKeyIterator += 1;
        return this.columnKeyIterator;
    }
    rowKeyIterator = -1;
    get rowKeyIterator(){
        this.rowKeyIterator += 1;
        return this.rowKeyIterator;
    }

    get sldsColumnSize(){
        return 'slds-size_1-of-'+this._numberOfColumns;
    }
    get columns(){
        let itemListCopy = JSON.parse(JSON.stringify(this.items));
        let result = [];
        for (let i = this._numberOfColumns; i > 0; i--) {
            result.push(itemListCopy.splice(0, Math.ceil(itemListCopy.length / i)));
        }
        return result;
    }
}