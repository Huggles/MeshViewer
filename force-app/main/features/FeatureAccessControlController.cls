/**
 * Created by jaapbranderhorst on 16/06/2020.
 */

public inherited sharing class FeatureAccessControlController {

    /**
     * @param featureName the name of the feature
     *
     * @return true if the user has access to the feature, false otherwise. Throws an error if the feature name doesn't exist
     */
    @AuraEnabled(cacheable=true)
    public static AuraResponseWrapper checkAccess(String featureName) {
        try {
            if (getFeatureNames().contains(featureName)) {
                return new AuraResponseWrapper(LicenseManagementService.userHasAccess(getFeatureByName(featureName)));
            } else {
                throw new InputException('No feature named ' + featureName);
            }
        } catch (Exception ex) {
            return new AuraResponseWrapper(ex, true, true);
        }
    }
    public static Boolean checkAccess(Feature feature) {
        try {
            if (feature != null) {
                return LicenseManagementService.userHasAccess(feature);
            } else {
                throw new InputException('Feature cannot be null');
            }
        } catch (Exception ex) {
            ErrorLogUtil.logException(ex, true);
            return false;
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

    private static List<String> getFeatureNames() {
        List<String> featureNames = new List<String>();
        List<Feature> features = Feature.values();
        for (Feature feature : features) {
            featureNames.add(feature.name());
        }
        return featureNames;
    }

}