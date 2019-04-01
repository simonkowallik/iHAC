#!/usr/bin/env bash
set -ev

# authenticate to ihealth
[[ "$(cat ./tests/cred.txt | ./ihac-auth)" == "OK" ]] || exit 1

# upload working qkview
qkviewid=$(./ihac-qkviewadd ./tests/qkview.tgz | egrep -o '([0-9]+)')
echo "$qkviewid" > ./qkviewid
[[ -z $qkviewid ]] && echo "qkviewid empty" && exit 1

# upload broken qkview
broken_qkviewid=$(./ihac-qkviewadd ./tests/qkview.tgz | egrep -o '([0-9]+)')
echo "$broken_qkviewid" > ./broken_qkviewid
[[ -z $broken_qkviewid ]] && echo "broken_qkviewid empty" && exit 1

# wait for ihealth to finish analysis
while [[ "$(./ihac-filelist $qkviewid | wc -l)" -eq "0" ]]
do
    sleep 10; echo -n '.'
done
echo 'done'