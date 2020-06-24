
########################################################################################################
# Author      : Hugo van Krimpen
# Date        : 08-06-2020
# Parameter 1 : Alias/Username of the scratch org / user
# Parameter 2 : Alias/Username of the standard user
########################################################################################################

SCRATCH_ORG_ALIAS=$1
SCRATCH_ORG_SU_ALIAS=$2
PERMISSION_SET_NAME=$3

sh operations/create-standard-user.sh "$SCRATCH_ORG_ALIAS" "$SCRATCH_ORG_SU_ALIAS"
sh operations/assign-permission-set.sh "$SCRATCH_ORG_SU_ALIAS" "$PERMISSION_SET_NAME"


