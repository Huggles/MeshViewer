#move to root directory first
cd ..

#Works for both OSX and Windows
echo "Name your scratch org"
read SCRATCH_ORG_ALIAS
echo "Creating scratch org named $SCRATCH_ORG_ALIAS"
echo "Delete scratch org afterwards?:"
read DELETE
echo " "
RUNTESTS="n"
if [ "$DELETE" = "y" ]
then
  echo "Run all org tests after creation?:"
  read RUNTESTS
  echo " "
  fi
DURATION=7
OPEN="n"
if [ "$DELETE" = "n" ]
then
echo "Duration:"
read DURATION
echo " "

echo "Enable LC Debug mode?:"
read LC_DEBUG_MODE
echo " "

echo "Open scratch org afterwards?:"
read OPEN
echo " "



fi
echo " "
echo "RUNNING: sfdx force:org:create -f config/project-scratch-def.json -a $SCRATCH_ORG_ALIAS -d $DURATION"

sfdx force:org:create -f config/project-scratch-def.json  -a $SCRATCH_ORG_ALIAS -d $DURATION
{
  #Try and run these commands. If they fail, fallback to commands in second set of brackets.
  sfdx force:source:push -u $SCRATCH_ORG_ALIAS -f
  sfdx force:user:permset:assign -n Company_info_administrator -u $SCRATCH_ORG_ALIAS
  sfdx force:user:permset:assign -n Company_info_user -u $SCRATCH_ORG_ALIAS
}
echo "Finished creating $SCRATCH_ORG_ALIAS"


#Delete Scratch org
if [ "$DELETE" = "y" ]
then
  if [ "$RUNTESTS" = "y" ]
  then
    echo "Running all tests..."
    sfdx force:apex:test:run -c -l RunAllTestsInOrg -r human -y -u $SCRATCH_ORG_ALIAS
    fi
  echo "Deleting scratch org..."
  sfdx force:org:delete -u $SCRATCH_ORG_ALIAS -p
fi

if [ "$LC_DEBUG_MODE" = "y" ]
then
  echo "update new User(Id = UserInfo.getUserId(), UserPreferencesUserDebugModePref=true);" | sfdx force:apex:execute -u $SCRATCH_ORG_ALIAS
fi

#Open Scratch org
if [ "$OPEN" = "y" ]
then
  sfdx force:org:open -u $SCRATCH_ORG_ALIAS
fi
read END


echo "Quit? (y)"
while :
do
  read END
  if [[ "$END" == 'y' ]]; then
    break
  fi
done