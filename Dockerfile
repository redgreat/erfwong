FROM erlang:26-alpine

MAINTAINER wangcw

WORKDIR /opt/erfwong

COPY _build/prod/rel/erfwong /opt/erfwong/

VOLUME /opt/erfwong

EXPOSE 8080

ENTRYPOINT ["/opt/erfwong/bin/erfwong"]
CMD ["foreground"]
