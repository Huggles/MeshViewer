import { LightningElement, track, wire } from 'lwc';
import getUserBalance from '@salesforce/apex/ConfigAppController.getUserBalance';
import addBudged from '@salesforce/apex/ConfigAppController.addBudged';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Config_Balance_Management_Text from '@salesforce/label/c.Config_Balance_Management_Text';
import Config_Current_Budget from '@salesforce/label/c.Config_Current_Budget';
import Config_Loading from '@salesforce/label/c.Config_Loading';
import Config_Balance_Management from '@salesforce/label/c.Config_Balance_Management';
import Config_Current_Threshold from '@salesforce/label/c.Config_Current_Threshold';
import Config_Add_Budget from '@salesforce/label/c.Config_Add_Budget';
import Config_Balance_Changed from '@salesforce/label/c.Config_Balance_Changed';
import Config_Balance_Error from '@salesforce/label/c.Config_Balance_Error';

export default class balanceCard extends LightningElement {

    @track ready = false;
    @track balanceAmount;
    amountToAdd = 10;

    label = {
        Config_Balance_Management_Text,
        Config_Current_Budget,
        Config_Balance_Management,
        Config_Loading,
        Config_Current_Threshold,
        Config_Add_Budget,
        Config_Balance_Changed,
        Config_Balance_Error
    }

    wiredBalanceResult;
    
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
                message:  Config_Balance_Changed,
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
                message: Config_Balance_Error,
                variant: 'error'
            });
            this.dispatchEvent(evt);
        });
    }


}