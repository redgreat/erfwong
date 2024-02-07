FROM erlang:26.2.1-alpine AS builder

RUN mkdir /erfwong
WORKDIR /erfwong

COPY . .

WORKDIR /erfwong

RUN apk add --no-cache git openssh-client

COPY --from=builder /root/.ssh /root/.ssh

RUN chmod -R 0600 /root/.ssh/* && ssh-keyscan github.com >> /root/.ssh/known_hosts

RUN rebar3 as prod release

FROM alpine:3.18 AS runner

MAINTAINER wangcw <rubygreat@msn.com>

WORKDIR /opt/erfwong

RUN apk add --no-cache ncurses-libs libgcc libstdc++

COPY --from=builder /erfwong/_build/prod/rel/erfwong /opt/erfwong/

VOLUME /opt/erfwong

EXPOSE 8080

CMD ["/opt/erfwong/bin/erfwong", "foreground"]
