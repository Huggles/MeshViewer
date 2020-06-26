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
        let column = this.getColumn(fieldName);
        column.type = type;
        column.typeAttributes = typeAttributes;
        this.replaceColumn(this.getColumn(fieldName), column);

    }

    /*
    * Sets one of the columns to type url
    * This can only be called once the columns have been initialized. *
    */
    @api
    setColumnTypeRelativeURL(fieldName, valueField, openInNewTab) {
        let correctValueFieldName = this.queriedObjectFieldsMap[valueField];
        let typeAttributes = {
            label: { fieldName : correctValueFieldName },
            isRelativeURL : true
        };
        if (openInNewTab == true) typeAttributes["target"] = "_blank";
        //this.setColumnValuesToRelativeURL(fieldName);
        this.setColumnType(fieldName, 'url', typeAttributes);
        this.switchColumnLabels(fieldName, valueField);
    }

    /*
    * Sets the values of field "ValueField" to the column "FieldName"
    * Should only be called when the data has been loaded
    */
    setColumnValuesToOtherColumn(fieldName, valueField) {
        let correctFieldName = this.queriedObjectFieldsMap[fieldName];
        let correctValueFieldName = this.queriedObjectFieldsMap[valueField];
        this.data.forEach((row,index) => {
            row[correctFieldName] = row[correctValueFieldName];
        })
    }





    /*
    * Remove a column in the datatable based on the query field name
    */
    @api
    removeColumn(fieldName){
        let column = this.getColumn(fieldName);
        this.columns.splice(this.columns.indexOf(column),1);
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
        if(response.data != null){
            this.initColumns();
            this.loadRelatedList();
        }else if (response.error){
            new ToastEventController(this).showErrorToastMessage('Error', response.error);
        }

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
        return await getChildRecords(payload)
            .then(result=>{
                this._childRecords = JSON.parse(JSON.stringify(result));
            })
            .catch(error=>{
                new ToastEventController(this).showErrorToastMessage('Error', error);
            })
    }
    updateDataTable(){
        if(this._childRecords != null){
            this.data = this._childRecords;
            this.setRelativeURLTypeColumnsToRelativeURL();
            const datainitialized = new CustomEvent('dataloaded');
            this.dispatchEvent(datainitialized);
        }
    }

    setRelativeURLTypeColumnsToRelativeURL(){
        this.columns.forEach((column,index) => {
            if( column.typeAttributes != null &&  column.typeAttributes.isRelativeURL == true && column.type == 'url'){
                this.setColumnValuesToRelativeURL(column);
            }
        });
    }
    setColumnValuesToRelativeURL(column) {
        this.data.forEach((row,index) => {
            row[column.fieldName] = '/'+row[column.fieldName];
        })
    }

    /*
    * Gets a column in the datatable based on the query field name
    */
    getColumn(fieldName){
        let fieldMapping = this.queriedObjectFieldsMap;
        let correctFieldName = fieldMapping[fieldName]; //The translated objectFieldName
        let column = this.columns.find(columnRef =>{
            return columnRef.fieldName == correctFieldName;
        });
        return column;
    }
    /*
    * Replaces a column definition with a new column definition
    */
    replaceColumn(oldColumn, newColumn){
        if(this.columns != null){
            this.columns[this.columns.indexOf(oldColumn)] = newColumn;
        }

    }

    /*
    * Switches labels of columns around
    */
    switchColumnLabels(fieldName1, fieldName2){
        let column1 = this.getColumn(fieldName1);
        let column2 = this.getColumn(fieldName2);

        let column1Label = column1.label;
        let column2Label = column2.label;

        column1.label = column2Label;
        column2.label = column1Label;

        this.replaceColumn(column1, column2);
        this.replaceColumn(column2, column1);
    }




}