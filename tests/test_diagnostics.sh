#!/usr/bin/env bash
set -ev

# test specific setup
qkviewid=$(<./qkviewid)


# check if Sevirity is part of the response
[[ $(./ihac-diagnostics $qkviewid | grep -e 'Severity: LOW' -e 'Severity: MEDIUM' -e 'Severity: HIGH' | wc -l) -gt 0 ]] || exit 1


# check if SOLs/K entries exist
[[ $(./ihac-diagnostics $qkviewid | grep -e 'SOLs:.*f5\.com' | wc -l) -gt 0 ]] || exit 1


# check if json is returned
./ihac diagnostics --json $qkviewid | jq . >/dev/null 2>&1 || exit 1


# check if valid xml is returned
./ihac diagnostics --xml $qkviewid | xmllint - >/dev/null 2>&1 || exit 1


# check behaviour when qkview does not exist
[[ $(./ihac-diagnostics 245245245 2>&1) == "Error: qkview ID not found." ]] || exit 1