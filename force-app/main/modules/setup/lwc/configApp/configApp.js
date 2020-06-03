import { LightningElement, track, wire } from 'lwc';
// import getUserOnboarded from '@salesforce/apex/ConfigAppController.getUserOnboarded';
// import userCheckActive from '@salesforce/apex/ConfigAppController.userCheckActive';
// import { refreshApex } from '@salesforce/apex';
// import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// import Config_Account_AwaitingActivation from '@salesforce/label/c.Config_Account_AwaitingActivation';
import Config_Title from '@salesforce/label/c.Config_Title';
import Config_Credentials from '@salesforce/label/c.Config_Credentials';
import Update_types from '@salesforce/label/c.Update_types';



// import Config_Page_Title from '@salesforce/label/c.Config_Page_Title';
// import Config_Loading from '@salesforce/label/c.Config_Loading';

export default class configApp extends LightningElement {
    labels = {
        Config_Title,
        Config_Credentials,
        Update_types
    };
}