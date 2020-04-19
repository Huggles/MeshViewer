/**
 * Created by jaapbranderhorst on 27/02/2020.
 */

import {LightningElement, api} from 'lwc';

export default class DutchDossierResults extends LightningElement {
    @api
    availableActions = [];

    @api
    searchResults;

    @api
    selectedResult;

}