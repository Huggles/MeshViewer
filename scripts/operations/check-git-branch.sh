########################################################################################################
# Author      : Hugo van Krimpen
# Date        : 08-06-2020
# Parameter 1 : Alias/Username of the scratch org / user
########################################################################################################

SCRATCH_ORG_ALIAS=$1


branch_name="$(git rev-parse --abbrev-ref HEAD)"
CHECKOUT="y"
if [[ "$branch_name" != 'develop' ]]; then
  echo "Currently on branch $branch_name"
  echo "You must be on branch develop to run this script. Switch to the develop branch? (y)"
  read CHECKOUT
fi
if [[ "$CHECKOUT" == 'y' ]]; then
  git checkout "develop"
fi
exit 1


