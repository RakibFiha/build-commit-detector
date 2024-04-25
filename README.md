### README


[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![main](https://github.com/RakibFiha/build-commit-detector/actions/workflows/run_tests.yml/badge.svg)](https://github.com/RakibFiha/build-commit-detector/actions/workflows/run_tests.yml)

#### build-commit-detector

- Detect if build is necessary by commit message

#### Inputs

|Parameters     |Required                                                      | Description                                                                             |
|---------------|--------------------------------------------------------------| ----------------------------------------------------------------------------------------|
| `commit_msg`  |No <br/> Default: `'--'` or `' '`                             | Using default will evaluate the output of this command: `git log --format=%B -n 1 HEAD` |
| `keywords`    |No <br/> Default: `skip-ci skip-build`                        | Space seperated string of keywords. Will look for exact match.                          |
| `strictness`  |No <br/> Default: `low` <br/> Can also be `moderate` or `high`| Low strictness, will not exit but will give output `build_necessary`                    |
| `detect_type` |No <br/> Default: `build` <br/> Can also be `deploy`          | Low strictness, will not exit but will give output `build_necessary`                    |


#### Outputs

| Variable         | Value                               |
|------------------|-------------------------------------|
|`build_necessary` | json: `{detect_type: boolean}`      |


#### Tests

- See tests for scenarios


#### Example

- See workflows for example
