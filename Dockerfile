ARG BASE_IMAGE=debian:11.6-slim@sha256:8eaee63a5ea83744e62d5bf88e7d472d7f19b5feda3bfc6a2304cc074f269269
FROM ${BASE_IMAGE}

ENV REFRESHED_AT=2023-03-16

LABEL Name="senzing/wrap-with-db2" \
      Maintainer="support@senzing.com" \
      Version="1.0.0"

USER root

# Work-around for apt-get update error.

RUN chmod 1777 /tmp

# Install packages via apt-get.

RUN apt-get update
RUN apt-get -y install \
      gnupg \
      wget

# Db2 support.

ENV ACCEPT_EULA=Y

RUN wget -qO - https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg \
 && wget -qO - https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list \
 && apt-get update \
 && apt-get -y install \
      msodbcsql17 \
 && rm -rf /var/lib/apt/lists/*

RUN rm /opt/senzing/g2/sdk/python/senzing_governor.py || true

# Set/Reset the USER.

ARG USER=1005
USER ${USER}
