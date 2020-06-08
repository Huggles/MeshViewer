########################################################################################################
# Author      : Hugo van Krimpen
# Date        : 08-06-2020
# Parameter 1 : Alias/Username of the scratch org / user
########################################################################################################

SCRATCH_ORG_ALIAS=$1

echo "RUNNING: sfdx force:source:push -u $SCRATCH_ORG_ALIAS -f"
sfdx force:source:push -u "$SCRATCH_ORG_ALIAS" -f

