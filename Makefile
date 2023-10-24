run:
	docker compose up --detach mysqldb mongodb
	./mvnw clean package -T 5
	java -Dcas.standalone.configurationDirectory=/data/cas/config -Dala.password.properties=/data/cas/config/pwe.properties -jar target/cas-exec.war

# You need to change dataSource.url in userdetails-config.yml
# to use 'mysqldb' instead of '127.0.0.1' for this to work
#run-docker:
#	./gradlew clean build
#	docker compose build --no-cache
#	docker compose up --detach

release:
	@./sbdi/make-release.sh
