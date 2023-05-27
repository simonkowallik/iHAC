#!/usr/bin/env bash
set -ev

# test specific setup
qkviewid=$(<./qkviewid)
mkdir -p ./fileget


# test simple file fetch
./ihac-fileget $qkviewid /VERSION | grep '^Product:' > /dev/null || exit 1


# test directory ./directory-does-not-exist does not exist
missing_directory=$(./ihac fileget -o ./directory-does-not-exist/ $qkviewid /config/bigip.conf 2>&1 && exit 1) || \
    echo "$missing_directory" | grep 'directory-does-not-exist' > /dev/null || exit 1


# download multiple files to output directory
./ihac-fileget --output-directory ./fileget/ $qkviewid /VERSION /config/bigip.conf && \
    grep 'TMSH-VERSION' ./fileget/config/bigip.conf && \
    grep '^Product:' ./fileget/VERSION


# download multiple files to output directory using wildcards
./ihac fileget --output-directory ./fileget/ $qkviewid /config/bigip*.conf /etc/security/* && \
    [[ $(find ./fileget -type f | wc -l) -gt 2 ]] || exit 1