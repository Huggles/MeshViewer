#!/bin/sh

echo "Name your scratch org"
read SCRATCH_ORG_ALIAS
echo "Creating scratch org named $SCRATCH_ORG_ALIAS"

echo "Delete scratch org afterwards?:"
read -q DELETE

DURATION=7
OPEN="n"
if [ "$DELETE" = "n" ]
then
echo "Duration:"
read DURATION

echo "Open scratch org afterwards?:"
read -q OPEN
fi



echo ""
echo "RUNNING: sfdx force:org:create -f config/project-scratch-def.json -v appsolutelydevhub -a $SCRATCH_ORG_ALIAS -d $DURATION"
sfdx force:org:create -f config/project-scratch-def.json -v appsolutelydevhub -a $SCRATCH_ORG_ALIAS -d $DURATION
{
  #Try and run these commands. If they fail, fallback to commands in second set of brackets.
  sfdx force:source:push -u $SCRATCH_ORG_ALIAS -f
  sfdx force:user:permset:assign -n Company_info_user -u $SCRATCH_ORG_ALIAS
  sfdx force:user:permset:assign -n Customer_connect_administrator -u $SCRATCH_ORG_ALIAS
} ||
{
  #If the above 3 commands fail, make sure to remove the scratch org.
  sfdx force:org:delete -u $SCRATCH_ORG_ALIAS -p
}

echo "Finished creating $SCRATCH_ORG_ALIAS"

#Delete Scratch org
if [ "$DELETE" = "y" ]
then
  sfdx force:org:delete -u $SCRATCH_ORG_ALIAS -p
fi

#Open Scratch org
if [ "$OPEN" = "y" ]
then
  sfdx force:org:open -u $SCRATCH_ORG_ALIAS
fi

