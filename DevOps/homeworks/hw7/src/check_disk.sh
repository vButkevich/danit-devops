#!/bin/bash
set -euo pipefail

THRESHOLD="${1:-80}"
LOG_FILE="/var/log/disk.log"

usage_pct=$(
  df -P / | awk 'NR==2 {gsub("%","",$5); print $5}'
)

timestamp="$(date '+%Y-%m-%d %H:%M:%S')"

if [[ "$usage_pct" =~ ^[0-9]+$ ]] && [[ "$THRESHOLD" =~ ^[0-9]+$ ]]; then
  if (( usage_pct > THRESHOLD )); then
    echo "$timestamp WARNING: root filesystem usage is ${usage_pct}% (threshold ${THRESHOLD}%)" >> "$LOG_FILE"
  fi
else
  echo "$timestamp ERROR: invalid threshold or usage value" >> "$LOG_FILE"
  exit 1
fi
