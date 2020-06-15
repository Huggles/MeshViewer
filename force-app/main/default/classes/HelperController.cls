/**
 * Created by Hugo on 15/06/2020.
 */

public with sharing class HelperController {
    @AuraEnabled(Cacheable = true)
    public static Boolean userCheckFeatureAccess(String featureName) {
        try{
            Feature f = getFeatureByString(featureName);
            if(f == null){
                String error = Label.Feature_Not_Found + ': ' + featureName;
                AuraHandledException ex = new AuraHandledException(error);
                ex.setMessage(error);
                throw ex;
            }
            LicenseManagementService.userHasAccess(f); //Throws an exception when the user has no access.
            return true;
        }catch (Exception e){
            if(e.getTypeName() == String.valueOf(NoAccessToFeatureException.class)){
                return false; //If no access exception was thrown, this function should return false.
            }
            if(e.getTypeName() == String.valueOf(AuraHandledException.class)){
                throw e; //If an AuraHandledException was thrown, just throw it again and let the LWC handle it.
            }
            //In all other cases, build an AuraHandledException and throw that.
            AuraHandledException ex = new AuraHandledException(e.getMessage());
            ex.setMessage(e.getMessage());
            throw ex;
        }
    }
    private static Feature getFeatureByString(String featureName){
        for (Feature f : Feature.values()) {
            if (f.name() == featureName) return f;
        }
        return null;
    }
}