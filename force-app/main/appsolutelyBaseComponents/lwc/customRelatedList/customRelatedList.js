/**
 * Created by Hugo on 23/06/2020.
 */

import {LightningElement, api, track, wire} from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import getChildRecords from '@salesforce/apex/CustomRelatedListController.getChildRecords'



export default class CustomRelatedList extends LightningElement {


    @api relationshipField;
    @api childRecordFields;
    @api childRecordsObjectDeveloperName;
    @api parentRecordId;

    @api iconName = 'custom:custom1';

    @api
    loadRelatedList(){
        this.retrieveChildRecords()
            .then(result =>{
                this.updateDataTable(result);
            })
            .catch(error=>{

            });

    }


    @track data = [];
    @track columns = [];


    _childRecords = [];
    _objectInfo;

    @wire(getObjectInfo, { objectApiName: '$childRecordsObjectDeveloperName' })
    objectInfo(response) {
        this._objectInfo = response;
        this.initColumns();
    }

    get objectLabel(){
        if(this._objectInfo != null && this._objectInfo.data != null){
            return this._objectInfo.data.labelPlural + ' (' + this._childRecords.length + ') ';
        }
        return '';
    }

    connectedCallback() {
        this.initColumns();
    }
    initColumns(){
        if(this.childRecordFields != null && this._objectInfo != null && this._objectInfo.data != null){
            this.columns = [];
            let fields = this.childRecordFields.split(',');
            fields.forEach((value, index) => {
                let fieldInfoKey = Object.keys(this._objectInfo.data.fields).find(key => key.toLowerCase() == value.toLowerCase())
                if(fieldInfoKey == null){
                    return;
                }
                let fieldInfo = this._objectInfo.data.fields[fieldInfoKey];
                let column = {
                    label : fieldInfo.label,
                    fieldName : fieldInfo.apiName,
                };

                this.columns.push(column);
            });
            console.log( this.columns);
        }

    }


    async retrieveChildRecords(){
        let payload = {
            objectAPIName : this.childRecordsObjectDeveloperName,
            parentFieldAPIName : this.relationshipField,
            queryFields : this.childRecordFields,
            recordId : this.parentRecordId
        }
        return await getChildRecords(payload)
            .then(result=>{
                this._childRecords = result;
            })
            .catch(error=>{
                console.log(error);
            })
    }
    updateDataTable(){
        if(this._childRecords != null){
            let rows = [];
            this._childRecords.forEach((record, recordIndex) => {
                let rowData = {};
                this.columns.forEach((column, columnIndex) => {
                    rowData[column.fieldName] = record[column.fieldName];
                });
                rows.push(rowData);
            });
            this.data = rows;
        }

    }



}