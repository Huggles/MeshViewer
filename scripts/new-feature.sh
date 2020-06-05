
########################################################
#Check git commits. There should be no uncommited work #
########################################################
sh operations/check-git-commits.sh
quit=$?
if [[ "$quit" == 1 ]]; then
    exit
  fi

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
echo " "

###############################################
#Ask for how long the scratch org should live #
###############################################
DURATION_DEFAULT=30
echo "How long should the scratch org exist?"
read -p $DURATION_DEFAULT DURATION
if [[ "$DURATION" == '' ]]; then
    DURATION=$DURATION_DEFAULT
  fi
echo " "


#########################################
#Ask if LC debug mode should be enabled #
#########################################
LC_DEBUG_MODE_DEFAULT="n"
echo "Enable LC Debug mode for administrator?"
read -p $LC_DEBUG_MODE_DEFAULT LC_DEBUG_MODE
if [[ "$LC_DEBUG_MODE" == '' ]]; then
    LC_DEBUG_MODE=$LC_DEBUG_MODE_DEFAULT
  fi
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

git checkout -f -b "feature/$SCRATCH_ORG_ALIAS" "feature/CI-Scripts"

sh operations/create-scratch-org.sh "$SCRATCH_ORG_ALIAS" $DURATION
sh operations/push-source.sh "$SCRATCH_ORG_ALIAS"
sh operations/assign-permission-set.sh "$SCRATCH_ORG_ALIAS" "Company_info_administrator"

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