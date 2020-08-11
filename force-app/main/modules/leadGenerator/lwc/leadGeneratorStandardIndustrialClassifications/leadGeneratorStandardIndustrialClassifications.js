/**
 * Created by Hugo on 10/08/2020.
 */


/**
 * Created by Hugo on 10/08/2020.
 */

import {LightningElement, track} from 'lwc';
import {ToastEventController} from "c/toastEventController";

import SBIData from '@salesforce/resourceUrl/SBICodes';

export default class LeadGeneratorStandardIndustrialClassifications extends LightningElement {


    @track treeGridData = [];
    @track treeGridColumns = [
        {
            type: 'text',
            fieldName: 'description',
            label: 'Description',
        },
        {
            type: 'text',
            fieldName: 'label',
            label: 'SBI Code',
        }
        ];

    @track selectedRows = [];


    @track _sbiData;

    connectedCallback() {
        this.loadSBIData()
            .then((result)=>{

                try {
                    this.treeGridData = this.initTreeGridData();
                }catch (e) {
                    console.log(e);
                    new ToastEventController(this).showErrorToastMessage('Error', e);
                }
            });
    }

    async loadSBIData(){
        try {
            let request = new XMLHttpRequest();
            request.open("GET", SBIData, false);
            request.send(null);
            this._sbiData = JSON.parse(request.responseText);
            Promise.resolve(this._sbiData);
        }catch (e){
            new ToastEventController(this).showErrorToastMessage('Error', e);
        }
    }
    initTreeGridData(){
        if(this._sbiData != null){
            let data = this._initTreeGridData(null, null);
            console.log(data);
            return data;
        }
    }
    _initTreeGridData(parentCode, parentIndex){
        let records = [];
        let indexCounter = 0;
        this._sbiData.forEach((sbi, childIndex) => {
            if(sbi.parent == parentCode){
                let treeGridRow = {
                    name : sbi.code,
                    description : sbi.description,
                    label : sbi.label,
                    code : sbi.code,
                    depth : sbi.depth,
                    expanded : false,
                    selected : false,
                    index : parentIndex === null ? indexCounter.toString() : parentIndex+'.'+indexCounter.toString(),
                }
                let children = this._initTreeGridData(sbi.code, treeGridRow.index);
                if(children.length > 0) treeGridRow['_children'] = children;
                records.push(treeGridRow);
                indexCounter +=1;
            }
        });

        return records;
    }
    onRowSelected(event){
        let rowData = event.detail.rowData;
        let selected = event.detail.selected;
        this.setHierarchySelected(rowData, selected);
        let children = this.template.querySelectorAll('c-tree-grid-row');
        children.forEach((child)=>{
            child.reloadData();
        })
    }
    setHierarchySelected(row, selected){
        let indexes = row.index.split('.');
        if(indexes.length <= 0){
            console.log('error!!!!');
        }
        indexes = indexes.map(x=>+x);
        let targetRecord = this.treeGridData[indexes[0]];
        indexes.shift();
        indexes.forEach((index) => {
            targetRecord = targetRecord._children[index];
        });
        targetRecord.selected = selected;
        if(row._children != null){
            row._children.forEach((child) => {
                this.setHierarchySelected(child,selected);
            });
        }
    }

    getSelectedSBICodes(){
        this.selectedSBICodes = [];
        this.getSelectedSBICode(this.treeGridData);
        console.log(JSON.stringify(this.selectedSBICodes));
    }
    getSelectedSBICode(row){
        row.forEach((row, index) => {
            if(row.selected){
                this.selectedSBICodes.push(row.code);
            }
            if(row._children != null && row._children.length > 0){
                this.getSelectedSBICode(row._children);
            }
        });
    }
}