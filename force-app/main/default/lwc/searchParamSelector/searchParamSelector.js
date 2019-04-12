import { LightningElement, track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SearchParamSelector extends LightningElement {
    @track value = '';

    get options() {
        return [
            { label: 'Name', value: 'Name' },
            { label: 'Profile Name', value: 'ProfileName' },
        ];
    }
    handleChange(event){
        
        const selectedOption = event.detail.value;
        //this.value = selectedOption;
        const evt = new CustomEvent('paramchange', {
            // detail contains only primitives
            
            detail: selectedOption
        });
        // Fire the event from c-tile
        this.dispatchEvent(evt); //
    }
}