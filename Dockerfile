FROM openjdk:11-jre-slim
ENV APP_ARTIFACT=cas
ENV APP_VERSION=6.5.6-3
WORKDIR /opt
ADD https://nexus.ala.org.au/service/local/repositories/releases/content/au/org/ala/${APP_ARTIFACT}/${APP_VERSION}/${APP_ARTIFACT}-${APP_VERSION}-exec.war app.war
RUN mkdir /data
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.war"]
