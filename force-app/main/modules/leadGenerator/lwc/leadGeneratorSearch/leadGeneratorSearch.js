/**
 * Created by Hugo on 11/08/2020.
 */

import {LightningElement} from 'lwc';

export default class LeadGeneratorSearch extends LightningElement {

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