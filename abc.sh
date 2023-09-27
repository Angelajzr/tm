#!/bin/bash

# 更新软件包列表
apt-get update -y

# 安装所需软件包
apt-get install build-essential gnupg2 gcc make -y

# 下载 SoftEther VPN Server
wget https://www.softether-download.com/files/softether/v4.43-9799-beta-2023.08.31-tree/Linux/SoftEther_VPN_Server/64bit_-_Intel_x64_or_AMD64/softether-vpnserver-v4.43-9799-beta-2023.08.31-linux-x64-64bit.tar.gz

# 解压下载的归档文件
tar -xvzf softether-vpnserver*

# 进入 vpnserver 目录
cd vpnserver

# 编译 SoftEther VPN Server
make

# 将编译后的文件移动到 /usr/local/
cd ..
mv vpnserver /usr/local/

# 设置适当的权限
cd /usr/local/vpnserver/
chmod 600 *
chmod 700 vpnserver
chmod 700 vpncmd

# 创建 /etc/init.d/vpnserver 文件
echo -e "#!/bin/sh
# chkconfig: 2345 99 01
# description: SoftEther VPN Server
DAEMON=/usr/local/vpnserver/vpnserver
LOCK=/var/lock/subsys/vpnserver
test -x \$DAEMON || exit 0
case \"\$1\" in
start)
  \$DAEMON start
  touch \$LOCK
  ;;
stop)
  \$DAEMON stop
  rm \$LOCK
  ;;
restart)
  \$DAEMON stop
  sleep 3
  \$DAEMON start
  ;;
*)
  echo \"使用方法: \$0 {start|stop|restart}\"
  exit 1
  ;;
esac
exit 0" > /etc/init.d/vpnserver

# 创建所需的目录
sudo mkdir /var/lock/subsys

# 为 init 脚本设置权限
chmod +x /etc/init.d/vpnserver
update-rc.d vpnserver defaults


# 启动 SoftEther VPN Server
/etc/init.d/vpnserver start
