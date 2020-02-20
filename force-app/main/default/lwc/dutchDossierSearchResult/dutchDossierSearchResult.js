/**
 * Created by jaapbranderhorst on 19/02/2020.
 */

import {LightningElement, api} from 'lwc';

export default class DutchDossierSearchResult extends LightningElement {

    /**
     * Contains the search result (in fact a business data SObject)
     */
    @api
    searchResult;

}