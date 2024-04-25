#!/usr/bin/env bash
# shellcheck disable=SC2001

log_info() { echo "$@" | sed 's/^/INFO:\t/' >&2; }
log_err() { echo "$@" | sed 's/^/ERROR:\t/' >&2; }
log_warning() { echo "$@" | sed 's/^/WARNING:\t/' >&2; }

build_necessity_json_output() {
  local key=$1
  local value=$2
  local output

  output="$(jq -n --arg key "$key" --arg value "$value" '{($key):$value }')"

  echo "$output" | tr -d '\n'
}
