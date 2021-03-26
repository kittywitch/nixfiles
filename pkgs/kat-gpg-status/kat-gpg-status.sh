#!/bin/bash
set -eu
set -o pipefail

if gpg --card-status &> /dev/null; then
	user=" $(gpg --card-status | grep 'Login data' | awk '{print $NF}')";
else
	user=" Disconnected"
fi

echo $user
