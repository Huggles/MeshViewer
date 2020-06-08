########################################################################################################
# Author      : Hugo van Krimpen
# Date        : 08-06-2020
# Description : Creates an org and installs a version of a package on it. Creates a standard user with
#               the user permission set. Org lives for 30 days.
########################################################################################################

###############################################################
#Check git branch. New feature script should run from develop #
###############################################################
#sh operations/check-git-branch.sh
#quit=$?
#if [[ "$quit" == 1 ]]; then
#    exit
#  fi

#########################################################
#Ask for the name the scratch org and branch should get #
#########################################################
echo "What is the story ID? This will be used as branch name and scratch org name."
read SCRATCH_ORG_ALIAS
SCRATCH_ORG_SU_ALIAS=${SCRATCH_ORG_ALIAS}+"StandardUser"
echo " "

#########################################################
#Ask for the name the scratch org and branch should get #
#########################################################

sfdx force:package:list
echo "What package do you want to install a version of? (enter 0Ho Id or Alias)"
read PACKAGE_NAME
echo " "

#########################################################
#Ask for the name the scratch org and branch should get #
#########################################################
sfdx force:package:version:list -p $PACKAGE_NAME -o CreatedDate
echo "What package version do you want to install? (enter 04t Id or Alias)"
read PACKAGE_VERSION_NAME
echo " "

################################################################################################
#Ask whether the scratch org should automatically be opened once the process has been finished #
################################################################################################
OPEN_DEFAULT="y"
echo "Open the scratch org once it has been created?"
read -p $OPEN_DEFAULT OPEN
if [[ "$OPEN" == '' ]]; then
    OPEN=$OPEN_DEFAULT
  fi


###########################################
#Perform the operations based on the input#
###########################################
sh operations/create-scratch-org.sh "$SCRATCH_ORG_ALIAS" 30
sh operations/install-package-version.sh "$SCRATCH_ORG_ALIAS" "$PACKAGE_VERSION_NAME"
sh operations/assign-permission-set.sh "$SCRATCH_ORG_ALIAS" "Company_info_administrator"

sh operations/create-standard-user.sh "$SCRATCH_ORG_ALIAS" "$SCRATCH_ORG_SU_ALIAS"

if [ "$LC_DEBUG_MODE" = "y" ]
then
  sh operations/enable-lc-debug-mode.sh "$SCRATCH_ORG_ALIAS"
fi

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