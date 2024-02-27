# qdtContactManagement

This package implements a Contact Management API with a contract-first approach.  

The Open API Specification ContactManagementAPI.yml is located under ./resources/api  
A Postman collection ContactManagement.postman_collection.json is provided under ./resources/tests  

##  Deployment

### Prerequisites

Ensure you have a Postgres DB to connect to.  
Create the two tables using the DDL files provided unser ./resources/database 

### Traditional deployment in an Integration Server (IS)

Connect to the IS / MSR admin console and configure the JDBC adapter with the following properties, in order to connect it to the Postgres db:
-   Connection Type: webMethods Adapter for JDBC Connection
-   Package Name: qdtContactManagement
-   Transaction Type: LOCAL_TRANSACTION
-   Driver Group: Default
-   DataSource Class: org.postgresql.ds.PGSimpleDataSource
-   Server Name: server name of your database server
-   User: user to connect to your database server
-   Password: password to connect to your database server
-   Database Name: name of the database
-   Port Number: port to connect to the database
Activate the adapter.

Place yourself in the packages folder of your IS and clone the Github repos:

```
git clone https://github.com/staillansag/qdtFramework.git
git clone https://github.com/staillansag/qdtContactManagement.git
```

Restart the IS / MSR, then connect to the admin console and check the packages are active.
  

### Microservice deployment in a Microservice Runtime (MSR)

####    Build of the MSR base image

TODO

####    Build of the microservice image

We build a new MSR image that comprises:
-   our API impleemntation package and its dependencies (our framework package)
-   the Postgres JDBC driver that's required to connect to the database

Note: 
-   This is a docker build, so you need a docker host installed
-   I am getting the packages from Github using `git clone` commands, so you need a git client installed in the build
-   There's a .dockerignore file in the repo that lists the folders and files that need to stay out of the built image (like the .git folder)


```
FROM staillansag/webmethods-microservicesruntime:10.15-qdt

# Our repo contains the qdtContactManagement package, so we copy its content to the image
ADD --chown=sagadmin . /opt/softwareag/IntegrationServer/packages/qdtContactManagement

# We also need to add another repo, which contains our framework
RUN git clone https://github.com/staillansag/qdtFramework.git
ADD --chown=sagadmin ./qdtFramework /opt/softwareag/IntegrationServer/packages/qdtFramework
RUN rm -rf ./qdtFramework

# We also download the Postgres JDBC driver and place it in the WmJDBCAdapter package folder
WORKDIR /opt/softwareag/IntegrationServer/packages/WmJDBCAdapter/code/jars
RUN curl -O https://jdbc.postgresql.org/download/postgresql-42.7.1.jar
WORKDIR /
```



