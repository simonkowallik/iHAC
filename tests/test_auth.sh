#!/usr/bin/env bash
set -ev

# invalid credentials
[[ "$(./ihac-auth 'client_id:client_secret' 2>&1)" =~ "Error: authentication failed" ]] || exit 1

# authenticate to ihealth
[[ "$(./ihac auth "$GH_ACTIONS_IHAC_CREDENTIALSV2")" == "OK" ]] || exit 1
