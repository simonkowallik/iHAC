#!/usr/bin/env bash
set -ev

# test specific setup
qkviewid=$(<./qkviewid)

# test
./ihac commandrun $qkviewid 'pstree' | grep -i 'init' >/dev/null || exit 1
