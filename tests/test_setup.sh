#!/usr/bin/env bash
set -ev

# authenticate to ihealth
[[ "$(cat ./tests/cred.txt | ./ihac-auth)" == "OK" ]] || exit 1

# upload qkview
qkviewid=$(./ihac-qkviewadd ./tests/qkview.tgz | egrep -o '([0-9]+)')
echo "$qkviewid" > ./qkviewid
[[ -z $qkviewid ]] && echo "qkviewid empty" && exit 1

# wait for ihealth to finish analysis
while [[ "$(./ihac-filelist $qkviewid | wc -l)" -eq "0" ]]
do
    sleep 10; echo -n '.'
done
echo 'done'