#!/usr/bin/env bash
# docker build script

# 提前拉取镜像（反复打包测试时免除每次pull）
docker pull erlang:26.2.1-alpine
docker pull alpine:3.18

# 清理镜像
docker rm erfwong
docker rmi erfwong

# 解决build时 github的 ssh gitclone
docker build -t erfwong . --build-arg SSH_KEY="$(cat ~/.ssh/id_rsa)"

# 运行
docker run -itd --name erfwong -p 8080:8080 erfwong

# 影响配置文件，修改db.conf
# docker run -itd --name erfwong -p 8080:8080 erfwong -v . /opt/erfwong/release/0.1.0
