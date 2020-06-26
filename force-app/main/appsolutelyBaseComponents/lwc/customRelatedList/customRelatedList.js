/**
 * Created by Hugo on 23/06/2020.
 */

import {LightningElement, api, track, wire} from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import getChildRecords from '@salesforce/apex/CustomRelatedListController.getChildRecords'
import {ToastEventController} from "c/toastEventController";



export default class CustomRelatedList extends LightningElement {


    @api relationshipField;
    @api childRecordFields;
    @api childRecordsObjectDeveloperName;
    @api parentRecordId;

    @api iconName = 'custom:custom1';


    /*
    * Load the child records. Only runs when all required values have been set.
    * Has built in check to only run once. Run reloadRelatedList to overwrite this.
    */
    @api
    loadRelatedList(){
        if(this.relationshipField != null && this.childRecordsObjectDeveloperName != null && this.parentRecordId != null &&
            this.queriedObjectFieldsDeveloperNames != null && this.queriedObjectFieldsDeveloperNames.length > 0){

            //Make sure to only load once
            if(this._childRecordsLoaded == false){
                this._childRecordsLoaded = true;
                this.isLoading = true;
                this.retrieveChildRecords()
                    .then(result =>{
                        this.updateDataTable(result);
                    })
                    .catch(error=>{
                        new ToastEventController(this).showErrorToastMessage('Error', error);
                    })
                    .finally(()=>{
                        this.isLoading = false;
                    });
            }
        }
    }
    /*
    * Reload of the table records
    */
    @api
    reloadRelatedList(){
        this._childRecords = []
        this._childRecordsLoaded = false;
        this.loadRelatedList();
    }


    /*
     * Sets one of the columns to a specific type using typeAttributes.
     * See https://developer.salesforce.com/docs/component-library/bundle/lightning-datatable/documentation
     * This can only be called once the columns have been initialized.     *
     */
    @api
    setColumnType(fieldName, type, typeAttributes){

        let fieldMapping = this.queriedObjectFieldsMap;
        let correctFieldName = fieldMapping[fieldName]; //The translated objectFieldName
        let column = this.columns.find(columnRef =>{
            return columnRef.fieldName == correctFieldName;
        });
        if(column == null) return; //If the column was not found, return;
        column.type = type;
        column.typeAttributes = typeAttributes;
        this.columns[this.columns.indexOf(column)] = column;
        console.log(JSON.stringify(this.columns));
    }


    @track data = [];
    @track columns = [];
    isLoading = false;


    _childRecords = [];
    _objectInfo;
    _childRecordsLoaded = false;


    @wire(getObjectInfo, { objectApiName: '$childRecordsObjectDeveloperName' })
    objectInfo(response) {
        this._objectInfo = response;
        this.initColumns();
        this.loadRelatedList();
    }

    get objectLabel(){
        if(this._objectInfo != null && this._objectInfo.data != null){
            return this._objectInfo.data.labelPlural + ' (' + this._childRecords.length + ') ';
        }
        return '';
    }

    get queriedObjectFieldsMap(){
        let queriedObjectFieldsInfoMap = {};
        if(this.childRecordFields != null && this._objectInfo != null && this._objectInfo.data != null){
            let queryFields = this.childRecordFields.split(',');
            queryFields.forEach((queryField, index) => {
                let fieldInfoKey = Object.keys(this._objectInfo.data.fields).find(key => key.toLowerCase() == queryField.toLowerCase())
                if(fieldInfoKey == null){
                    return null;
                }
                queriedObjectFieldsInfoMap[queryField] = fieldInfoKey;
            });
        }
        return queriedObjectFieldsInfoMap;
    }

    get queriedObjectFieldsInfo(){
        let queriedObjectFieldsInfoArray = [];
        if(this.childRecordFields != null && this._objectInfo != null && this._objectInfo.data != null){
            let queryFields = this.childRecordFields.split(',');
            queryFields.forEach((queryField, index) => {
                let fieldInfoKey = Object.keys(this._objectInfo.data.fields).find(key => key.toLowerCase() == queryField.toLowerCase())
                if(fieldInfoKey == null){
                    return null;
                }
                let fieldInfo = this._objectInfo.data.fields[fieldInfoKey];
                queriedObjectFieldsInfoArray.push(fieldInfo);
            });
        }
        return queriedObjectFieldsInfoArray;
    }
    get queriedObjectFieldsDeveloperNames(){
        let queriedObjectFieldsDeveloperName= [];
        this.queriedObjectFieldsInfo.forEach((queryField, index) => {
            queriedObjectFieldsDeveloperName.push(queryField.apiName);
        });
        return queriedObjectFieldsDeveloperName;
    }

    connectedCallback() {
        this.initColumns();
    }
    initColumns(){
        if(this.childRecordFields != null && this._objectInfo != null && this._objectInfo.data != null){
            this.columns = [];
            this.queriedObjectFieldsInfo.forEach((queriedField, index) => {
                let column = {
                    label : queriedField.label,
                    fieldName : queriedField.apiName,
                };
                this.columns.push(column);
            });
        }
        const columnsinitialized = new CustomEvent('columnsinitialized');
        this.dispatchEvent(columnsinitialized);
    }
    async retrieveChildRecords(){
        let payload = {
            objectDeveloperName : this.childRecordsObjectDeveloperName,
            relationshipFieldDeveloperName : this.relationshipField,
            queryFields : this.queriedObjectFieldsDeveloperNames,
            parentRecordId : this.parentRecordId
        }
        console.log(payload);
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