import { LightningElement, track, wire } from 'lwc';
import getUserBalance from '@salesforce/apex/ConfigAppController.getUserBalance';
import addBudget from '@salesforce/apex/ConfigAppController.addBudget';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Config_Balance_Threshold_Description from '@salesforce/label/c.Config_Balance_Threshold_Description';
import Config_Balance_Updated from '@salesforce/label/c.Config_Balance_Updated';

export default class balanceCard extends LightningElement {

    @track ready = false;
    @track balanceAmount;
    @track error;
    @track success;
    amountToAdd = 10;

    wiredBalanceResult;

    label = {
        Config_Balance_Threshold_Description,
        Config_Balance_Updated
    }
    
    @wire(getUserBalance)
    wiredBalance(result) {
        this.wiredBalanceResult = result;
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

    handleNumChange(event) {
        this.amountToAdd = event.target.value;
    }

    addBudget(event){
        addBudget({Amount: this.amountToAdd}).then(result => {
            // @todo these don't work in VF apparently
            // const evt = new ShowToastEvent({
            //     title: 'Success',
            //     message: 'The balance was changed',
            //     variant: 'success'
            // });
            // this.dispatchEvent(evt);
            this.success = this.label.Config_Balance_Updated;
            return refreshApex(this.wiredBalanceResult);
        })
        .catch(error => {
            this.error = error;
            // @todo these don't work in VF apparently
            // const evt = new ShowToastEvent({
            //     title: 'Error',
            //     message: 'There was an error during org activation.',
            //     variant: 'error'
            // });
            // this.dispatchEvent(evt);
        });
    }


}