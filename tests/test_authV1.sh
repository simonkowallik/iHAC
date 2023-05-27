#!/usr/bin/env bash
set -ev

# invalid credentials
[[ "$(./ihac-authV1 '{"user_id": "testing-a-failed-login", "user_secret": "none"}' 2>&1)" == "Error: authentication failed." ]] || exit 1

# invalid JSON
[[ "$(./ihac authV1 '{"invalid": json}' 2>&1)" == "Error: Unknown error occurred." ]] || exit 1

# authenticate to ihealth
[[ "$(./ihac authV1 "$GH_ACTIONS_IHAC_CREDENTIALS")" == "OK" ]] || exit 1
