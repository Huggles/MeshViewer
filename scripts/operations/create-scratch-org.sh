########################################################################################################
# Warning: Do not run this script individually. It requires input parameters provided by other scripts #
########################################################################################################

SCRATCH_ORG_ALIAS=$1
DURATION=$2

echo "RUNNING: sfdx force:org:create -f ../../config/project-scratch-def.json -a $SCRATCH_ORG_ALIAS -d $DURATION"
sfdx force:org:create -f ../../config/project-scratch-def.jso  -a "$SCRATCH_ORG_ALIAS" -d $DURATION