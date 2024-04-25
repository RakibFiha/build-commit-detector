#!/usr/bin/env bash
# shellcheck disable=SC2001

usage() { 
  echo "Usage:" && echo "  $(basename "$0") COMMIT_MSG KEYWORDS (Space seperated string)"; 
  echo "  ENV: [BUILD_COMMIT_DETECTOR_STRICTNESS: default low, can also be moderate or high (ACTION PROVIDED)], [RUNNER_DEBUG: default false (GITHUB PROVIDED)]"
}

log_info() { echo "$@" | sed 's/^/INFO:\t/' >&2; }
log_err() { echo "$@" | sed 's/^/ERROR:\t/' >&2; }
log_warning() { echo "$@" | sed 's/^/WARNING:\t/' >&2; }

build_necessary_json_output() {
  local key=$1
  local value=$2
  local output

  output="$(jq -n \
    --arg key "$key" --arg value "$value" '{ build_necessary: { ($key): $value } }'
  )"

  echo "$output"
}

detect_build_necessity() {
  local commit_msg=$1
  local keywords_str=$2
  local keywords

  IFS=' ' read -r -a keywords <<< "$keywords_str"

  if type -p ggrep > /dev/null; then grep=ggrep; else grep="grep"; fi
  if $grep --version | grep -w 'BSD' > /dev/null; then log_err "GNU grep is required; Install with 'brew install grep'" && exit 1; fi

  case $commit_msg in
    --|' ')
      log_warning "commit_msg: is not set; using '$(git log --format=%B -n 1 HEAD)'"
      commit_msg="$(git log --format=%B -n 1 HEAD)" ;;
    *) : ;;
  esac

  log_info "keywords: ${keywords[*]}"

  for keyword in "${keywords[@]}"; do
    if $grep -wP "(?<![\w-])$keyword(?![\w-])" <<< "$commit_msg"; then

      build_necessary_json_output build false | tee -a "${GITHUB_ENV:-/dev/null}" "${GITHUB_OUTPUT:-/dev/null}"

      case ${BUILD_COMMIT_DETECTOR_STRICTNESS:-low} in
        low) return 0 ;;
        moderate) log_warning "BUILD_COMMIT_DETECTOR_STRICTNESS is set to moderate.." && return 1 ;;
        high) log_err "BUILD_COMMIT_DETECTOR_STRICTNESS is set to high... Exiting..." && exit 1 ;;
      esac
    fi
  done

  build_necessary_json_output build true | tee -a "${GITHUB_ENV:-/dev/null}" "${GITHUB_OUTPUT:-/dev/null}"
}

if "${RUNNER_DEBUG:-false}"; then set -x; fi

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  set -euo pipefail 

  if (( $# != 2 )); then usage && exit 1; fi
   detect_build_necessity "$@";
fi
