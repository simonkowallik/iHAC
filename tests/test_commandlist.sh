#!/usr/bin/env bash
set -ev

# test specific setup
qkviewid=$(<./qkviewid)

# test
./ihac commandlist $qkviewid | grep /sys >/dev/null || exit 1
