/**
 * Created by jaapbranderhorst on 09/02/2020.
 */

import {LightningElement, api} from 'lwc';
import COMPANY_INFO_LOGO from '@salesforce/resourceUrl/companyInfoLogoSmall'



import SEARCH_BUSINESS_RESULTS_CLREF from '@salesforce/label/c.Search_Results_Title';


export default class FlowHeader extends LightningElement {

    @api
    title;

}