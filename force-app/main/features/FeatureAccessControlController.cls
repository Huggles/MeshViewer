/**
 * Created by jaapbranderhorst on 16/06/2020.
 */

public inherited sharing class FeatureAccessControlController {

    /**
     * @return a list with the names of all features
     */
    @AuraEnabled(cacheable=true)
    public static List<String> getFeatures() {
        try {
            List<String> featureNames = new List<String>();
            List<Feature> features = Feature.values();
            for (Feature feature : features) {
                featureNames.add(feature.name());
            }
            return featureNames;
        } catch(Exception ex) {
            ErrorLogUtil.logException(ex, true);
            throw new AuraHandledException(ex.getMessage());
        }
    }

    /**
     * @param featureName the name of the feature
     *
     * @return true if the user has access to the feature, false otherwise. Throws an error if the feature name doesn't exist
     */
    @AuraEnabled(cacheable=true)
    public static Boolean checkAccess(String featureName) {
        try {
            if (getFeatures().contains(featureName)) {
                return LicenseManagementService.userHasAccess(getFeatureByName(featureName));
            } else {
                throw new InputException('No feature named ' + featureName);
            }
        } catch (Exception ex) {
            ErrorLogUtil.logException(ex, true);
            throw new AuraHandledException(ex.getMessage());
        }
    }

    private static Feature getFeatureByName(String featureName) {
        List<Feature> features = Feature.values();
        for (Feature feature : features) {
            if (feature.name() == featureName) {
                return feature;
            }
        }
        return null;
    }

}