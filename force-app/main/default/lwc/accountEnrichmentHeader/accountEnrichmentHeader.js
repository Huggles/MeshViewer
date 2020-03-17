/**
 * Created by hugovankrimpen on 17/03/2020.
 */

import {LightningElement, api} from 'lwc';
import companyInfoLogoSmall from '@salesforce/resourceUrl/companyInfoLogoSmall';

export default class AccountEnrichmentHeader extends LightningElement {

    @api
    businessDossierId;

    staticResource ={
        companyInfoLogoSmall,
    }
    onDossierDeleted(event){
        //Passing on the event
        const recordDeletedEvent = new CustomEvent('dossierdeleted');
        this.dispatchEvent(recordDeletedEvent);

    }
}