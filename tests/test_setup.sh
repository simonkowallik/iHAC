#!/usr/bin/env bash

ihac-auth < ./tests/ihac-credentials.txt

ihac-qkviewadd ./tests/qkview_12.1.4.tar.gz | egrep -o '([0-9]+)' > ./qkviewid