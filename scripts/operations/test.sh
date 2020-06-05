uncommitted_changes="$(git diff --name-only)"

echo $uncommitted_changes
length=${#uncommitted_changes}
echo $length

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