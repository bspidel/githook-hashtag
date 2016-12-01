#/bin/sh
########################################################################
#
# NAME githook-hashstag-deploy.sh - Place copy of update into hook dir
#
# DESCRIPTION Since "update" is a generic script, this deployment script
#      will not overwrite someone elses work.
#
########################################################################

. /etc/githook-hashtag.conf

del=" "

bmsql() {
  psql --username=postgres --dbname=$dbname --no-align --tuples-only --field-separator="$del" <<END
  $* ;
END
}

reps=$(mktemp /tmp/repos-XXXXXX)
bmsql "SELECT u.name, r.name FROM repository r join \"user\" u on u.id = r.owner_id  WHERE r.name LIKE '%-ubn%'" > $reps

lines=$(wc -l $reps)

if [ x$lines -lt 1 ] ; then
  echo "Warning: No ubn repositories detected."
else 
  while read user repo ; do
    tgt=$repos/$user/${repo}.git/hooks

    if [ $tgt/update ] ; then
      echo "Warning: $tgt/update already exists. Will not overwrite."
    else 
      cp githook-hashtag.conf  /etc
      cp update $repos/$user/${repo}.git/hooks
    fi
  done < $reps
fi

rm $reps

