import { LightningElement, track, wire } from 'lwc';
import getUserBalance from '@salesforce/apex/ConfigAppController.getUserBalance';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';



export default class balanceCard extends LightningElement {

    @track ready = false;
    @track balanceAmount;

    wiredBalanceResult;
    
    @wire(getUserBalance)
    wiredBalance(result) {
        this.wiredBalanceResult = result;
        console.log(result);
        console.log(this.wiredBalanceResult.data);
        console.log(this.wiredBalanceResult);
        if (this.wiredBalanceResult.data !== undefined) {
            console.log('result');
            this.balanceAmount = this.wiredBalanceResult.data;

            this.ready = true;
            this.error = undefined;
        } else if (this.wiredBalanceResult.error) {
            this.error = this.wiredBalanceResult.error;
            this.users = undefined;
        }
    }


}