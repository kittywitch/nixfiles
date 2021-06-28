#!/bin/bash
set -eu
set -o pipefail

if gpg --card-status &> /dev/null; then
	user="PGP $(gpg --card-status | grep 'Login data' | awk '{print $NF}')";
else
	user="PGP DC"
fi

echo $user
