# erfwong

restful api书写示例，[erf](https://github.com/nomasystems/erf.git) 框架(依赖[elli](https://github.com/elli-lib/elli.git)).


修改配置文件

```shell
数据库连接设置 ：config目录下 测试-db.config 正式-db.sample.config
API_KEY设置： config目录下 测试-sys.config 正式-prod_sys.config 修改 api_key
服务端口： config目录下 测试-sys.config 正式-prod_sys.config 修改 api_port
```

运行

```shell
rebar3 compile
rebar3 shell
```

发布
```shell
rebr3 as prod tar
rebar3 as prod release
./_build/prod/rel/erfwong/bin/erfwong foreground
```

docker

```shell
docker run -itd --name erfwong -p 8080:8080 redgreat/erfwong
```
