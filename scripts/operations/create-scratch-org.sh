########################################################################################################
# Author      : Hugo van Krimpen
# Date        : 08-06-2020
# Parameter 1 : Alias/Username of the scratch org / user
# Parameter 2 : Number of days the scratch org should live
########################################################################################################

SCRATCH_ORG_ALIAS=$1
DURATION=$2
CONFIG=$3

echo "RUNNING: sfdx force:org:create -f \"$CONFIG\" -a \"$SCRATCH_ORG_ALIAS\" -d $DURATION"
sfdx force:org:create -f "$CONFIG" -a "$SCRATCH_ORG_ALIAS" -d $DURATION
