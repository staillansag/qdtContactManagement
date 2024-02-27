# This references the custom base image I have built - this image is available at dockerhub with public access
FROM staillansag/webmethods-microservicesruntime:10.15.0.9-qdt

# wpm needs a Github token to fetch the qdtFramework, we receive it as a build argument and store it in an environment variable
ARG GIT_TOKEN
ENV GIT_TOKEN=$GIT_TOKEN

# Our repo contains the qdtContactManagement package, so we copy its content to the image
ADD --chown=sagadmin . /opt/softwareag/IntegrationServer/packages/qdtContactManagement

# We also need to add another repo, which contains our framework. We use the webMethods package manager (wpm) to do so
RUN /opt/softwareag/wpm/bin/wpm.sh install -u staillansag -p $GIT_TOKEN -r https://github.com/staillansag -d /opt/softwareag/IntegrationServer qdtFramework
