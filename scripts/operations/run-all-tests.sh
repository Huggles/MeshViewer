########################################################################################################
# Warning: Do not run this script individually. It requires input parameters provided by other scripts #
########################################################################################################

SCRATCH_ORG_ALIAS=$1

echo "RUNNING: sfdx force:apex:test:run -c -l RunAllTestsInOrg -r human -y -u $SCRATCH_ORG_ALIAS"
sfdx force:apex:test:run -c -l RunAllTestsInOrg -r human -y -u $SCRATCH_ORG_ALIAS