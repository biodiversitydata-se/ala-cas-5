FROM openjdk:8-alpine

ENV APP_NAME="cas"

ENV BUILD_DEPS="gettext" \
    RUNTIME_DEPS="libintl" \
    LOG_DIR=/var/log/atlas/${APP_NAME}

RUN mkdir -p /app \
    /data/${APP_NAME}/config \
    /var/log/atlas/${APP_NAME}

COPY ${APP_NAME}*-exec.war /app/${APP_NAME}-exec.war
COPY config/application.yml /tmp/application.yml
COPY config/log4j2.xml /data/${APP_NAME}/config/log4j2.xml
COPY config/pwe.properties /tmp/pwe.properties

RUN \
    apk add --update $RUNTIME_DEPS && \
    apk add --virtual build_deps $BUILD_DEPS &&  \
    cp /usr/bin/envsubst /usr/local/bin/envsubst && \
    apk del $BUILD_DEPS && \
    apk add --update tini

EXPOSE 9000
ENTRYPOINT ["tini", "--"]
CMD ["sh", "-c", "envsubst < /tmp/pwe.properties > /data/${APP_NAME}/config/pwe.properties && envsubst < /tmp/application.yml > /data/${APP_NAME}/config/application.yml && java -Djava.util.logging.config.file=/data/${APP_NAME}/config/log4j2.xml -Dcas.standalone.configurationDirectory=/data/${APP_NAME}/config -Dala.password.properties=/data/${APP_NAME}/config/pwe.properties -jar /app/cas-exec.war"]
