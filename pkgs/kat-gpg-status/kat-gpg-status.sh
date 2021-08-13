#!/bin/bash
set -eu
set -o pipefail

if gpg --card-status &> /dev/null; then
	user="$(gpg --card-status | grep 'Login data' | awk '{print $NF}')";
	status='{"text": "", "alt": "User: '"$user"'", "class": "enabled"}'
else
	status='{"text": "", "alt": "No card is connected.", "class": "disabled"}'
fi

echo $status
