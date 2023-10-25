run:
	docker compose up --detach mysqldb mongodb
	./mvnw clean package -T 5
	java -Dcas.standalone.configurationDirectory=/data/cas/config -Dala.password.properties=/data/cas/config/pwe.properties -jar target/cas-exec.war

# You need to change the mysql and mongo connections in sbdi/data/config/application.yml for this to work
# Use 'mysqldb' and 'mongodb' instead of 'localhost'
run-docker:
	./mvnw clean package -T 5
	docker compose build --no-cache
	docker compose up --detach

release:
	@./sbdi/make-release.sh
