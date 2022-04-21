# 删除无用文件
rm -rf /home/template/neople-tmp
mkdir -p /home/neople
# 清理root下文件
rm -rf /root/*
rm -rf /dp2/*

# 复制待使用文件
cp -r /home/template/neople /home/template/neople-tmp

# 检查/data
chmod +x /home/template/init/init.sh && /home/template/init/init.sh

# 必要文件判断
for i in "publickey.pem" "Script.pvf"; do
  if [ ! -f "/data/"$i ]; then
    echo "missing $i! exit"
    exit 1
  fi
done

GAME_PASSWORD=${GAME_PASSWORD:0:8}
DEC_GAME_PWD=$(/TeaEncrypt $GAME_PASSWORD)
echo "game password: $GAME_PASSWORD"
echo "game dec key: $DEC_GAME_PWD"
echo

# 获取mysql容器的ip
if $AUTO_MYSQL_IP; then
  MYSQL_IP=$(ping -i 0.1 -c 1 $MYSQL_NAME | sed '1{s/[^(]*(//;s/).*//;q}')
  echo "mysql ip: $MYSQL_IP"
fi

# 检测MySQL连接
mysql=(mysql -h$MYSQL_IP -P$MYSQL_PORT -ugame -p$GAME_PASSWORD)
echo "开始检测MySQL连接，倒计时30秒"
for i in {30..0}; do
  if echo 'SELECT 1' | "${mysql[@]}" &>/dev/null; then
    break
  fi
  echo 'MySQL连接失败，尝试重试...'
  sleep 1
done
if [ "$i" = 0 ]; then
  echo 'SELECT 1' | "${mysql[@]}"
  echo >&2 "MySQL连接失败，请检查 IP: $MYSQL_IP, Port: $MYSQL_PORT, Password: $GAME_PASSWORD. 结束容器"
  exit 1
fi

echo "MySQL连接成功"
echo

# 使用rinetd端口映射，映射本机3306为MySQL的ip和端口
echo "0.0.0.0 3306 $MYSQL_IP $MYSQL_PORT" >/etc/rinetd.conf
rinetd -c /etc/rinetd.conf
REP_MYSQL_IP=127.0.0.1

# 获取公网ip
if $AUTO_PUBLIC_IP; then
  PUBLIC_IP=$(curl -s http://pv.sohu.com/cityjson?ie=utf-8 | awk -F\" '{print $4}')
  echo "public ip: $PUBLIC_IP"
  echo
  sleep 5
fi

# dp插件
if $DP2; then
  # 判断dp2文件夹是否存在
  if [ ! -d "/data/dp2" ]; then
    echo "dp2 folder not exist"
  else
    if [ ! -d "/data/dp2/libGeoIP.so.1" ]; then
      echo "libGeoIP.so.1(dp2) not exist"
    else
      echo "loading dp2"
      # dp2脚本
      cp -rf /data/dp2/* /dp2/
      # 替换dp2 lib
      mv /dp2/libGeoIP.so.1 /lib/libGeoIP.so.1
    fi
  fi
fi

# 替换环境变量
find /home/template/neople-tmp -type f -name "*.cfg" -print0 | xargs -0 sed -i "s/MYSQL_IP/$REP_MYSQL_IP/g"
find /home/template/neople-tmp -type f -name "*.cfg" -print0 | xargs -0 sed -i "s/GAME_PASSWORD/$GAME_PASSWORD/g"
find /home/template/neople-tmp -type f -name "*.cfg" -print0 | xargs -0 sed -i "s/DEC_GAME_PWD/$DEC_GAME_PWD/g"
find /home/template/neople-tmp -type f -name "*.cfg" -print0 | xargs -0 sed -i "s/PUBLIC_IP/$PUBLIC_IP/g"
find /home/template/neople-tmp -type f -name "*.tbl" -print0 | xargs -0 sed -i "s/PUBLIC_IP/$PUBLIC_IP/g"
# 将结果文件拷贝到对应目录[这里是为了保住日志文件目录,将日志文件挂载到宿主机外,因此采用覆盖而不是mv]
cp -rf /home/template/neople-tmp/* /home/neople
rm -rf /home/template/neople-tmp
# 复制版本文件
cp /data/Script.pvf /home/neople/game/Script.pvf
chmod 777 /home/neople/game/Script.pvf
cp /data/df_game_r /home/neople/game/df_game_r
chmod 777 /home/neople/game/df_game_r
cp /data/publickey.pem /home/neople/game/
cp /data/run /root/
cp /data/stop /root/
chmod 777 /root/*

cd /root && chmod +x /root/*

# 启动服务
./run
