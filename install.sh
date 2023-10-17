#!/bin/bash -e
config=$1
install=$2
echo 此脚本在 Ubuntu 上制作，其他系统未做测试。
if [ -z "$config" ]; then
  echo 1.在服务器上安装
  echo 2.在本地设备安装
  read -p "请选择(默认1):" config
fi
if [[ -z "$config" ]]; then
  config=1
fi
if [[ $config == 1 ]]; then
  config_url="https://raw.sock.cf/ahhfzwl/my/main/config-server.json"
fi
if [[ $config == 2 ]]; then
  config_url="https://raw.sock.cf/ahhfzwl/my/main/config-local.json"
fi

echo 脚本需要 wget unzip ，请自行判断系统是否已安装。
echo 1.安装
echo 2.跳过
read -p "请选择(默认1):" install
if [ -z "$install" ]; then
  install=1
fi
if [[ $install == 1 ]]; then
  apt update && apt install -y wget unzip
elif [[ $install == 2 ]]; then
  echo 开始安装，请稍后。
else
  echo 输入错误，脚本终止。 && exit 1
fi

if [[ -e /root/sing-box/ ]]; then
  systemctl stop sing-box
  systemctl disable sing-box
  rm /root/sing-box/ -rf
  rm /etc/systemd/system/sing-box.service
fi

mkdir /root/sing-box/ && cd /root/sing-box/
wget https://github.sock.cf/SagerNet/sing-box/releases/download/v1.5.3/sing-box-1.5.3-linux-amd64.tar.gz
tar -xvf sing-box-*.tar.gz
cp ./sing-box-*/sing-box /root/sing-box/
rm -rf /root/sing-box/sing-box-*
chmod +x /root/sing-box/sing-box
wget -O /root/sing-box/config.json $config_url
wget -O /etc/systemd/system/sing-box.service https://raw.sock.cf/ahhfzwl/my/main/sing-box.service
systemctl enable sing-box
wget -O /root/sing-box/systemctl.sh https://raw.sock.cf/ahhfzwl/my/main/systemctl.sh
