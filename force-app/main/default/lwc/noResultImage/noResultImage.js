/**
 * Created by jaapbranderhorst on 11/05/2020.
 */

import {LightningElement, api} from 'lwc';
import DESERT_ILLUSTRATION from '@salesforce/resourceUrl/Desert';
import searchNoResultsCL from '@salesforce/label/c.Search_No_Results';

export default class noResultImage extends LightningElement {

    /**
     * Illustration initialization
     */
    desertIllustration = DESERT_ILLUSTRATION + '#desert';

    /**
     * Label for when no results have been found.
     */
    @api
    noDataLabel = searchNoResultsCL;
}