FROM alpine:3.5
MAINTAINER Lkhagva Ochirkhuyag <ochkol@reallyenglish.com>

RUN apk update && \
    apk add bash

ADD ["https://github.com/ochko/lookup-srv/releases/download/v1.0.0/lookup-srv-linux-amd64", "/usr/local/bin/lookup-srv"]
RUN chmod +x /usr/local/bin/lookup-srv

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
