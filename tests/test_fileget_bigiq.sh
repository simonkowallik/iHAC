#!/usr/bin/env bash
set -ev

# test specific setup
bigiq_qkviewid=$(<./bigiq_qkviewid)
mkdir -p ./fileget_bigiq


# test simple file fetch
./ihac-fileget $bigiq_qkviewid /VERSION | grep '^Product:' > /dev/null || exit 1


# test directory ./directory-does-not-exist does not exist
missing_directory=$(./ihac-fileget -o ./directory-does-not-exist/ $bigiq_qkviewid /config/bigip.conf 2>&1 && exit 1) || \
    echo "$missing_directory" | grep 'directory-does-not-exist' > /dev/null || exit 1


# download multiple files to output directory
./ihac-fileget --output-directory ./fileget_bigiq/ $bigiq_qkviewid /VERSION /config/bigip.conf && \
    grep 'TMSH-VERSION' ./fileget_bigiq/config/bigip.conf && \
    grep '^Product:' ./fileget_bigiq/VERSION


# download multiple files to output directory using wildcards
./ihac-fileget --output-directory ./fileget_bigiq/ $bigiq_qkviewid /config/bigip*.conf /etc/security/* && \
    [[ $(find ./fileget_bigiq -type f | wc -l) -gt 2 ]] || exit 1
