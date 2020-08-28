/**
 * Created by Hugo on 27/08/2020.
 * Requires a map of items (@api items;)
 * Example:
 {
   "Id_Item_One" : {
      "id"    :   "Id_Item_One"
      "label" :   "Label_Item_One"
   }
 }
 */

import {LightningElement, api, track} from 'lwc';


import Select_All from '@salesforce/label/c.Select_All'
import Remove_All from '@salesforce/label/c.Remove_All'

export default class BulkInput extends LightningElement {


    /*
     * The labels used in this screen
     */
    labels = {
        Select_All,
        Remove_All
    }
    @api items;
    @api inputLabel;

    _maxSelectable = 0;
    @api
    get maxSelectable(){
        return this._maxSelectable;
    }
    set maxSelectable(value){
        if((typeof value) === "string"){
            //This property passed as an DOM attribute is a string.
            this._maxSelectable = parseInt(value);
        }
        else if((typeof value) === "number"){
            this._maxSelectable = value;
        }
    }
    get hasMaxSelectable(){
        if(this.maxSelectable > 0 ) return true;
        return false;
    }
    get numberSelected(){
        return this.selectedItemsArray.length;
    }


    @api addSelectedItem(itemId){
        if(this.selectedItems[itemId] == null && this.numberSelected < this.maxSelectable){
            this.selectedItems[itemId] = this.items[itemId];
            this.dispatchItemClickedEvent(itemId, true);
            this.findMatches();
        }else if(this.numberSelected > this.maxSelectable) {
            //Make sure to have all parents deselect the item again.
            this.dispatchItemClickedEvent(itemId, false);
        }
    }
    @api removeSelectedItem(itemId){
        if(this.selectedItems[itemId] != null){
            delete this.selectedItems[itemId];
            this.dispatchItemClickedEvent(itemId, false);
            this.findMatches();
        }
    }

    @track selectedItems = {};
    get selectedItemsArray(){
        let returnArray = [];
        for (const [key, value] of Object.entries(this.selectedItems)) {
            returnArray.push(value);
        }
        return returnArray;
    }

    @track matchingItems = {};
    get matchingItemsArray(){
        let returnArray = [];
        for (const [key, value] of Object.entries(this.matchingItems)) {
            returnArray.push(value);
        }
        return returnArray;
    }

    onSearchInputChange(event){
        this.findMatches();
    }

    async findMatches(){
        let matchingItems = {};
        let searchString = this.template.querySelector('lightning-input').value;
        if(searchString.length > 1){
            for (const [key, value] of Object.entries(this.items)) {
                if(this.selectedItems[value.id] == null && (value.id.toString().startsWith(searchString) || value.label.includes(searchString))){
                    matchingItems[value.id] = value;
                }
            }
        }
        this.matchingItems = matchingItems;
    }

    get showMatches(){
        if(this.matchingItems != null && this.matchingItemsArray.length > 0 && (this._searchInputHasFocus || this._searchResultsHasFocus)){
            return true;
        }
        return false;
    }

    onSelectAllClick(event){
        for (const [key, value] of Object.entries(this.matchingItems)) {
            this.addSelectedItem(value.id);
        }
        this.findMatches();
    }
    onMatchingItemClick(event){
        let itemId = event.currentTarget.dataset['id'].toString();
        this.addSelectedItem(itemId);
    }
    onRemoveItemClick(event){
        let itemId = event.currentTarget.dataset['id'].toString();
        this.removeSelectedItem(itemId);
    }
    onRemoveAllSelectedItems(event) {
        for (const [key, value] of Object.entries(this.selectedItems)) {
            this.dispatchItemClickedEvent(value.id, false);
        }
        this.selectedItems = {};
    }

    dispatchItemClickedEvent(itemId, selected){
        let payload = {
            detail : {
                id : itemId,
                selected : selected
            }
        }
        let event = new CustomEvent ('itemclick', payload);
        this.dispatchEvent(event);
    }



    get hasSelectedItems(){
        if(this.selectedItemsArray.length > 0) return true;
        return false;
    }

    @track _searchInputHasFocus = false;
    onSearchInputFocusIn(event){
        this._searchInputHasFocus = true;
    }
    onSearchInputFocusOut(event){
        //Set it after 100ms so we give the page time to detect whether we selected the results or not.
        setTimeout(()=>{
            if(this._searchResultsHasFocus == false);
                this._searchInputHasFocus = false;
        },100);

    }

    @track _searchResultsHasFocus = false;
    onSearchResultsFocusIn(event){
        this._searchResultsHasFocus = true;
    }
    onSearchResultsFocusOut(event){
        this._searchResultsHasFocus = false;
    }



}