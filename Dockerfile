FROM livingatlases/java-11-base:latest
# Args and Envs
ARG APP_ARTIFACT=cas
ARG USER=cas
ENV APP_VERSION=6.5.6-3
ENV JAVA_OPTS="-Djava.awt.headless=true -Xmx2g -Xms512m -XX:+UseConcMarkSweepGC -Dcas.standalone.configurationDirectory=/data/cas/config -Dala.password.properties=/data/cas/config/pwe.properties -Dlog4j2.formatMsgNoLookups=true"
ENV LOGGING_CONFIG=/data/cas/config/log4j2.xml
ENV LOG_DIR=/var/log/atlas/cas
# Directories and perms
RUN mkdir -p /data/$APP_ARTIFACT $LOG_DIR && \
    groupadd -r $USER -g 1000 && useradd -r -g $USER -u 1000 -m $USER && \
    chown -R $USER:$USER /data/$APP_ARTIFACT $LOG_DIR
WORKDIR /opt/atlas/$APP_ARTIFACT
# war
ADD https://nexus.ala.org.au/service/local/repositories/releases/content/au/org/ala/${APP_ARTIFACT}/${APP_VERSION}/${APP_ARTIFACT}-${APP_VERSION}-exec.war app.war
RUN chown -R $USER:$USER /opt/atlas/$APP_ARTIFACT
USER $USER
EXPOSE 9000
# Lint with:
# docker run --rm -i hadolint/hadolint < Dockerfile
# hadolint ignore=DL3025
ENTRYPOINT dockerize -wait tcp://mysql:3306 -wait tcp://mongo:27017 -timeout 60s sh -c "java $JAVA_OPTS -jar app.war"
