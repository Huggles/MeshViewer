########################################################################################################
# Author      : Hugo van Krimpen
# Date        : 08-06-2020
# Description : Creates a branch and scratch org for a new feature.
########################################################################################################


##############################################
#Ask for the name the scratch org should get #
##############################################
echo "What is the story ID? This will be used as scratch org name."
read SCRATCH_ORG_ALIAS
echo " "

###############################################
#Ask for how long the scratch org should live #
###############################################
echo "How long should the scratch org exist?"
read DURATION
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

sh operations/create-scratch-org.sh "$SCRATCH_ORG_ALIAS" $DURATION "../config/project-scratch-def.json"
sh operations/push-source.sh "$SCRATCH_ORG_ALIAS"
sh operations/assign-permission-set.sh "$SCRATCH_ORG_ALIAS" "Company_info_administrator"
sh operations/assign-permission-set.sh "$SCRATCH_ORG_ALIAS" "Company_info_for_Dutch_Business"

sh operations/create-standard-user-with-permset.sh "$SCRATCH_ORG_ALIAS" "Company_info_for_Dutch_Business"


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