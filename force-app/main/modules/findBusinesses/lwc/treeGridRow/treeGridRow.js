/**
 * Created by Hugo on 10/08/2020.
 */

import {LightningElement, api} from 'lwc';

export default class TreeGridRow extends LightningElement {

    @api rowData;

    @api
    reloadData(){
        this.loadData();
        let children = this.template.querySelectorAll('c-tree-grid-row');
        children.forEach((child)=>{
            child.reloadData();
        })
    }

    isExpanded = false;
    isSelected = false;


    get ariaLevel(){
        if(this.rowData != null) return this.rowData.depth * 2;
        return 0;
    }
    get hasChildren(){
        if(this.rowData && this.rowData._children && Array.isArray(this.rowData._children)){
            return this.rowData._children.length > 0;
        }
        return false;
    }


    connectedCallback() {
        this.isExpanded = this.rowData.expanded;
    }
    renderedCallback() {
        this.loadData();
    }
    loadData(){
        if(this.isSelected != this.rowData.selected){
            this.isSelected = this.rowData.selected;
        }
    }


    onCheckboxClicked(event){
        let selected = event.target.checked;
        this.isSelected = true;
        this.dispatchEvent(new CustomEvent('rowselected',
            {
                detail : {
                    rowData : this.rowData,
                    selected : selected
                },
            })
        );
    }
    onChildCheckboxClicked(event){
        this.dispatchEvent(new CustomEvent('rowselected',
            {
                detail : {
                    rowData : event.detail.rowData,
                    selected : event.detail.selected
                }
            })
        );
    }
    onExpandButtonClicked(event){
        this.isExpanded = !this.isExpanded;
    }

}