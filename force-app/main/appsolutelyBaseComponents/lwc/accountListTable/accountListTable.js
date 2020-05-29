/**
 * Created by tejaswinidandi on 26/05/2020.
 */

import {LightningElement, track, api, wire} from 'lwc';
import {FlowAttributeChangeEvent, FlowNavigationNextEvent, FlowNavigationFinishEvent} from 'lightning/flowSupport';
import {registerListener} from "c/pubsub";
import Duplicates_Found_Message from '@salesforce/label/c.Duplicates_Found_Message';

export default class AccountListTable extends LightningElement {

    @api accountList;
    @api selectedResult;
    @api updateDuplicateAccount = false;
    @api cancelClicked = false;

    @track disableUpdate = true;

    connectedCallback() {
        // var object =  this.accountList,
        //     result = Object.keys(object).reduce(function (r, k) {
        //         return r.concat(k, object[k]);
        //     }, []);
        //
        // console.log(result);
        // for(var a in this.accountList) {
        //     console.log(JSON.stringify(a));
        //     if(this.accountList.hasOwnProperty(a)){
        //         console.log(JSON.stringify(this.accountList[a]));
        //     }
        // }
        // var toReturn = this.flattenObject(this.accountList);
        // console.log('--'+toReturn);
        registerListener('resultselected', this.handleResultSelected, this);
        registerListener('resultunselected', this.handleResultUnSelected, this);
        this.data = this.accountList;
    }

    flattenObject(ob) {
        // var toReturn = {};
        //
        // for (var i in ob) {
        //     if (!ob.hasOwnProperty(i)) continue;
        //
        //     if ((typeof ob[i]) == 'object' && ob[i] !== null) {
        //         var flatObject = this.flattenObject(ob[i]);
        //         for (var x in flatObject) {
        //             if (!flatObject.hasOwnProperty(x)) continue;
        //
        //             toReturn[i + '.' + x] = flatObject[x];
        //         }
        //     } else {
        //         toReturn[i] = ob[i];
        //     }
        // }
        return Object.values(ob).flat();
    }

    handleClickDuplicateAccount() {
        this.updateDuplicateAccount = true;
        const navigateNextEvent = new FlowNavigationNextEvent();
        this.dispatchEvent(navigateNextEvent);
    }

    handleClickCancel() {
        this.cancelClicked = true;
        const navigateNextEvent = new FlowNavigationNextEvent();
        this.dispatchEvent(navigateNextEvent);
    }

    handleResultSelected(event) {
        this.disableUpdate = false;
    }

    handleResultUnSelected(event) {
        this.disableUpdate = true;
    }

}