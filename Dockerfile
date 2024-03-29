FROM redgreat/erlang-ssh-buider:26.2.1-alpine AS builder

WORKDIR /erfwong

COPY . .

RUN rebar3 as prod release

FROM alpine:3.18 AS runner

MAINTAINER wangcw <rubygreat@msn.com>

WORKDIR /opt/erfwong

RUN apk add --no-cache ncurses-libs libgcc libstdc++

COPY --from=builder /erfwong/_build/prod/rel/erfwong /opt/erfwong/

VOLUME /opt/erfwong

EXPOSE 8080

CMD ["/opt/erfwong/bin/erfwong", "foreground"]
