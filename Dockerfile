FROM erlang:26.2.1-alpine AS builder

ARG SSH_KEY

RUN mkdir /erfwong
WORKDIR /erfwong

COPY . .

WORKDIR /erfwong

RUN apk add --no-cache git openssh-client

RUN mkdir -p /root/.ssh \
    && echo $SSH_KEY > /root/.ssh/id_rsa \
    && chmod 600 /root/.ssh/id_rsa

RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

RUN cat /root/.ssh/id_rsa

RUN rebar3 as prod release

RUN ls /erfwong/_build/prod/rel/erfwong

FROM alpine:3.18 AS runner

MAINTAINER wangcw <rubygreat@msn.com>

WORKDIR /opt/erfwong

RUN apk add --no-cache ncurses-libs libgcc libstdc++

COPY --from=builder /erfwong/_build/prod/rel/erfwong /opt/erfwong/

VOLUME /opt/erfwong

EXPOSE 8080

CMD ["/opt/erfwong/bin/erfwong", "foreground"]
