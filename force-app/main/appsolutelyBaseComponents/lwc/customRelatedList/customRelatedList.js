/**
 * Created by Hugo on 23/06/2020.
 */

import {LightningElement, api, track} from 'lwc';

import getChildRecords from '@salesforce/apex/CustomRelatedListController.getChildRecords'


const columns = [
    { label: 'Label', fieldName: 'name' },
    { label: 'Website', fieldName: 'website', type: 'url' },
    { label: 'Phone', fieldName: 'phone', type: 'phone' },
    { label: 'Balance', fieldName: 'amount', type: 'currency' },
    { label: 'CloseAt', fieldName: 'closeAt', type: 'date' },
];

export default class CustomRelatedList extends LightningElement {
    @api objectAPIName;
    @api objectLookupField;
    @api objectFields;
    @api customRecordId;
    @api recordId;

    @track data = [];
    @track columns = [];

    connectedCallback() {
        if(this.customRecordId == null){
            this.customRecordId = this.recordId;
        }
        this.initColumns();
        this.retrieveChildRecords();

    }

    initColumns(){
        if(this.objectFields != null){
            let fields = this.objectFields.split(',');
            fields.forEach((value, index) => {
                console.log(value);
                let column = { label : value, fieldName : value };
                this.columns.push(column);
            });
        }
    }
    retrieveChildRecords(){
        let payload = {
            objectAPIName : this.objectAPIName,
            parentFieldAPIName : this.objectLookupField,
            queryFields : this.objectFields,
            recordId : this.customRecordId
        }
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
        let fields = this.objectFields.split(',');
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