########################################################################################################
# Author      : Hugo van Krimpen
# Date        : 08-06-2020
# Parameter 1 : Alias/Username of the scratch org / user
# Parameter 2 : 04t/Alias of the package version
########################################################################################################

SCRATCH_ORG_ALIAS=$1
PACKAGE_VERSION_NAME=$2

echo "RUNNING: sfdx force:package:install -u $SCRATCH_ORG_ALIAS -p $PACKAGE_VERSION_NAME -w 15"
sfdx force:package:install -u $SCRATCH_ORG_ALIAS -p $PACKAGE_VERSION_NAME -w 15 -r