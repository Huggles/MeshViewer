########################################################################################################
# Author      : Hugo van Krimpen
# Date        : 08-06-2020
########################################################################################################

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


