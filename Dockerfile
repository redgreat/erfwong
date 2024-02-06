FROM erlang:26.2.1-alpine AS builder

RUN mkdir /erfwong
WORKDIR /erfwong

COPY . .

WORKDIR /erfwong
RUN rebar3 as prod release

FROM alpine AS runner

MAINTAINER wangcw

WORKDIR /opt/erfwong

COPY --from=builder /erfwong/_build/prod/rel/erfwong /opt/erfwong/

VOLUME /opt/erfwong

EXPOSE 8080

CMD ["/opt/erfwong/bin/erfwong", "foreground"]
