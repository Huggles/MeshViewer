/**
 * Created by Hugo on 21/07/2020.
 */

import {LightningElement} from 'lwc';
import {ToastEventController} from "c/toastEventController";

//Labels
import Save from '@salesforce/label/c.Save';
import Update_Time_Settings from '@salesforce/label/c.Update_Time_Settings';

//Apex
import getScheduledCronJob from '@salesforce/apex/UpdateTimeSettingsController.getScheduledCronJob';
import getUpdateCronExpression from '@salesforce/apex/UpdateTimeSettingsController.getUpdateCronExpression';
import setUpdateCronExpression from '@salesforce/apex/UpdateTimeSettingsController.setUpdateCronExpression';


export default class UpdateTimeSettings extends LightningElement {

    labels = {
        Save,
        Update_Time_Settings
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
                    new ToastEventController(this).showSuccessToastMessage('Succes', null);
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