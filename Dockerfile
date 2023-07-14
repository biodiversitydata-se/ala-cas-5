FROM openjdk:11-jre-slim
ENV DOCKERIZE_VERSION v0.7.0
RUN apt-get update \
    && apt-get install -y wget \
    && wget -O - https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz | tar xzf - -C /usr/local/bin \
    && apt-get autoremove -yqq --purge wget && rm -rf /var/lib/apt/lists/*
ARG APP_ARTIFACT=cas
ARG APP_VERSION=6.5.6-3
ENV JAVA_OPTS="-Djava.awt.headless=true -Xmx2g -Xms512m -XX:+UseConcMarkSweepGC -Dcas.standalone.configurationDirectory=/data/cas/config -Dala.password.properties=/data/cas/config/pwe.properties -Dlog4j2.formatMsgNoLookups=true"
ENV LOGGING_CONFIG=/data/cas/config/log4j2.xml
ENV LOG_DIR=/var/log/atlas/cas
WORKDIR /opt
ADD https://nexus.ala.org.au/service/local/repositories/releases/content/au/org/ala/${APP_ARTIFACT}/${APP_VERSION}/${APP_ARTIFACT}-${APP_VERSION}-exec.war app.war
RUN mkdir /data
RUN mkdir -p /var/log/atlas/cas
EXPOSE 9000
ENTRYPOINT dockerize -wait tcp://mysql:3306 -wait tcp://mongo:27017 -timeout 60s sh -c "java $JAVA_OPTS -jar app.war"
