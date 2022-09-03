#!/usr/bin/env bash
set -ev

# invalid credentials
[[ "$(./ihac-auth '{"user_id": "testing-a-failed-login", "user_secret": "none"}' 2>&1)" == "Error: authentication failed." ]] || exit 1

# invalid JSON
[[ "$(./ihac-auth '{"invalid": json}' 2>&1)" == "Error: Unknown error occurred." ]] || exit 1

# authenticate to ihealth
[[ "$(./ihac-auth $GH_ACTIONS_IHAC_CREDENTIALS)" == "OK" ]] || exit 1
