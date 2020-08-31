/**
 * Created by Hugo on 27/08/2020.
 * Requires a map of items (@api items;)

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

    /*
     * The items the user can select.
     * Example:
     * {
     *   "Id_Item_One" : {
     *      "id"    :   "Id_Item_One"
     *      "label" :   "Label_Item_One"
     *   }
     * }
     */
    @api items;
    @api inputLabel;

    _maxSelectable = 0;
    @api
    get maxSelectable(){
        return this._maxSelectable;
    }
    set maxSelectable(value){
        if((typeof value) === "string"){
            //Properties passed as an DOM attribute are a string.
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

    /*
     * Allows other components to select items in this list.
     * The component must be aware of the Item Ids
     */
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

    /*
    * Allows other components to deselect items in this list.
    * The component must be aware of the Item Ids
    */
    @api removeSelectedItem(itemId){
        if(this.selectedItems[itemId] != null){
            delete this.selectedItems[itemId];
            this.dispatchItemClickedEvent(itemId, false);
            this.findMatches();
        }
    }


    /*
    * Stores key value pairs of the selected items
    */
    @track selectedItems = {};

    /*
     * returns the selected item map as an array for display
     */
    get selectedItemsArray(){
        let returnArray = [];
        for (const [key, value] of Object.entries(this.selectedItems)) {
            returnArray.push(value);
        }
        return returnArray;
    }

    /*
    * Stores key value pairs of the matching items during search
    */
    @track matchingItems = {};

    /*
     * returns the matching item map as an array for display
     */
    get matchingItemsArray(){
        let returnArray = [];
        for (const [key, value] of Object.entries(this.matchingItems)) {
            returnArray.push(value);
        }
        return returnArray;
    }


    /*
     * When search input changes, call the findMatches function to update the matches list.
     */
    onSearchInputChange(event){
        this.findMatches();
    }


    /*
     * Finds matching records based on the input of the search field. This is done asynchronously to avoid lag.
     */
    async findMatches(){
        let matchingItems = {};
        let searchString = this.template.querySelector('lightning-input').value.toLowerCase();
        if(searchString.length > 1){
            for (const [key, value] of Object.entries(this.items)) {
                if(this.selectedItems[value.id] == null && (value.id.toString().toLowerCase().startsWith(searchString) || value.label.toLowerCase().includes(searchString))){
                    matchingItems[value.id] = value;
                }
            }
        }
        this.matchingItems = matchingItems;
    }

    /*
     * Whether the matching items list should be shown or not.
     * This depend on whether there are matching items and what element has focus.
     */
    get showMatches(){
        if(this.matchingItems != null && this.matchingItemsArray.length > 0 && (this._searchInputHasFocus || this._searchResultsHasFocus)){
            return true;
        }
        return false;
    }

    /*
     * Whether any items have already been selected
     */
    get hasSelectedItems(){
        if(this.selectedItemsArray.length > 0) return true;
        return false;
    }

    /*
     * When Select All is clicked in the result list.
     * Adds all items to the selected map.
     */
    onSelectAllClick(event){
        for (const [key, value] of Object.entries(this.matchingItems)) {
            this.addSelectedItem(value.id);
        }
        this.findMatches();
    }

    /*
     * When a single item in the result list is clicked.
     * Adds the item to the selected map.
     */
    onMatchingItemClick(event){
        let itemId = event.currentTarget.dataset['id'].toString();
        this.addSelectedItem(itemId);
    }

    /*
    * When a single item in the pills list is removed.
    * Removes the item from the selected map.
    */
    onRemoveItemClick(event){
        let itemId = event.currentTarget.dataset['id'].toString();
        this.removeSelectedItem(itemId);
    }

    /*
      * When Remove All is clicked below the search input.
      * Removes all items from the selected map.
      */
    onRemoveAllSelectedItems(event) {
        for (const [key, value] of Object.entries(this.selectedItems)) {
            this.dispatchItemClickedEvent(value.id, false);
        }
        this.selectedItems = {};
    }

    /*
      * Dispatches an event to parent elements to notify them an item has been selected.
      * Parent elements can use this to process the selected items using onitemclicked={} attribute
      */
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

    /*
     * Functions that register whether this element is focused or not. Required to determine whether to show the results list or not.
     */
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