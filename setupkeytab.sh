#!/bin/bash
set -e
username=$1
domain=$2
uppercasedomain=${domain^^}
password=$3
kvno=$4
localhost=$5

u="$(whoami)"
echo "Running as: ${u}"

usernameplusdomain="${username}@${uppercasedomain}"

echo "User name: ${usernameplusdomain}"

set -x


{
  echo "addent -password -p ${usernameplusdomain} -k ${kvno} -e RC4-HMAC"
  sleep 1
  echo "${password}"
  sleep 1
  echo "rkt /etc/nginx/${localhost}.HTTP.keytab"
  sleep 1
  echo "rkt /etc/nginx/${localhost}.hosts.keytab"
  sleep 1
  echo "wkt user.keytab"
  sleep 1
  echo "list"
} |
ktutil


kinit -kt user.keytab ${usernameplusdomain} -V
set +x
