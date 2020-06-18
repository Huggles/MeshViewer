/**
 * Created by hugovankrimpen on 17/06/2020.
 */

import {LightningElement, api} from 'lwc';
import {ShowToastEvent} from "lightning/platformShowToastEvent";

export default class HorizontalGrid extends LightningElement {

    m_numberOfColumns;
    @api
    get numberOfColumns(){
        return this.m_numberOfColumns;
    }
    set numberOfColumns(value){
        if((typeof value) == "string"){
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
    @api equalizeTileHeight = "false";



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

    showToast(title, message, variant){
        const event = new ShowToastEvent({
            "title": "Error!",
            "message": "Vertical List can only have 1 root node in the tile slot.",
            "variant": "error"
        });
        this.dispatchEvent(event);
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
    get gridContainerCss(){
        if(this.equalizeTileHeight == "true"){
            return 'equalHMVWrap eqWrap';
        }
        else{
            return '';
        }
    }
    get tileContainerCss(){
        return this.sldsTileWidth;
    }
    get sldsTileWidth(){
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
    get rows(){
        let itemListCopy = JSON.parse(JSON.stringify(this.items));
        let result = [];
        while(itemListCopy.length > 0){
            result.push(itemListCopy.splice(0, this.m_numberOfColumns));
        }
        return result;
    }
}