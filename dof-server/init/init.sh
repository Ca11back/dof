#! /bin/bash

# 赋予权限
chmod 777 -R /tmp
cd /home/template/init/

# 判断df_game_r文件是否初始化过
if [ ! -f "/data/df_game_r" ]; then
  # 拷贝版本文件到持久化目录
  cp /home/template/init/df_game_r /data/
  echo "init df_game_r success"
else
  echo "df_game_r has already initialized, do nothing!"
fi

# 判断root文件夹是否初始化过
if [ ! -d "/data/root" ]; then
  mkdir /data/root
  echo "init root folder success"
else
  echo "root has already initialized, do nothing!"
fi

# 判断run文件是否初始化过
if [ ! -f "/data/root/run" ]; then
  # 拷贝版本文件到持久化目录
  cp /home/template/init/run /data/root/
  echo "init run success"
else
  echo "run has already initialized, do nothing!"
fi

# 判断stop文件是否初始化过
if [ ! -f "/data/root/stop" ]; then
  # 拷贝版本文件到持久化目录
  cp /home/template/init/stop /data/root/
  echo "init stop success"
else
  echo "stop has already initialized, do nothing!"
fi
