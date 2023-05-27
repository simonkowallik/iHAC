#!/usr/bin/env bash
set -ev

# test specific setup
bigiq_qkviewid=$(<./bigiq_qkviewid)


# test qkview deletion
[[ "$(./ihac qkviewdelete $bigiq_qkviewid)" == "$bigiq_qkviewid OK" ]] || exit 1


# check if qkview was removed from ihealth
./ihac-qkviewlist | grep $bigiq_qkviewid && exist 1 || true
