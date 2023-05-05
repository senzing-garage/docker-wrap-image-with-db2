# Development

## Install

### Install prerequisites

:thinking: The following tasks need to be complete before proceeding.
These are "one-time tasks" which may already have been completed.

1. The following software programs need to be installed:
    1. [git](https://github.com/Senzing/knowledge-base/blob/main/WHATIS/git.md)
    1. [make](https://github.com/Senzing/knowledge-base/blob/main/WHATIS/make.md)
    1. [docker](https://github.com/Senzing/knowledge-base/blob/main/WHATIS/docker.md)

### Install Git repository

1. Identify git repository.

    ```console
    export GIT_ACCOUNT=senzing
    export GIT_REPOSITORY=docker-wrap-image-with-db2
    export GIT_ACCOUNT_DIR=~/${GIT_ACCOUNT}.git
    export GIT_REPOSITORY_DIR="${GIT_ACCOUNT_DIR}/${GIT_REPOSITORY}"

    ```

1. Using the environment variables values just set, follow steps in
   [clone-repository](https://github.com/Senzing/knowledge-base/blob/main/HOWTO/clone-repository.md) to install the Git repository.
1. For more information on environment variables,
   see [Environment Variables](https://github.com/Senzing/knowledge-base/blob/main/lists/environment-variables.md).

## Build

### Build Docker image

1. **Option #1:** Using `docker` command and GitHub.

    ```console
    sudo docker build \
      --tag senzing/stream-loader \
      https://github.com/senzing/docker-wrap-image-with-db2.git#main
    ```

1. **Option #2:** Using `docker` command and local repository.

    ```console
    cd ${GIT_REPOSITORY_DIR}
    sudo docker build --tag senzing/docker-wrap-image-with-db2 .
    ```

1. **Option #3:** Using `make` command.

    ```console
    cd ${GIT_REPOSITORY_DIR}
    sudo --preserve-env make docker-build
    ```

## Test

## Package
