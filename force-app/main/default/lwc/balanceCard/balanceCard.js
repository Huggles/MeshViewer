import { LightningElement, track, wire } from 'lwc';
import getUserBalance from '@salesforce/apex/ConfigAppController.getUserBalance';
import addBudged from '@salesforce/apex/ConfigAppController.addBudged';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Config_Balance_Threshold_Description from '@salesforce/label/c.Config_Balance_Threshold_Description';

export default class balanceCard extends LightningElement {

    @track ready = false;
    @track balanceAmount;
    amountToAdd = 10;

    wiredBalanceResult;

    label = {
        Config_Balance_Threshold_Description
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

    addBudged(event){
        addBudged({Amount: this.amountToAdd}).then(result => {
            console.log(result);
            console.log('SUCCESS123');
            const evt = new ShowToastEvent({
                title: 'Success',
                message: 'The balance was changed',
                variant: 'success'
            });
            this.dispatchEvent(evt);
            const event = new CustomEvent('userOnboarded', { // why here?
                // detail contains only primitives
                //detail: this.product.fields.Id.value
            });
            // Fire the event from c-tile
            this.dispatchEvent(event);
            //return null;
            return refreshApex(this.wiredBalanceResult);
        })
        .catch(error => {
            this.error = error;
            console.log(this.error);
            const evt = new ShowToastEvent({
                title: 'Error',
                message: 'There was an error during org activation.',
                variant: 'error'
            });
            this.dispatchEvent(evt);
        });
    }


}