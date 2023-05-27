#!/usr/bin/env bash
set -ev

# test specific setup
qkviewid=$(<./qkviewid)


# test qkview deletion
[[ "$(./ihac-qkviewdelete $qkviewid)" == "$qkviewid OK" ]] || exit 1


# check if qkview was removed from ihealth
./ihac-qkviewlist | grep $qkviewid && exist 1 || true


# check behaviour when qkview does not exist
[[ $(./ihac qkviewdelete 245245245 2>&1) == "Error: <qkviewID> not found." ]] || exit 1
