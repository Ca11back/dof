# Base Image
FROM xanderye/dnf-base:centos7-minimal

MAINTAINER Ca11back

# 定义默认环境变量
ENV AUTO_MYSQL_IP=true
ENV MYSQL_NAME=dnfmysql
ENV MYSQL_IP=192.168.1.2
ENV MYSQL_PORT=3306
ENV GAME_PASSWORD=uu5!^%jg
ENV AUTO_PUBLIC_IP=false
ENV PUBLIC_IP=127.0.0.1
ENV DP2=false
ENV S52=false

# 将模板添加到模版目录下[后续容器启动需要先将环境变量替换,再将文件移动到正确位置]
ADD neople /home/template/neople
ADD init /home/template/init
ADD TeaEncrypt /
# 启动脚本
ADD docker-entrypoint.sh /

RUN chmod -R 777 /tmp && mkdir /data && chmod +x /TeaEncrypt

# 切换工作目录
WORKDIR /root
CMD ["/bin/bash", "/docker-entrypoint.sh"]
