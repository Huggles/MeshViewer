import { LightningElement, track, wire } from 'lwc';
import getUserBalance from '@salesforce/apex/ConfigAppController.getUserBalance';
import addBudget from '@salesforce/apex/ConfigAppController.addBudget';
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
import Config_Balance_Threshold_Description from '@salesforce/label/c.Config_Balance_Threshold_Description';
import Config_Balance_Updated from '@salesforce/label/c.Config_Balance_Updated';
export default class balanceCard extends LightningElement {

    @track ready = false;
    @track balanceAmount;
    @track error;
    @track success;
    amountToAdd = 10;

    label = {
        Config_Balance_Management_Text,
        Config_Current_Budget,
        Config_Balance_Management,
        Config_Loading,
        Config_Current_Threshold,
        Config_Add_Budget,
        Config_Balance_Changed,
        Config_Balance_Error,
        Config_Balance_Threshold_Description,
        Config_Balance_Updated
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

    addBudget(event){
        addBudget({Amount: this.amountToAdd}).then(result => {
            // @todo these don't work in VF apparently
            // const evt = new ShowToastEvent({
            //     title: 'Success',
            //     message: this.label.Config_Balance_Changed,
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
        //     message: this.label.Config_Balance_Error,
        //     variant: 'error'
        // });
        // this.dispatchEvent(evt);
    });
    }


}