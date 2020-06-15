/**
 * Created by Hugo on 15/06/2020.
 */
import userCheckFeature from '@salesforce/apex/HelperController.userCheckFeatureAccess';

/**
 * Checks whether the current user has access to a specific feature.
 * @param {string} feature - Name of the feature to check access for.
 */
const checkFeatureAccess = (feature) => {
    let payload = {
        'featureName' : feature
    }
    return new Promise((resolve, reject) => {
        userCheckFeature(payload)
            .then(result => {
                resolve(result);
            })
            .catch(error => {
                reject(error);
            });
    });
};


export { checkFeatureAccess }