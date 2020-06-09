########################################################################################################
# Author      : Hugo van Krimpen
# Date        : 08-06-2020
# Parameter 1 : Alias/Username of the scratch org / user
# Parameter 2 : Name of the permissionset
########################################################################################################

SCRATCH_ORG_ALIAS=$1
PERMISSION_SET_NAME=$2

echo "RUNNING: sfdx force:user:permset:assign -u \"$SCRATCH_ORG_ALIAS\" -n \"$PERMISSION_SET_NAME\""
sfdx force:user:permset:assign -u "$SCRATCH_ORG_ALIAS" -n "$PERMISSION_SET_NAME"