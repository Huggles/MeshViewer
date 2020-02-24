/**
 * Created by appsolutely on 19/02/2020.
 */

import {api, LightningElement, wire, track} from 'lwc';
import createSearchResults from '@salesforce/apex/InternationalAddressController.createSearchResults';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class DisplaySearchResults extends LightningElement {

    @track printName = '';
    @api internationalAddressList;
    @api selectedData = [];


    handleClick(event){
        //this.printName = 'hello '+event.detail.appsolutely__RecordRefNo__c;
        this.selectedData.push(event.detail);
    }

    saveRecords(){
        createSearchResults({userSelectedAddress : this.selectedData})
            .then(result => {
                this.message = result;
                this.error = undefined;
                if(this.message !== undefined){
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title:'Success',
                            message: 'Search result created',
                            variant: 'Success'
                        }),
                    );
                }
            })
            .catch(error => {
                this.message = undefined;
                this.error = error;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
                console.log("error", JSON.stringify(this.error));
            });
    }

}