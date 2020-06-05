########################################################################################################
# Warning: Do not run this script individually. It requires input parameters provided by other scripts #
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
  git checkout -f "develop"
fi
exit 1


