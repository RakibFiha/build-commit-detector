#!/usr/bin/env bash

set -euo pipefail

usage() { 
  echo "Usage:" && echo "  $(basename "$0") COMMIT_MSG KEYWORDS (Space seperated string)"; 
  echo "  ENV: [BUILD_COMMIT_DETECTOR_STRICTNESS: default less (ACTION PROVIDED)], [RUNNER_DEBUG: default false (GITHUB PROVIDED)]"
}

# shellcheck disable=SC2001
log_info() { echo "$@" | sed 's/^/INFO:\t/' >&2; }
# shellcheck disable=SC2001
log_err() { echo "$@" | sed 's/^/ERROR:\t/' >&2; }
# shellcheck disable=SC2001
log_warning() { echo "$@" | sed 's/^/WARNING:\t/' >&2; }

detect_build_necessity() {
  local commit_msg=$1
  local keywords_str=$2
  local keywords

  IFS=' ' read -r -a keywords <<< "$keywords_str"

  case $commit_msg in
    --|' ') commit_msg="$(git log --format=%B -n 1 HEAD)" ;;
    *) log_warning "commit_msg is set as:  '$commit_msg'" ;;
  esac

  log_info "keywords: ${keywords[*]}"

  for keyword in "${keywords[@]}"; do
    log_info "keyword: $keyword"
    if grep -qw -e "$keyword" <<< "$commit_msg"; then
      echo "build_necessarry=false" | tee -a "${GITHUB_ENV:-/dev/null}" "${GITHUB_OUTPUT:-/dev/null}"
      if [[ "${BUILD_COMMIT_DETECTOR_STRICTNESS:-low}" == "high" ]]; then
        log_err "BUILD_COMMIT_DETECTOR_STRICTNESS is set to high... Exiting..." && exit 1
      else
        return
      fi
    fi
  done

  echo "build_necessarry=true" | tee -a "${GITHUB_ENV:-/dev/null}" "${GITHUB_OUTPUT:-/dev/null}"
}

if (( $# != 2 )); then usage && exit 1; fi

if "${RUNNER_DEBUG:-false}"; then set -x; fi

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then detect_build_necessity "$@"; fi
