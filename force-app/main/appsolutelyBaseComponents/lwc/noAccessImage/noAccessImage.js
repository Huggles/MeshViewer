/**
 * Created by jaapbranderhorst on 11/05/2020.
 */

import {LightningElement, api} from 'lwc';
import NO_ACCESS from '@salesforce/resourceUrl/NoAccess';
import No_Access_Message from '@salesforce/label/c.No_Access_Message';

export default class noResultImage extends LightningElement {

    /**
     * Illustration initialization
     */
    noAccessImage = NO_ACCESS + '#noaccess';

    /**
     * Label for when no results have been found.
     */
    @api
    noAccessMessage = No_Access_Message;
}