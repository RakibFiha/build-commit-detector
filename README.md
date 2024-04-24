### README

#### build-commit-detector

- Detect if build is necessary by commit message

#### Inputs

|Parameters    |Required                                                      | Description                                                                             |
|--------------|--------------------------------------------------------------| ----------------------------------------------------------------------------------------|
| `commit_msg` |No <br/> Default: `'--'` or `' '`                             | Using default will evaluate the output of this command: `git log --format=%B -n 1 HEAD` |
| `keywords`   |No <br/> Default: `skip-ci skip-build`                        | Space seperated string of keywords. Will look for exact match.                          |
| `strictness` |No <br/> Default: `low` <br/> Can also be `moderate` or `high`| Low strictness, will not exit but will give output `build_necessary=false`              |


#### Outputs

| Variable         | Value            |
|------------------|------------------|
|`build_necessary` | `Boolean`        |


#### Tests

- See tests for scenarios


#### Example

- See workflows for example
