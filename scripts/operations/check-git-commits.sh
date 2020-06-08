########################################################################################################
# Author      : Hugo van Krimpen
# Date        : 08-06-2020
########################################################################################################

committed_changes="$(git diff --name-only)"
committed_changes_length=${#committed_changes}
if [[ "$committed_changes_length" -gt 0 ]]; then
    tput setaf 1;
    echo "############# -> WARNING <- ###############"
    echo "Your environment has uncommited changes."
    echo "This script will throw away any uncomitted local changes!! "
    echo "First commit all your local changes before continue."


    echo "Are you sure you want to continue? (y)"
    tput sgr0;
    read continue
    if [[ "$continue" == 'y' ]]; then
      exit 0
    fi
    exit 1
  fi