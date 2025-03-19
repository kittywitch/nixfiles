#!/usr/bin/env bash

CPU_JSON=$(lscpu --json | jq '.lscpu | reduce .[] as $i ({}; .[$i.field] = $i.data)')
CPU_SOCKETS=$(echo "$CPU_JSON" | jq '."Socket(s):"' -r)
CPU_CORES_PER_SOCKET=$(echo "$CPU_JSON" | jq '."Core(s) per socket:"' -r)
CPU_THREADS_PER_CORE=$(echo "$CPU_JSON" | jq '."Thread(s) per core:"' -r)
CPU_TOTAL_THREADS_PER_SOCKET=$(($CPU_CORES_PER_SOCKET*$CPU_THREADS_PER_CORE))
if [ $CPU_SOCKETS -eq 1 ]; then
  echo "${CPU_CORES_PER_SOCKET}c${CPU_TOTAL_THREADS_PER_SOCKET}t"
else
  echo "${CPU_SOCKETS}s${CPU_CORES_PER_SOCKET}t${CPU_TOTAL_THREADS_PER_SOCKET}t"
fi
