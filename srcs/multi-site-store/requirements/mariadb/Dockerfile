FROM alpine:latest AS base

RUN apk update &&\
	apk upgrade &&\
	apk add --no-cache\
	mariadb
        
COPY install.sh /tmp/install.sh

ENTRYPOINT [ "sh", "/tmp/install.sh" ]

FROM base AS dev

RUN apk add --no-cache mariadb-client

ENTRYPOINT [ "sh", "/tmp/install.sh" ]
