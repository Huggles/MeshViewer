/**
 * Created by Hugo on 23/06/2020.
 */

import {LightningElement, api, track, wire} from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';

//import getCustomRecordIdField from '@salesforce/apex/CustomRelatedListController.getCustomRecordIdField'
import getChildRecords from '@salesforce/apex/CustomRelatedListController.getChildRecords'


const columns = [
    { label: 'Label', fieldName: 'name' },
    { label: 'Website', fieldName: 'website', type: 'url' },
    { label: 'Phone', fieldName: 'phone', type: 'phone' },
    { label: 'Balance', fieldName: 'amount', type: 'currency' },
    { label: 'CloseAt', fieldName: 'closeAt', type: 'date' },
];

export default class CustomRelatedList extends LightningElement {
    @api objectApiName;
    @api parentRecordObjectAPIName;
    @api relationshipField;
    @api childObjectFields;
    @api customRecordIdField;

    @api recordId;

    @track data = [];
    @track columns = [];

    _parentRecordId;
    get parentRecordId(){
        return this._parentRecordId;
    }
    set parentRecordId(value){
        this._parentRecordId = value;
        this.retrieveChildRecords();
    }


    get _customRecordIdFieldRef(){
        return [this.objectApiName+'.'+this.customRecordIdField];
    }

    _getRecordDataResponse;
    @wire(getRecord, { recordId: '$recordId', fields: '$_customRecordIdFieldRef'})
    recordData(response) {
        this._getRecordDataResponse = response;
        if (response.error) {
            console.log(response.error);
        } else if (response.data) {
            if(response.data.fields[this.customRecordIdField] == null){
                //Field not found
            }else if(response.data.fields[this.customRecordIdField] != null && response.data.fields[this.customRecordIdField].value == null){
                //Field empty
            }else if(response.data.fields[this.customRecordIdField] != null && response.data.fields[this.customRecordIdField].value != null) {
                //Do something with the field
                this.parentRecordId = response.data.fields[this.customRecordIdField].value;
            }
        }
    }

    connectedCallback() {
        this.initColumns();
        if(this.customRecordIdField == null){
            this.parentRecordId = this.recordId;
        }
    }
    initColumns(){
        if(this.childObjectFields != null){
            let fields = this.childObjectFields.split(',');
            fields.forEach((value, index) => {
                let column = {
                    label : value.toLowerCase(),
                    fieldName : value.toLowerCase(),
                };
                this.columns.push(column);
            });
        }

    }
    retrieveChildRecords(){
        let payload = {
            objectAPIName : this.parentRecordObjectAPIName,
            parentFieldAPIName : this.relationshipField,
            queryFields : this.childObjectFields,
            recordId : this.parentRecordId
        }
        console.log(payload);
        getChildRecords(payload)
            .then(result=>{
                console.log(result);
                this.updateDataTable(result);
            })
            .catch(error=>{
                console.log(error);
            })
    }
    updateDataTable(data){
        let fields = this.childObjectFields.toLowerCase().split(',');
        if(data != null){
            let rows = [];
            data.forEach((record, recordIndex) => {
                let rowData = {};
                fields.forEach((field, fieldIndex) => {
                    rowData[field] = record[field];
                });
                rows.push(rowData);
            });
            this.data = rows;
        }

    }



}