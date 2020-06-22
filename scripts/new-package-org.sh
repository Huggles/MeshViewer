########################################################################################################
# Author      : Hugo van Krimpen
# Date        : 08-06-2020
# Description : Creates an org and installs a version of a package on it. Creates a standard user with
#               the user permission set. Org lives for 30 days.
########################################################################################################

#########################################################
#Ask for the name the scratch org and branch should get #
#########################################################
echo "What should we name the test org?"
read SCRATCH_ORG_ALIAS
SCRATCH_ORG_SU_ALIAS=${SCRATCH_ORG_ALIAS}"StandardUser"
echo " "

#########################################################
#Ask for the name the scratch org and branch should get #
#########################################################

echo "What package version do you want to install? (enter 04t Id or Alias)"
read PACKAGE_VERSION_NAME
echo " "

################################################################################################
#Ask whether the scratch org should automatically be opened once the process has been finished #
################################################################################################
echo "Open the scratch org once it has been created?"
read OPEN
echo " "


###########################################
#Perform the operations based on the input#
###########################################
sh operations/create-scratch-org.sh "$SCRATCH_ORG_ALIAS" 30 "../config/enterprise-scratch-def.json"
sh operations/install-package-version.sh "$SCRATCH_ORG_ALIAS" "$PACKAGE_VERSION_NAME"
sh operations/assign-permission-set.sh "$SCRATCH_ORG_ALIAS" "Company_info_administrator"

sh operations/create-standard-user.sh "$SCRATCH_ORG_ALIAS" "$SCRATCH_ORG_SU_ALIAS"
sh operations/assign-permission-set.sh "$SCRATCH_ORG_SU_ALIAS" "Company_info_for_Dutch_Business"
sh operations/assign-permission-set.sh "$SCRATCH_ORG_SU_ALIAS" "Company_info_for_International_Business"
sh operations/assign-permission-set.sh "$SCRATCH_ORG_SU_ALIAS" "Company_info_for_Sales"


if [ "$OPEN" = "y" ]
then
  sfdx force:org:open -u $SCRATCH_ORG_ALIAS
fi
read END

#################################################################
#Quit? In place to avoid the screen closing without confirmation#
#################################################################
echo "Quit? (y)"
while :
do
  read END
  if [[ "$END" == 'y' ]]; then
    break
  fi
done