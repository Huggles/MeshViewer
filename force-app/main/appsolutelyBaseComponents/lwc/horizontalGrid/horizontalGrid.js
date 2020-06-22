/**
 * Created by hugovankrimpen on 17/06/2020.
 */

import {LightningElement, api} from 'lwc';


export default class HorizontalGrid extends LightningElement {

    m_numberOfColumns;
    @api
    get numberOfColumns(){
        return this.m_numberOfColumns;
    }
    set numberOfColumns(value){
        if((typeof value) === "string"){
            //This property passed as an DOM attribute is a string.
            this.m_numberOfColumns = parseInt(value);
        }
        if((typeof value) === "number"){
            this.m_numberOfColumns = value;
        }
    }

    @api items;
    @api tileStyle;
    @api identifier;

    renderedCallback() {
        this.handleChildData();
    }
    handleChildData(){
        let selector = '[data-identifier=\"'+this.identifier+'\"]';
        let tiles = this.querySelectorAll(selector);
        if(tiles != null && tiles.length > 0){
            tiles.forEach((tile, tileIndex) => {


                tile.item = this.items[tileIndex];
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
    get tileContainerCss(){
        return 'slds-size_1-of-'+this.m_numberOfColumns;
    }
}