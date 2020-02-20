/**
 * Created by appsolutely on 19/02/2020.
 */

import {LightningElement, wire} from 'lwc';
import getSearchResults from '@salesforce/apex/InternationalAddressController.getSearchResults';

export default class DisplaySearchResults extends LightningElement {
    @wire(getSearchResults) irresults;
}