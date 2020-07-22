/**
 * Created by Hugo on 21/07/2020.
 */

import {LightningElement} from 'lwc';
import {ToastEventController} from "c/toastEventController";

//Labels
import Save from '@salesforce/label/c.Save';
import Update_Cron_Settings from '@salesforce/label/c.Update_Cron_Settings';
import Update_Cron_Description from '@salesforce/label/c.Update_Cron_Description';
import Update_Cron_Last_Modified from '@salesforce/label/c.Update_Cron_Last_Modified';
import Update_Cron_Previous_Fire from '@salesforce/label/c.Update_Cron_Previous_Fire';
import Update_Cron_Next_Fire from '@salesforce/label/c.Update_Cron_Next_Fire';
import Set_Update_Cron_Expression_Success from '@salesforce/label/c.Set_Update_Cron_Expression_Success';


//Apex
import getScheduledCronJob from '@salesforce/apex/UpdateCronSettingsController.getScheduledCronJob';
import getUpdateCronExpression from '@salesforce/apex/UpdateCronSettingsController.getUpdateCronExpression';
import setUpdateCronExpression from '@salesforce/apex/UpdateCronSettingsController.setUpdateCronExpression';


export default class UpdateCronSettings extends LightningElement {

    labels = {
        Save,
        Update_Cron_Settings,
        Update_Cron_Description,
        Update_Cron_Last_Modified,
        Update_Cron_Previous_Fire,
        Update_Cron_Next_Fire,
        Set_Update_Cron_Expression_Success
    }

    isLoading = false;

    scheduledCronJob;
    originalCronValue;
    cronExpressionInputElement;

    connectedCallback() {
        this.retrieveCronExpression();
        this.retrieveScheduledJobs();
    }
    renderedCallback() {
        if(this.cronExpressionInputElement == null){
            this.cronExpressionInputElement = this.template.querySelector('[data-identifier="cronExpressionInput"]');
        }

    }

    retrieveCronExpression(){
        this.isLoading = true;
        getUpdateCronExpression({})
            .then((result)=>{
                this.originalCronValue = result;
            })
            .catch((error)=>{
                new ToastEventController(this).showErrorToastMessage('Error', error);
            })
            .finally(()=>{
                this.isLoading = false;
            })
    }
    retrieveScheduledJobs(){
        this.isLoading = true;
        getScheduledCronJob({})
            .then((result)=>{
                console.log('scheduledCronJob');
                console.log(result);
                this.scheduledCronJob = result;
            })
            .catch((error)=>{
                new ToastEventController(this).showErrorToastMessage('Error', error);
            })
            .finally(()=>{
                this.isLoading = false;
            })
    }

    handleSaveButtonClick(){
        if(this.cronExpressionInputElement != null){
            this.isLoading = true;
            console.log(this.cronExpressionInputElement.value);
            setUpdateCronExpression({cronExpression : this.cronExpressionInputElement.value})
                .then((result)=>{
                    new ToastEventController(this).showSuccessToastMessage('Succes', this.labels.Set_Update_Cron_Expression_Success);
                })
                .catch((error)=>{
                    new ToastEventController(this).showErrorToastMessage('Error', error);
                })
                .finally(()=>{
                    this.isLoading = false;
                });
        }


    }
}