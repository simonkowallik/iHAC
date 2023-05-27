#!/usr/bin/env bash
set -ev

# test specific setup
qkviewid=$(<./qkviewid)

# test
./ihac filelist $qkviewid /VERSION | grep /config/bigip > /dev/null || exit 1
