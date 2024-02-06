ARG SSH_KEY

FROM erlang:26.2.1-alpine AS builder

RUN mkdir /erfwong
WORKDIR /erfwong

COPY . .

WORKDIR /erfwong

RUN apk add --no-cache git openssh-client

# 创建 SSH 目录并添加私钥
RUN mkdir -p /root/.ssh \
    && echo "SSH_KEY" > /root/.ssh/id_rsa \
    && chmod 600 /root/.ssh/id_rsa

# 添加 GitHub 的已知主机
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

RUN rebar3 as prod release

FROM alpine:3.18 AS runner

MAINTAINER wangcw <rubygreat@msn.com>

WORKDIR /opt/erfwong

RUN apk add --no-cache ncurses-libs libgcc libstdc++

COPY --from=builder /erfwong/_build/prod/rel/erfwong /opt/erfwong/

VOLUME /opt/erfwong

EXPOSE 8080

CMD ["/opt/erfwong/bin/erfwong", "foreground"]
