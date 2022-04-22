# dof服务端

基于[XanderYe](https://github.com/XanderYe/dnf)的dnf-server,不含mysql:
1. 新增环境变量S52: 是否运行52频道,默认不运行
2. 删除内置网关
3. 暴露root文件夹,包含run和stop便于自定义网关/运行脚本
4. 不内置pvf,publickey.pem,如没有对应文件运行会直接停止
5. 不内置dp2,需要在data文件夹新建dp2文件夹并放入所有dp2组件

## 参数

详见[docker-compose.yml](dof-server/docker-compose.yml)

## 拉取

```
docker pull ca11back/dof-server:centos7
```

## 简单启动
```
docker run -d \
-e TZ=Asia/Shanghai \
-e AUTO_MYSQL_IP=true \
-e MYSQL_NAME=dnfmysql \
-e MYSQL_IP=192.168.1.2 \
-e MYSQL_PORT=3306 \
-e GAME_PASSWORD=uu5\!^%jg \
-e AUTO_PUBLIC_IP=false \
-e PUBLIC_IP=192.168.1.2 \
-e DP2=false \
-e S52=false \
-v /dnf/dnfserver/log:/home/neople/game/log \
-v /dnf/dnfserver/data:/data \
-p 20303:20303/tcp -p 20303:20303/udp \
-p 20403:20403/tcp -p 20403:20403/udp \
-p 40403:40403/tcp -p 40403:40403/udp \
-p 7000:7000/tcp -p 7000:7000/udp \
-p 7001:7001/tcp -p 7001:7001/udp \
-p 7200:7200/tcp -p 7200:7200/udp \
-p 10011:10011/tcp -p 31100:31100/tcp \
-p 30303:30303/tcp -p 30303:30303/udp \
-p 30403:30403/tcp -p 30403:30403/udp \
-p 10052:10052/tcp \
-p 20011:20011/tcp \
-p 20203:20203/tcp \
-p 20203:20203/udp \
-p 30703:30703/udp \
-p 11011:11011/udp \
-p 2311-2313:2311-2313/udp \
-p 30503:30503/udp \
-p 11052:11052/udp \
--cpus=1 --memory=1g --memory-swap=-1 --shm-size=8g \
--name dofserver \
--network=dnf \
ca11back/dof-server:centos7
```
