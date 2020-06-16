/**
 * Created by jaapbranderhorst on 16/06/2020.
 */

import apexCheckAccess from '@salesforce/apex/FeatureAccessControlController.checkAccess';

const checkAccess = async(feature) => {
    await apexCheckAccess({featureName: feature})
        .then(result => {return result})
        .catch(error => {throw error});
}

const Features = Object.freeze({
    COMPANY_INFO_ONLINE : 'COMPANY_INFO_ONLINE',
    CREDITSAFE_GET_REPORT : 'CREDITSAFE_GET_REPORT',
    D_B_GET_REPORT : 'D_B_GET_REPORT',
    DUTCH_ADDRESSES : 'DUTCH_ADDRESSES',
    DUTCH_BUSINESS_GET_DOSSIER : 'DUTCH_BUSINESS_GET_DOSSIER',
    DUTCH_BUSINESS_POSITIONS : 'DUTCH_BUSINESS_POSITIONS',
    DUTCH_BUSINESS_SEARCH : 'DUTCH_BUSINESS_SEARCH',
    DUTCH_CHAMBER_OF_COMMERCE_EXTRACT : 'DUTCH_CHAMBER_OF_COMMERCE_EXTRACT',
    DUTCH_LEAD_GENERATOR : 'DUTCH_LEAD_GENERATOR',
    DUTCH_LOOK_A_LIKE_SERVICE : 'DUTCH_LOOK_A_LIKE_SERVICE',
    DUTCH_NEWS : 'DUTCH_NEWS',
    DUTCH_VAT : 'DUTCH_VAT',
    INTERNATIONAL_ADDRESSES : 'INTERNATIONAL_ADDRESSES',
    INTERNATIONAL_BUSINESS_SEARCH : 'INTERNATIONAL_BUSINESS_SEARCH'
});

export {Features, checkAccess}