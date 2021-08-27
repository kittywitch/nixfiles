#!/bin/bash
set -eu
set -o pipefail

sleep 0.5s

if systemctl --user is-active konawall-rotation.timer --quiet; then
	status='{"text": "", "alt": "Konawall is enabled.", "class": "enabled"}'
else
	status='{"text": "", "alt": "Konawall is disabled.", "class": "disabled"}'
fi

echo $status
