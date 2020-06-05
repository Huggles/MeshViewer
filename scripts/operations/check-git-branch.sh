########################################################################################################
# Warning: Do not run this script individually. It requires input parameters provided by other scripts #
########################################################################################################

while :
do
  branch_name="$(git rev-parse --abbrev-ref HEAD)"
  if [[ "$branch_name" == 'feature/CI-Scripts' ]]; then
    echo 'a'
    exit 0
  fi
  if [[ "$branch_name" != 'develop' ]]; then
    echo "Currently on branch $branch_name"
    echo "You must be on branch develop to run this script? Switch to the develop branch or enter q to quit?"

  fi
  read END
  if [[ "$END" == 'q' ]]; then
    exit 1
  fi
done



