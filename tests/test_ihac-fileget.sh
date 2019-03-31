#!/usr/bin/env bash
set -ev

qkviewid=(<./qkviewid)


ihac-fileget $qkviewid /VERSION \
  | grep '^Product:' > /dev/null || exit 1


# ./qkview does not exist
./ihac-fileget -o ./qkview/ $qkviewid /config/bigip.conf

mkdir ./qkview
