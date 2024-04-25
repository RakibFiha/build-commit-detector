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

@test "./main.sh 'skip-ci Initial Commit message' 'skip' 'Deploy'" {
  run ./main.sh 'skip-ci Initial Commit message' 'skip' 'Deploy'
  assert_output --partial '"deploy": "true"' ## needs to be exact match 'skip-' should not be a match, use gnu grep implementation and not BSD grep implementation

  [ "$status" -eq 0 ]
}

@test "./main.sh 'skip-ci Initial Commit message' 'skip skip-c' 'Build'" {
  run ./main.sh 'skip-ci Initial Commit message' 'skip skip-c' 'Build'
  assert_output --partial '"build": "true"' ## needs to be exact match 'skip-' should not be a match, use gnu grep implementation and not BSD grep implementation

  [ "$status" -eq 0 ]
}

@test "./main.sh 'skip-ci Initial Commit message' 'skip-ci' 'DEPLOY'" {
  run ./main.sh 'skip-ci Initial Commit message' 'skip-ci' 'DEPLOY'
  assert_output --partial '"deploy": "false"'

  [ "$status" -eq 0 ]
}

@test "./main.sh 'skip-ci Initial Commit message' 'skip-ci' 'BUILD' #High strictness" {
  run bash -c "BUILD_COMMIT_DETECTOR_STRICTNESS=high ./main.sh 'skip-ci Initial Commit message' 'skip-ci' 'BUILD'"
  assert_output --partial '"build": "false"'

  [ "$status" -eq 1 ]
}

@test "./main.sh 'skip-ci Initial Commit message' 'skip skip-ci' 'BUILD'" {
  run ./main.sh 'skip-ci Initial Commit message' 'foo skip-ci' 'BUILD'
  assert_output --partial '"build": "false"'

  [ "$status" -eq 0 ]
}

@test "./main.sh 'スキップシーアイ Initial Commit message' 'foobar スキップシーアイ foo bar' 'DEPLOY' $High strictness" {
  run bash -c "BUILD_COMMIT_DETECTOR_STRICTNESS=high ./main.sh 'skip-ci Initial Commit message' 'foo skip-ci' 'DEPLOY'"
  assert_output --partial '"deploy": "false"'

  [ "$status" -eq 1 ]
}

@test "./main.sh '--' 'skip-ci' 'DEPLOY'" {
  run ./main.sh '--' 'skip-ci' 'DEPLOY'
  assert_output --partial '"deploy": "true"'

  [ "$status" -eq 0 ]

  run ./main.sh ' ' 'skip-ci' 'DEPLOY'
  assert_output --partial '"deploy": "true"'

  [ "$status" -eq 0 ]
}
