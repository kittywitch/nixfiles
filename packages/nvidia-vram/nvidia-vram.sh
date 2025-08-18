#!/usr/bin/env bash

set -euo pipefail

SMI_OUTPUT="$(nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader,nounits)"

echo "$SMI_OUTPUT" | while IFS=", " read -r usedvmem totalvmem
do
  PERCENTAGE=$(echo "scale=1; (${usedvmem} / ${totalvmem}) * 100" | bc)
  echo "${usedvmem}/${totalvmem}MiB (${PERCENTAGE}%)"
done
