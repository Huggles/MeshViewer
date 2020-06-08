########################################################################################################
# Author      : Hugo van Krimpen
# Date        : 08-06-2020
# Parameter 1 : Alias/Username of the scratch org / user
########################################################################################################

SCRATCH_ORG_ALIAS=$1

echo "update new User(Id = UserInfo.getUserId(), UserPreferencesUserDebugModePref=true);" | sfdx force:apex:execute -u $SCRATCH_ORG_ALIAS