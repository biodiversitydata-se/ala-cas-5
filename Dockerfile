FROM openjdk:11-jre-slim
# Prerequisites
ENV DOCKERIZE_VERSION v0.7.0
# Lint with:
# docker run --rm -i hadolint/hadolint < Dockerfile
# https://github.com/hadolint/hadolint/wiki/DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y wget --no-install-recommends \
    && wget --progress=dot:giga -O - https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz | tar xzf - -C /usr/local/bin \
    && apt-get autoremove -yqq --purge wget && rm -rf /var/lib/apt/lists/*
# Args and Envs
ARG APP_ARTIFACT=cas
ENV CAS_APP_VERSION=6.5.6-3
ENV JAVA_OPTS="-Djava.awt.headless=true -Xmx2g -Xms512m -XX:+UseConcMarkSweepGC -Dcas.standalone.configurationDirectory=/data/cas/config -Dala.password.properties=/data/cas/config/pwe.properties -Dlog4j2.formatMsgNoLookups=true"
ENV LOGGING_CONFIG=/data/cas/config/log4j2.xml
ENV LOG_DIR=/var/log/atlas/cas
# Directories and perms
RUN mkdir -p /data/cas /var/log/atlas/cas && \
    groupadd -r cas && useradd -r -g cas -u 1000 -m cas && \
    chown -R cas:cas /data/cas /var/log/atlas/cas
USER cas
WORKDIR /opt
# war
ADD https://nexus.ala.org.au/service/local/repositories/releases/content/au/org/ala/${APP_ARTIFACT}/${CAS_APP_VERSION}/${APP_ARTIFACT}-${CAS_APP_VERSION}-exec.war app.war
EXPOSE 9000
# hadolint ignore=DL3025
ENTRYPOINT dockerize -wait tcp://mysql:3306 -wait tcp://mongo:27017 -timeout 60s sh -c "java $JAVA_OPTS -jar app.war"
