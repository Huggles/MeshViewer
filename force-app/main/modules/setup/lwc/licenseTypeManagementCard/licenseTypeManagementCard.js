/**
 * Created by jaapbranderhorst on 05/05/2020.
 */

import {api, LightningElement} from 'lwc';

export default class LicenseTypeManagementCard extends LightningElement {

    /**
     * Contains the API name of the license type as defined in the LicenseType enum in Apex
     */
    @api
    licenseTypeName;

    /**
     * Contains the name of the License Type (Company.info for Business for example).
     */
    title;

    /**
     * Contains the API name of the feature parameter of type number containing the number of seats for this license type the customer is entitled to.
     */
    nrOfSeatsFeatureParam;

    /**
     * Contains the API name of the permission group containing the permissions granted by having a license from this license type.
     */
    permissionGroupName;




}