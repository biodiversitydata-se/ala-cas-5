# CAS

## Setup

### Config and data directory
Create data directory at `/data/cas` and populate as below (it is easiest to symlink the config files to the ones in this repo):
```
mats@xps-13:/data/cas$ tree
.
├── config
    ├── application.yml -> /home/mats/src/biodiversitydata-se/ala-cas-5/sbdi/data/config/application.yml
    ├── cas.properties -> /home/mats/src/biodiversitydata-se/ala-cas-5/etc/cas/config/cas.properties
    ├── log4j2.xml -> /home/mats/src/biodiversitydata-se/ala-cas-5/etc/cas/config/log4j2.xml
    └── pwe.properties -> /home/mats/src/biodiversitydata-se/ala-cas-5/sbdi/data/config/pwe.properties
```

### Databases
Empty databases (MySql and MongoDB) will be created on startup.

## Usage
Run locally:
```
make run
```

Build and run in Docker. This requires a small change in the config file to work. See comment in Makefile.
```
make run-docker
```

Make a release. This will create a new tag and push it. A new Docker container will be built on Github.
```
mats@xps-13:~/src/biodiversitydata-se/ala-cas-5 (master *)$ make release

Current version: 1.0.1. Enter the new version (or press Enter for 1.0.2): 
Updating to version 1.0.2
Tag 1.0.2 created and pushed.
```
