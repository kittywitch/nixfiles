#!/bin/bash
set -eu
set -o pipefail


if systemctl --user is-active konawall-rotation.timer --quiet; then
	systemctl --user stop konawall-rotation.timer
else
	systemctl --user start konawall-rotation.timer
fi
