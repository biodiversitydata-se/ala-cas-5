FROM openjdk:11-jre-slim
# Add netcat for check service health
RUN apt-get update && apt-get install -y \
    netcat
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
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.war"]
