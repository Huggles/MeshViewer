/**
 * Created by Hugo on 13/08/2020.
 */
import {LightningElement, api, track} from 'lwc';

export default class MultiPickList extends LightningElement {

    @api label  = ''; //Name of the dropDown
    @api options;
    @api comboplaceholder = 'Select a value';

    @track _initializationCompleted = false;
    @track _selectedItems = 'Select a value';
    @track _filterValue;
    @track _mOptions;

    constructor () {
        super();
        this._filterValue = '';
    }
    renderedCallback () {
        let self = this;
        if (!this._initializationCompleted) {
            this.template.querySelector ('.ms-input').addEventListener ('click', function (event) {
                self.onDropDownClick(event.target);
                event.stopPropagation ();
            });
            this.template.addEventListener ('click', function (event) {
                event.stopPropagation ();
            });
            document.addEventListener ('click', function (event) {
                self.closeAllDropDown();
            });
            this._initializationCompleted = true;
            this.setPickListName ();
        }
    }
    handleItemSelected (event) {
        let self = this;
        this._mOptions.forEach (function (eachItem) {
            if (event.detail.item.value != null && eachItem.value == event.detail.item.value) {
                eachItem.selected = event.detail.selected;
                return;
            }
        });
        this.setPickListName ();
        this.onItemSelected ();
    }
    closeAllDropDown () {
        let dropdownHTMLElement = this.template.querySelector('[data-identifier="dropdownInput"]').classList.remove("slds-is-open");
    }

    onDropDownClick (dropDownDiv) {
        let classList = this.template.querySelector('[data-identifier="dropdownInput"]').classList;
        if(!classList.contains("slds-is-open")){
            this.closeAllDropDown();
            classList.add("slds-is-open");
        } else {
            this.closeAllDropDown();
        }
    }
    connectedCallback () {
        this.initArray (this);
    }
    initArray (context) {
        context._mOptions = new Array ();
        context.options.forEach((eachItem) => {
            context._mOptions.push(JSON.parse (JSON.stringify(eachItem)));
        });
    }
    setPickListName () {
        let selecedItems = this.getSelectedItems();
        let selections = '' ;
        if (selecedItems.length < 1) {
            selections = this.comboplaceholder;
        } else if (selecedItems.length > this.maxselected) {
            selections = selecedItems.length + ' Options Selected';
        } else {
            selecedItems.forEach (option => {
                selections += option.value+',';
            });
        }
        this._selectedItems = selections;
    }
    get dropdownLabel(){
        let label = '';

        let selecedItems = this.getSelectedItems();
        if (selecedItems.length < 1) {
            label = this.comboplaceholder;
        }
        else {
            label = selecedItems.length + ' Option(s) Selected';
        }
        return label;
    }
    @api
    getSelectedItems () {
        let resArray = new Array ();
        this._mOptions.forEach (function (eachItem) {
            if (eachItem.selected) {
                resArray.push (eachItem);
            }
        });
        return resArray;
    }

    onItemSelected () {
        let payload =  {
            detail : this.getSelectedItems ()
        }
        const evt = new CustomEvent ('itemselected', payload);

        this.dispatchEvent (evt);
    }


}