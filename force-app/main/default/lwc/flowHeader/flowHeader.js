/**
 * Created by jaapbranderhorst on 09/02/2020.
 */

import {LightningElement, api} from 'lwc';
import COMPANY_INFO_LOGO from '@salesforce/resourceUrl/companyInfoLogoSmall'

export default class FlowHeader extends LightningElement {
    companyInfoLogo = COMPANY_INFO_LOGO;
    @api
    title;

}