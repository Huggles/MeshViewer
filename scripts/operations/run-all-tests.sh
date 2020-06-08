########################################################################################################
# Author      : Hugo van Krimpen
# Date        : 08-06-2020
# Parameter 1 : Alias/Username of the scratch org / user
# Parameter 2 : Number of days the scratch org should live
########################################################################################################

SCRATCH_ORG_ALIAS=$1

echo "RUNNING: sfdx force:apex:test:run -c -l RunAllTestsInOrg -r human -y -u $SCRATCH_ORG_ALIAS"
sfdx force:apex:test:run -c -l RunAllTestsInOrg -r human -y -u $SCRATCH_ORG_ALIAS