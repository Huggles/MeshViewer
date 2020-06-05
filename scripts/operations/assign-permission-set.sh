########################################################################################################
# Warning: Do not run this script individually. It requires input parameters provided by other scripts #
########################################################################################################

SCRATCH_ORG_ALIAS=$1
PERMISSION_SET_NAME=$2

echo "RUNNING: sfdx force:user:permset:assign -u $SCRATCH_ORG_ALIAS -n $PERMISSION_SET_NAME"
sfdx sfdx force:user:permset:assign -u "$SCRATCH_ORG_ALIAS" -n "$PERMISSION_SET_NAME"