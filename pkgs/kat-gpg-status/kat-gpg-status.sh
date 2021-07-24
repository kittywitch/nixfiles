#!/bin/bash
set -eu
set -o pipefail

if gpg --card-status &> /dev/null; then
	user="$(gpg --card-status | grep 'Login data' | awk '{print $NF}')";
	status='{"text": "PGP +", "alt": "User: '"$user"'", "class": "enabled"}'
else
	status='{"text": "PGP -", "alt": "No card is connected.", "class": "disabled"}'
fi

echo $status
