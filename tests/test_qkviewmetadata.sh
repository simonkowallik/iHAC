#!/usr/bin/env bash
set -ev

# test specific setup
qkviewid=$(<./qkviewid)

# check qkviewmetadata
./ihac-qkviewmetadata $qkviewid | grep -i 'visible_in_gui=true' >/dev/null || exit 1


# update qkviewmetadata
./ihac-qkviewmetadata $qkviewid 'visible_in_gui=false' | grep -i 'visible_in_gui=false' >/dev/null || exit 1
