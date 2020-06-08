########################################################################################################
# Author      : Hugo van Krimpen
# Date        : 08-06-2020
# Parameter 1 : Alias/Username of the scratch org / user
# Parameter 2 : Alias/Username of the standard user
########################################################################################################

SCRATCH_ORG_ALIAS=$1
SCRATCH_ORG_SU_ALIAS=$2

echo "RUNNING: force:user:create -u $SCRATCH_ORG_ALIAS -a $SCRATCH_ORG_SU_ALIAS -f ../config/companyinfo-user-def.json"
sfdx force:user:create -u $SCRATCH_ORG_ALIAS -a $SCRATCH_ORG_SU_ALIAS -f ../config/companyinfo-user-def.json
echo " "

echo "Generating Password ... "
sfdx force:user:password:generate -u $SCRATCH_ORG_ALIAS -o $SCRATCH_ORG_SU_ALIAS
echo " "