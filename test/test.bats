#!/usr/bin/env bats

setup() {
  load 'test_helper/bats-assert/load' # git clone https://github.com/bats-core/bats-assert test/test_helper/bats-assert
}

@test "source" {
  run source ./main.sh
  [ "$status" -eq 0 ]
}

@test "./main.sh" {
  run ./main.sh
  [ "$status" -eq 1 ]
}

@test "./main.sh 'skip-ci Initial Commit message' 'skip'" {
  run ./main.sh 'skip-ci Initial Commit message' 'skip'
  assert_output --partial "build_necessary=true" ## needs to be exact match 'skip-' should not be a match, use gnu grep implementation and not BSD grep implementation

  [ "$status" -eq 0 ]
}

@test "./main.sh 'skip-ci Initial Commit message' 'skip skip-c'" {
  run ./main.sh 'skip-ci Initial Commit message' 'skip skip-c'
  assert_output --partial "build_necessary=true" ## needs to be exact match 'skip-' should not be a match, use gnu grep implementation and not BSD grep implementation

  [ "$status" -eq 0 ]
}

@test "./main.sh 'skip-ci Initial Commit message' 'skip-ci'" {
  run ./main.sh 'skip-ci Initial Commit message' 'skip-ci'
  assert_output --partial "build_necessary=false"

  [ "$status" -eq 0 ]
}

@test "./main.sh 'skip-ci Initial Commit message' 'skip-ci' #High strictness" {
  run bash -c "BUILD_COMMIT_DETECTOR_STRICTNESS=high ./main.sh 'skip-ci Initial Commit message' 'skip-ci'"
  assert_output --partial "build_necessary=false"

  [ "$status" -eq 1 ]
}

@test "./main.sh 'skip-ci Initial Commit message' 'skip skip-ci'" {
  run ./main.sh 'skip-ci Initial Commit message' 'foo skip-ci'
  assert_output --partial "build_necessary=false"

  [ "$status" -eq 0 ]
}

@test "./main.sh 'スキップシーアイ Initial Commit message' 'foobar スキップシーアイ foo bar' $High strictness" {
  run bash -c "BUILD_COMMIT_DETECTOR_STRICTNESS=high ./main.sh 'skip-ci Initial Commit message' 'foo skip-ci'"
  assert_output --partial "build_necessary=false"

  [ "$status" -eq 1 ]
}

@test "./main.sh '--' 'skip-ci'" {
  run ./main.sh '--' 'skip-ci'
  assert_output --partial "build_necessary="

  [ "$status" -eq 0 ]

  run ./main.sh ' ' 'skip-ci'
  assert_output --partial "build_necessary="

  [ "$status" -eq 0 ]
}
