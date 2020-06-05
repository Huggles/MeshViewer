########################################################################################################
# Warning: Do not run this script individually. It requires input parameters provided by other scripts #
########################################################################################################

SCRATCH_ORG_ALIAS=$1

echo "RUNNING: sfdx force:source:push -u $SCRATCH_ORG_ALIAS -f"
sfdx force:source:push -u "$SCRATCH_ORG_ALIAS" -f

