# docker-wrap-image-with-db2

## Synopsis

Wrap a Docker image with support for Db2 database.

## Overview

The contents of this repository are used to extend existing Docker images
to enable them to work with the Db2 database.
By itself, the
[Dockerfile](Dockerfile)
is not useful.
Rather, it can be used in the method described below,
[Create containers](#create-containers),
to add files to an existing Docker image.

### Contents

1. [Overview](#overview)
    1. [Preamble](#preamble)
    1. [Expectations](#expectations)
1. [Create containers](#create-containers)
1. [License](#license)
1. [References](#references)

### Preamble

At [Senzing](http://senzing.com),
we strive to create GitHub documentation in a
"[don't make me think](https://github.com/Senzing/knowledge-base/blob/main/WHATIS/dont-make-me-think.md)" style.
For the most part, instructions are copy and paste.
[Icons](https://github.com/Senzing/knowledge-base/blob/main/lists/legend.md)
are used to signify additional actions by the user.
If the instructions are not clear, please let us know by opening a new
[Documentation issue](https://github.com/Senzing/docker-wrap-image-with-db2/issues/new?template=documentation_request.md)
describing where we can improve.   Now on with the show...

### Expectations

- **Space:** This repository and demonstration require 6 GB free disk space.
- **Time:** Budget 40 minutes to get the demonstration up-and-running, depending on CPU and network speeds.
- **Background knowledge:** This repository assumes a working knowledge of:
  - [Docker](https://github.com/Senzing/knowledge-base/blob/main/WHATIS/docker.md)

## Create containers

The following steps show how to wrap existing containers with Db2 prerequisites.

1. Get versions of Docker images.
   Example:

    ```console
    curl -X GET \
        --output /tmp/docker-versions-stable.sh \
        https://raw.githubusercontent.com/Senzing/knowledge-base/main/lists/docker-versions-stable.sh
    source /tmp/docker-versions-stable.sh

    ```

1. :pencil2: List the Docker images and their
   [corresponding environment variable name](https://github.com/Senzing/knowledge-base/blob/main/lists/docker-versions-stable.sh).

   Format: `repository`;`tag`;`user` where `user` defaults to `1001`.

   Example:

    ```console
    export BASE_IMAGES=( \
      "senzing/entity-search-web-app-console;${SENZING_DOCKER_IMAGE_VERSION_ENTITY_SEARCH_WEB_APP_CONSOLE:-latest}" \
      "senzing/redoer;${SENZING_DOCKER_IMAGE_VERSION_REDOER:-latest};1001" \
      "senzing/senzing-api-server;${SENZING_DOCKER_IMAGE_VERSION_SENZING_API_SERVER:-latest}" \
      "senzing/senzing-console;${SENZING_DOCKER_IMAGE_VERSION_SENZING_CONSOLE:-latest}" \
      "senzing/senzing-poc-server;${SENZING_DOCKER_IMAGE_VERSION_SENZING_POC_SERVER:-latest}" \
      "senzing/senzing-tools;${SENZING_DOCKER_IMAGE_VERSION_SENZING_TOOLS:-latest}" \
      "senzing/senzingapi-runtime;${SENZING_DOCKER_IMAGE_VERSION_SENZINGAPI_RUNTIME:-latest}" \
      "senzing/senzingapi-tools;${SENZING_DOCKER_IMAGE_VERSION_SENZINGAPI_TOOLS:-latest}" \
      "senzing/sshd;${SENZING_DOCKER_IMAGE_VERSION_SSHD:-latest};0" \
      "senzing/stream-loader;${SENZING_DOCKER_IMAGE_VERSION_STREAM_LOADER:-latest}" \
      "senzing/xterm;${SENZING_DOCKER_IMAGE_VERSION_XTERM:-latest}" \
    )

    ```

1. Build each of the Db2 compatible docker images in the list.
   Example:

    ```console
    for BASE_IMAGE in ${BASE_IMAGES[@]}; \
    do \
        IFS=";" read -r -a BASE_IMAGE_DATA <<< "${BASE_IMAGE}"
        BASE_IMAGE_NAME="${BASE_IMAGE_DATA[0]}"
        BASE_IMAGE_VERSION="${BASE_IMAGE_DATA[1]}"
        BASE_IMAGE_USER="${BASE_IMAGE_DATA[2]}"
        docker pull ${BASE_IMAGE_NAME}:${BASE_IMAGE_VERSION}
        docker build \
            --build-arg BASE_IMAGE=${BASE_IMAGE_NAME}:${BASE_IMAGE_VERSION} \
            --build-arg USER=${BASE_IMAGE_USER:-1001} \
            --tag ${BASE_IMAGE_NAME}-db2:${BASE_IMAGE_VERSION} \
            https://github.com/Senzing/docker-wrap-image-with-db2.git#main
    done

    ```

## License

View
[license information](https://senzing.com/end-user-license-agreement/)
for the software container in this Docker image.
Note that this license does not permit further distribution.

This Docker image may also contain software from the
[Senzing GitHub community](https://github.com/Senzing/)
under the
[Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0).

Further, as with all Docker images,
this likely also contains other software which may be under other licenses
(such as Bash, etc. from the base distribution,
along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage,
it is the image user's responsibility to ensure that any use of this image complies
with any relevant licenses for all software contained within.

## References

- [Development](docs/development.md)
- [Errors](docs/errors.md)
- [Examples](docs/examples.md)
- [Legend](https://github.com/Senzing/knowledge-base/blob/main/lists/legend.md)
