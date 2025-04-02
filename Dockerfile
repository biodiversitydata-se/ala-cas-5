FROM eclipse-temurin:11-jre

ENV TZ=Europe/Stockholm

RUN mkdir -p /app /data/cas/config

COPY target/cas-exec.war /app/cas-exec.war

ENV DOCKERIZE_VERSION=v0.9.3

RUN apt-get update \
    && apt-get install -y wget \
    && wget -O - https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz | tar xzf - -C /usr/local/bin \
    && apt-get autoremove -yqq --purge wget && rm -rf /var/lib/apt/lists/*

EXPOSE 9000

CMD ["sh", "-c", "java -Dcas.standalone.configurationDirectory=/data/cas/config -Dala.password.properties=/data/cas/config/pwe.properties -jar /app/cas-exec.war"]
