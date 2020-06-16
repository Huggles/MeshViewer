/**
 * Created by jaapbranderhorst on 16/06/2020.
 */

import apexCheckAccess from '@salesforce/apex/FeatureAccessControlController.checkAccess';

const checkAccess = (feature) => {
    apexCheckAccess({featureName: feature})
        .then(result => {return result})
        .catch(error => {throw error});
}

export {checkAccess}