ARG BASE_IMAGE=debian:11.6-slim@sha256:8eaee63a5ea83744e62d5bf88e7d472d7f19b5feda3bfc6a2304cc074f269269
ARG BUILDER_IMAGE=debian:11.6-slim@sha256:8eaee63a5ea83744e62d5bf88e7d472d7f19b5feda3bfc6a2304cc074f269269

# -----------------------------------------------------------------------------
# Stage: db2_builder
# -----------------------------------------------------------------------------

FROM ${BUILDER_IMAGE} as db2_builder

ENV REFRESHED_AT=2023-03-17

LABEL Name="senzing/wrap-with-db2-builder" \
  Maintainer="support@senzing.com" \
  Version="1.0.0"

# Install packages via apt.

RUN apt-get update \
  && apt-get -y install \
  unzip

# Copy the DB2 ODBC client code.
# The tar.gz files must be independently downloaded before the docker build.

COPY ./downloads/v11.5.4_linuxx64_odbc_cli.tar.gz /opt/IBM/db2
COPY ./downloads/v11.1.4fp7_jdbc_sqlj.tar.gz /download/db2-jdbc-sqlj

# Extract ZIP file.

RUN unzip -d /download/extracted-jdbc /download/db2-jdbc-sqlj/jdbc_sqlj/db2_db2driver_for_jdbc_sqlj.zip

# -----------------------------------------------------------------------------
# Final stage
# -----------------------------------------------------------------------------

FROM ${BASE_IMAGE}

ENV REFRESHED_AT=2023-03-17

LABEL Name="senzing/wrap-with-db2" \
  Maintainer="support@senzing.com" \
  Version="1.0.0"

USER root

# Db2 support.

COPY --from=db2_builder [ \
  "/opt/IBM/db2/odbc_cli/clidriver/adm/db2trc", \
  "/opt/IBM/db2/odbc_cli/clidriver/adm/" \
  ]

COPY --from=db2_builder [ \
  "/opt/IBM/db2/odbc_cli/clidriver/bin/db2dsdcfgfill", \
  "/opt/IBM/db2/odbc_cli/clidriver/bin/db2ldcfg", \
  "/opt/IBM/db2/odbc_cli/clidriver/bin/db2lddrg", \
  "/opt/IBM/db2/odbc_cli/clidriver/bin/db2level", \
  "/opt/IBM/db2/odbc_cli/clidriver/bin/" \
  ]

COPY --from=db2_builder [ \
  "/opt/IBM/db2/odbc_cli/clidriver/cfg/db2cli.ini.sample", \
  "/opt/IBM/db2/odbc_cli/clidriver/cfg/db2dsdriver.cfg.sample", \
  "/opt/IBM/db2/odbc_cli/clidriver/cfg/db2dsdriver.xsd", \
  "/opt/IBM/db2/odbc_cli/clidriver/cfg/" \
  ]

COPY --from=db2_builder [ \
  "/opt/IBM/db2/odbc_cli/clidriver/conv/alt/08501252.cnv", \
  "/opt/IBM/db2/odbc_cli/clidriver/conv/alt/12520850.cnv", \
  "/opt/IBM/db2/odbc_cli/clidriver/conv/alt/IBM00850.ucs", \
  "/opt/IBM/db2/odbc_cli/clidriver/conv/alt/IBM01252.ucs", \
  "/opt/IBM/db2/odbc_cli/clidriver/conv/alt/" \
  ]

COPY --from=db2_builder [ \
  "/opt/IBM/db2/odbc_cli/clidriver/lib/libdb2.so.1", \
  "/opt/IBM/db2/odbc_cli/clidriver/lib/libdb2o.so.1", \
  "/opt/IBM/db2/odbc_cli/clidriver/lib/" \
  ]

COPY --from=db2_builder [ \
  "/opt/IBM/db2/odbc_cli/clidriver/lib/icc/libgsk8cms_64.so", \
  "/opt/IBM/db2/odbc_cli/clidriver/lib/icc/libgsk8iccs_64.so", \
  "/opt/IBM/db2/odbc_cli/clidriver/lib/icc/libgsk8km_64.so", \
  "/opt/IBM/db2/odbc_cli/clidriver/lib/icc/libgsk8ssl_64.so", \
  "/opt/IBM/db2/odbc_cli/clidriver/lib/icc/libgsk8sys_64.so", \
  "/opt/IBM/db2/odbc_cli/clidriver/lib/icc/" \
  ]

COPY --from=db2_builder [ \
  "/opt/IBM/db2/odbc_cli/clidriver/lib/icc/C/icc/icclib/ICCSIG.txt", \
  "/opt/IBM/db2/odbc_cli/clidriver/lib/icc/C/icc/icclib/libicclib084.so", \
  "/opt/IBM/db2/odbc_cli/clidriver/lib/icc/C/icc/icclib/" \
  ]

COPY --from=db2_builder [ \
  "/opt/IBM/db2/odbc_cli/clidriver/msg/en_US.iso88591/db2admh.mo", \
  "/opt/IBM/db2/odbc_cli/clidriver/msg/en_US.iso88591/db2adm.mo", \
  "/opt/IBM/db2/odbc_cli/clidriver/msg/en_US.iso88591/db2clia1.lst", \
  "/opt/IBM/db2/odbc_cli/clidriver/msg/en_US.iso88591/db2clias.lst", \
  "/opt/IBM/db2/odbc_cli/clidriver/msg/en_US.iso88591/db2clih.mo", \
  "/opt/IBM/db2/odbc_cli/clidriver/msg/en_US.iso88591/db2cli.mo", \
  "/opt/IBM/db2/odbc_cli/clidriver/msg/en_US.iso88591/db2clit.mo", \
  "/opt/IBM/db2/odbc_cli/clidriver/msg/en_US.iso88591/db2clp.mo", \
  "/opt/IBM/db2/odbc_cli/clidriver/msg/en_US.iso88591/db2diag.mo", \
  "/opt/IBM/db2/odbc_cli/clidriver/msg/en_US.iso88591/db2sqlh.mo", \
  "/opt/IBM/db2/odbc_cli/clidriver/msg/en_US.iso88591/db2sql.mo", \
  "/opt/IBM/db2/odbc_cli/clidriver/msg/en_US.iso88591/" \
  ]

COPY --from=db2_builder [ \
  "/download/extracted-jdbc/db2jcc.jar", \
  "/download/extracted-jdbc/db2jcc4.jar", \
  "/download/extracted-jdbc/sqlj.zip", \
  "/download/extracted-jdbc/sqlj4.zip", \
  "/opt/IBM/db2/jdbc/" \
  ]

# Create files and links.

WORKDIR /opt/IBM/db2/odbc_cli/clidriver/lib
RUN ln -s libdb2.so.1  libdb2.so \
  && ln -s libdb2o.so.1 libdb2o.so

# Remove unnecessary files.

RUN rm /opt/senzing/g2/sdk/python/senzing_governor.py || true

HEALTHCHECK CMD ["/app/healthcheck.sh"]

# Set/Reset the USER.

ARG USER=1005
USER ${USER}
