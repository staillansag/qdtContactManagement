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