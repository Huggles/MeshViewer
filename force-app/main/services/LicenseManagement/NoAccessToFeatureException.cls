/**
 * Created by jaapbranderhorst on 24/05/2020.
 */

/**
 * Throw this if a user tries to get access to a feature where he doesn't have access to.
 */
public with sharing class NoAccessToFeatureException extends LicenseManagementException {

}