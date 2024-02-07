FROM erlang:26.2.1-alpine AS builder

ARG SSH_KEY
ARG PUB_KEY

RUN mkdir /erfwong
WORKDIR /erfwong

COPY . .

WORKDIR /erfwong

RUN apk add --no-cache git openssh-client

RUN mkdir -p /root/.ssh \
    && echo $SSH_KEY > /root/.ssh/id_rsa \
    && echo $PUB_KEY > /root/.ssh/id_rsa.pub \
    && chmod 600 /root/.ssh/id_rsa

RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

RUN ssh -T git@github.com

RUN rebar3 as prod release

FROM alpine:3.18 AS runner

MAINTAINER wangcw <rubygreat@msn.com>

WORKDIR /opt/erfwong

RUN apk add --no-cache ncurses-libs libgcc libstdc++

COPY --from=builder /erfwong/_build/prod/rel/erfwong /opt/erfwong/

VOLUME /opt/erfwong

EXPOSE 8080

CMD ["/opt/erfwong/bin/erfwong", "foreground"]
