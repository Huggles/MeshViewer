########################################################################################################
# Warning: Do not run this script individually. It requires input parameters provided by other scripts #
########################################################################################################

SCRATCH_ORG_ALIAS=$1

echo "update new User(Id = UserInfo.getUserId(), UserPreferencesUserDebugModePref=true);" | sfdx force:apex:execute -u $SCRATCH_ORG_ALIAS