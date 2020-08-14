/**
 * Created by vishalshete on 10/08/2020.
 */

import {LightningElement,api,track} from 'lwc';
import Loading from '@salesforce/label/c.Loading';
import Error from '@salesforce/label/c.Error';
import NorowselectedMessage from '@salesforce/label/c.No_row_selected_Message';
import {ToastEventController} from "c/toastEventController";

const columns = [
    {label: 'Dossier Number', fieldName: 'appsolutely__Dossier_Number__c', type: 'number', sortable: true},
    {label: 'Establishment Number', fieldName: 'appsolutely__Establishment_Number__c', type: 'text', sortable: true},
    {label: 'Name', fieldName: 'Name', type: 'text', sortable: true},
    {label: 'Trade Name Full', fieldName: 'appsolutely__Trade_Name_Full__c', type: 'text', sortable: true},
    {label: 'Establishment City', fieldName: 'appsolutely__Establishment_City__c', type: 'text', sortable: true},
    {label: 'Establishment Street', fieldName: 'appsolutely__Establishment_Street__c', type: 'text', sortable: true},
    {label: 'Correspondence City', fieldName: 'appsolutely__Correspondence_City__c', type: 'text', sortable: true},
    {label: 'Correspondence Street', fieldName: 'appsolutely__Correspondence_Street', type: 'text', sortable: true},
    {label: 'Indication Economically Active', fieldName: 'Indication_Economically_Active__c', type: 'boolean', sortable: true}
];


export default class ShowBusinessDossierDataTable extends LightningElement {
    /**
     * default sort direction for the datatable
     */
    @track defaultSortDirection = 'asc';

    @api businessDossiers
    /**
     * Column FieldName on which to sort the table
     */
    @track
    sortedBy = 'Name'
    /**
     * Direction to sort the table on. Valid values are 'asc' and 'desc'
     * @type {string}
     */
    @api
    sortDirection = 'asc';
    /**
     * Switch to turn the loading spinner on and off
     */
    @api
    isLoading;
    /**
     * The selected rows in the table
     */
    @api
    selectedRows=[];
    /**
     * Enable infinite loading on the table
     */
    @api
    enableInfiniteLoading;

    label={
        Error,
        NorowselectedMessage
    }

    columns = columns;
    handleSort(event) {
        // switch in sort direction and number of rows loaded is less than total number of rows
        let reload = false;
        if (this.sortDirection != event.detail.sortDirection && this.businessDossiers ) {
            this.businessDossiers = undefined;
            reload = true;
        } else {
            this.sortDossiers(event.detail.fieldName, event.detail.sortDirection);
        }
        this.sortedBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
    }
    sortDossiers(sortedBy, sortDirection) {
        if (this.businessDossiers) {
            let dossiers = [...this.businessDossiers];
            if (sortDirection === 'asc') {
                dossiers.sort((a, b) => (a[sortedBy] > b[sortedBy]) ? 1 : ((a[sortedBy] < b[sortedBy]) ? -1 : 0));
            } else {
                dossiers.sort((a, b) => (a[sortedBy] > b[sortedBy]) ? -1 : ((a[sortedBy] < b[sortedBy]) ? 1 : 0));
            }
            this.businessDossiers = dossiers;
        }
    }
    @api dossiersToStore=[];

    @api
    fastFilter(searchString) {
        if(!searchString){
            this.businessDossiers = this.dossiersToStore;
        } else{
            searchString = searchString.toLowerCase();
            this.businessDossiers = this.dossiersToStore.filter(dossier=>
                dossier.appsolutely__Dossier_Number__c.toLowerCase().includes(searchString)||
                dossier.appsolutely__Establishment_Number__c.toLowerCase().includes(searchString)||
                dossier.Name.toLowerCase().includes(searchString)
            );
        }
    }
    handleLoadMore(event) {
        if(this.dossiersToStore.length == this.businessDossiers.length) {
            this.isLoading = true;
            this.dispatchEvent(new CustomEvent('loadmore'));
        }
    }
    handleRowSelection(event) {
        this.selectedRows = event.target.getSelectedRows();
    }
    @api
    createDossiers(){
        if(this.selectedRows.length==0){
            new ToastEventController(this).showErrorToastMessage(this.label.Error, this.label.NorowselectedMessage);
        }else{
            this.dispatchEvent(new CustomEvent('sendselectedrows',{detail: this.selectedRows }));
        }
    }
}