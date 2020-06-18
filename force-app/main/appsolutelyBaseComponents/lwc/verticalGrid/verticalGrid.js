/**
 * Created by hugovankrimpen on 17/06/2020.
 */

import {LightningElement, api} from 'lwc';

export default class VerticalGrid extends LightningElement {

    m_numberOfColumns;
    @api
    get numberOfColumns(){
        return this.m_numberOfColumns;
    }
    set numberOfColumns(value){
        if((typeof value) == "string"){
            //This property passed as an DOM attribute is a string.
            this.m_numberOfColumns = parseInt(value);
        }
        if((typeof value) == "number"){
            this.m_numberOfColumns = value;
        }
    }

    m_items;
    @api
    get items(){
        return this.m_items;
    }
    set items( value ){
        this.m_items = value;
    }

    @api identifier;



    m_tileElements;
    renderedCallback() {
        this.handleChildData();
    }
    handleChildData(){
        let selector = '[data-identifier=\"'+this.identifier+'\"]';
        let tiles = this.querySelectorAll(selector);
        if(tiles != null){
            tiles.forEach((tile, tileIndex) => {
                tile.item = this.m_items[tileIndex];
            });
        }
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
        return 'slds-size_1-of-'+this.m_numberOfColumns;
    }
    get columns(){
        let itemListCopy = JSON.parse(JSON.stringify(this.items));
        let result = [];
        for (let i = this.m_numberOfColumns; i > 0; i--) {
            result.push(itemListCopy.splice(0, Math.ceil(itemListCopy.length / i)));
        }
        return result;
    }
}