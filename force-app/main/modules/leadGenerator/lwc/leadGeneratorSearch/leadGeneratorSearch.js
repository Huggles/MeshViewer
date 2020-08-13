/**
 * Created by Hugo on 11/08/2020.
 */

import {LightningElement} from 'lwc';
import {FlowAttributeChangeEvent, FlowNavigationBackEvent, FlowNavigationNextEvent, FlowNavigationPauseEvent, FlowNavigationFinishEvent} from 'lightning/flowSupport';

import Search_Confirm from '@salesforce/label/c.Search_Confirm';
import Cancel from '@salesforce/label/c.Cancel';
import Previous from '@salesforce/label/c.Previous';



export default class LeadGeneratorSearch extends LightningElement {

    activeSections;

    handleSectionToggle(event){

        this.activeSections = event.detail.openSections;
        console.log(this.activeSections);
        console.log(JSON.stringify(this.activeSections));
        console.log(JSON.parse(JSON.stringify(this.activeSections)));
    }
    get isStepLocation1(){
        if(this.activeSections != null){
            return this.activeSections.includes("Location");
        }return false;

    }


    label = {
        Search_Confirm,
        Cancel,
        Previous
    }

    availableFooterActions = [
        'NEXT',
        'FINISH'
    ]
    showFooterCancelButton = true;

    handleFooterNextClick(event){
        const navigateNextEvent = new FlowNavigationNextEvent();
        this.dispatchEvent(navigateNextEvent);
    }

    steps = [
        {
            label : 'Select SBI\'s',
            value : 'SBI'
        },
        {
            label : 'Select Location',
            value : 'Location'
        },
        {
            label : 'Select Properties',
            value : 'Properties'
        }];



    currentstepIndex = 0;
    get currentstep(){
        return this.steps[this.currentstepIndex].value;
    }
    get isStepSBI(){
        return this.currentstep == this.steps[0].value;
    }
    get isStepLocation(){
        return this.currentstep == this.steps[1].value;
    }
    get isStepProperties(){
        return this.currentstep == this.steps[2].value;
    }

    onNextClicked(event){
        if(this.currentstepIndex < this.steps.length - 1){
            this.currentstepIndex += 1;
        }
    }
    onPreviousClicked(event){
        if(this.currentstepIndex > 0){
            this.currentstepIndex -= 1;
        }
    }


}