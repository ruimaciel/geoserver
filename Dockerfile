FROM alpine:3.10 AS build-stage

WORKDIR /build

ARG GEOSERVER_VERSION=2.20.0

ARG GEOSERVER_WAR_ZIP_NAME=geoserver-${GEOSERVER_VERSION}-war.zip

RUN wget https://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/${GEOSERVER_WAR_ZIP_NAME}
RUN unzip ${GEOSERVER_WAR_ZIP_NAME}


FROM tomcat:8.5.72

ENV GEOSERVER_VERSION=${GEOSERVER_VERSION}
ENV DOCKER_IMAGE_VERSION=${GEOSERVER_VERSION}

LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name="GeoServer"
LABEL org.label-schema.url="http://geoserver.org/"
LABEL org.label-schema.vcs-url="https://github.com/ruimaciel/geoserver"
LABEL org.label-schema.version="${DOCKER_IMAGE_VERSION}"
LABEL org.label-schema.docker.cmd="docker run -d -p 8080:8080 geoserver:${DOCKER_IMAGE_VERSION}"

WORKDIR /usr/local/tomcat
COPY --from=build-stage /build/geoserver.war ${CATALINA_HOME}/webapps

EXPOSE 8080