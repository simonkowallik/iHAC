#!/usr/bin/env bash
set -ev

# test specific setup
bigiq_qkviewid=$(<./bigiq_qkviewid)


# test qkview deletion
[[ "$(./ihac qkviewdelete $bigiq_qkviewid)" == "$bigiq_qkviewid OK" ]] || exit 1


# check if qkview was removed from ihealth
./ihac-qkviewlist | grep $bigiq_qkviewid && exist 1 || true


# check behaviour when qkview does not exist
[[ $(./ihac-qkviewdelete 245245245 2>&1) == "Error: qkview ID not found." ]] || exit 1
