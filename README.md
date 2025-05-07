# docker-wrap-image-with-db2

If you are beginning your journey with [Senzing],
please start with [Senzing Quick Start guides].

You are in the [Senzing Garage] where projects are "tinkered" on.
Although this GitHub repository may help you understand an approach to using Senzing,
it's not considered to be "production ready" and is not considered to be part of the Senzing product.
Heck, it may not even be appropriate for your application of Senzing!

## Synopsis

Wrap a Docker image with support for Db2 database.

## Overview

The contents of this repository are used to extend existing Docker images
to enable them to work with the Db2 database.
By itself, the [Dockerfile] is not useful.
Rather, it can be used in the method described below,
[Create containers], to add files to an existing Docker image.

### Contents

1. [Overview]
   1. [Preamble]
   1. [Expectations]
1. [Create containers]
1. [License]
1. [References]

## Preamble

At [Senzing], we strive to create GitHub documentation in a "[don't make me think]" style.
For the most part, instructions are copy and paste. [Icons] are used to signify additional
actions by the user. If the instructions are not clear, please let us know by opening a new
[Documentation issue] describing where we can improve. Now on with the show...

### Expectations

- **Space:** This repository and demonstration require 6 GB free disk space.
- **Time:** Budget 40 minutes to get the demonstration up-and-running, depending on CPU and network speeds.
- **Background knowledge:** This repository assumes a working knowledge of:
  - [Docker]

## Download files

1. Set these environment variable values:

   ```console
   export GIT_ACCOUNT=senzing
   export GIT_REPOSITORY=docker-wrap-image-with-db2
   export GIT_ACCOUNT_DIR=~/${GIT_ACCOUNT}.git
   export GIT_REPOSITORY_DIR="${GIT_ACCOUNT_DIR}/${GIT_REPOSITORY}"

   ```

1. Follow steps in [clone-repository] to install the Git repository.

### Downloads

#### Download v11.5.4_linuxx64_odbc_cli.tar.gz

1. Visit [Download initial Version 11.1 clients and drivers]
   1. Click on "[IBM Data Server Driver for ODBC and CLI (CLI Driver)]" link.
   1. In the "Name" column, find "IBM Data Server Driver for ODBC and CLI (Linux AMD64 and Intel EM64T)".
   1. In the "Download" column, Click the corresponding download link .
   1. Download the file (e.g. `v11.5.4_linuxx64_odbc_cli.tar.gz`) to ${GIT_REPOSITORY_DIR}/[downloads]/db2_odbc_cli.tar.gz directory.
      The Docker file is expecting a file at that location.

#### Download v11.1.4fp4a_jdbc_sqlj.tar.gz

1. Visit [DB2 JDBC Driver Versions and Downloads]
   1. In DB2 Version 11.5 > JDBC 3.0 Driver version, click on "3.72.55" link for "v11.1 M4 FP7"
   1. Click the "DSClients--jdbc_sqlj-11.1.4.7-FP007" link.
   1. Click on "v11.1.4fp4a_jdbc_sqlj.tar.gz" link to download.
   1. Download `v11.1.4fp7_jdbc_sqlj.tar.gz` to ${GIT_REPOSITORY_DIR}/[downloads] directory.

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
   [corresponding environment variable name].

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
           https://github.com/senzing-garage/docker-wrap-image-with-db2.git#main
   done

   ```

## License

View [license information] for the software container in this Docker image.
Note that this license does not permit further distribution.

This Docker image may also contain software from the
[Senzing GitHub community] under the [Apache License 2.0].

Further, as with all Docker images,
this likely also contains other software which may be under other licenses
(such as Bash, etc. from the base distribution,
along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage,
it is the image user's responsibility to ensure that any use of this image complies
with any relevant licenses for all software contained within.

## References

- [Development]
- [Errors]
- [Examples]
- [Legend]

[Apache License 2.0]: https://www.apache.org/licenses/LICENSE-2.0
[clone-repository]: https://github.com/senzing-garage/knowledge-base/blob/main/HOWTO/clone-repository.md
[corresponding environment variable name]: https://github.com/senzing-garage/knowledge-base/blob/main/lists/docker-versions-stable.sh
[Create containers]: #create-containers
[DB2 JDBC Driver Versions and Downloads]: http://www-01.ibm.com/support/docview.wss?uid=swg21363866
[Development]: docs/development.md
[Docker]: https://github.com/senzing-garage/knowledge-base/blob/main/WHATIS/docker.md
[Dockerfile]: Dockerfile
[Documentation issue]: https://github.com/senzing-garage/docker-wrap-image-with-db2/issues/new?template=documentation_request.md
[don't make me think]: https://github.com/senzing-garage/knowledge-base/blob/main/WHATIS/dont-make-me-think.md
[Download initial Version 11.1 clients and drivers]: http://www-01.ibm.com/support/docview.wss?uid=swg21385217
[downloads]: ./downloads
[Errors]: docs/errors.md
[Examples]: docs/examples.md
[Expectations]: #expectations
[IBM Data Server Driver for ODBC and CLI (CLI Driver)]: https://epwt-www.mybluemix.net/software/support/trial/cst/programwebsite.wss?siteId=849&h=null&p=null
[Icons]: https://github.com/senzing-garage/knowledge-base/blob/main/lists/legend.md
[Legend]: https://github.com/senzing-garage/knowledge-base/blob/main/lists/legend.md
[license information]: https://senzing.com/end-user-license-agreement/
[License]: #license
[Overview]: #overview
[Preamble]: #preamble
[References]: #references
[Senzing Garage]: https://github.com/senzing-garage
[Senzing GitHub community]: https://github.com/senzing-garage/
[Senzing Quick Start guides]: https://docs.senzing.com/quickstart/
[Senzing]: https://senzing.com/
