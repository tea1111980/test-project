#!/bin/bash
## Update: 2016-06-01 05:52
### Thanks for Viz advice.

INSTALL_LOG_FILE=Shadowsocks-libev.log
SHADOWSOCKS_LIBEV_SERVICE_NAME=shadowsocks-libev-boot-server.service
SSLIBEV_PORT_PATH=./ss/Shadowsocks-libev-firewall-port.xml
SSLIBEV_SERVICE_PATH=./ss/shadowsocks-libev-boot-server.service
SSLIBEV_CONFIG_FILE_PATH=./ss/config.json

echo "SS Install on native machine and time is: $(date -d now '+%Y-%m-%d %T %A')"

echo
echo
echo '######## // 首次更新系统软件清单 // ######## First Update System Software Lists...'
echo
echo
sudo yum update -y

echo
echo

echo '######## // 预备程序环境 // ######### Ready Programs Environment...'
echo
echo
sudo yum install -y gcc automake autoconf libtool \
               make build-essential bash-completion vim curl \
               curl-devel zlib-devel openssl-devel perl git \
               perl-devel cpio expat-devel gettext-devel htop \
               ncurses-devel

echo
echo

echo '######## // 用户自定义环境 开始 // ######## User defined environment to Begin...'
echo

if [ -f $HOME/.bashrc.old.bak ]; then
    echo "$HOME/.bashrc.old.bak file existing don't Backup" 1>>${INSTALL_LOG_FILE}
else
    /bin/cp $HOME/.bashrc{,.old.bak} 2>>${INSTALL_LOG_FILE}
fi

if [ -f $HOME/.vimrc.old.bak ]; then
    echo "$HOME/.vimrc.old.bak file existing don't Backup" 1>>${INSTALL_LOG_FILE}
else
    /bin/cp $HOME/.vimrc{,.old.bak} 2>>${INSTALL_LOG_FILE}
fi

echo
echo "export LS_OPTIONS='--color=auto'" >> $HOME/.bashrc 2>>${INSTALL_LOG_FILE}
echo "eval \"\`dircolors\`\"" >> $HOME/.bashrc 2>>${INSTALL_LOG_FILE}
echo "alias ls='ls \$LS_OPTIONS'" >> $HOME/.bashrc 2>>${INSTALL_LOG_FILE}
echo "alias ll='ls \$LS_OPTIONS -alh'" >> $HOME/.bashrc 2>>${INSTALL_LOG_FILE}
echo "alias  l='ls \$LS_OPTIONS -lA'" >> $HOME/.bashrc 2>>${INSTALL_LOG_FILE}
echo "alias grep='grep --colour=auto'" >> $HOME/.bashrc 2>>${INSTALL_LOG_FILE}
echo "alias vi='vim'" >> $HOME/.bashrc 2>>${INSTALL_LOG_FILE}
echo "alias rm='rm -i'" >> $HOME/.bashrc 2>>${INSTALL_LOG_FILE}

/bin/cp ./ss/root/.vimrc $HOME 2>>${INSTALL_LOG_FILE}

source $HOME/.bashrc 2>>/dev/null
source $HOME/.vimrc 2>>/dev/null

echo '######## // 用户自定义环境 结束 // ######## User defined environment to End'
echo
echo
echo '######## // 准备安装 Shadowsocks-libev ... // ######## Ready to install Shadowsocks-libev ...'

echo -e "\n\n\n\n\n\n"

echo '######## // Shadowsocks-libev 开始源码包编译安装 // ######## Source package installation start'
echo
echo                          '#### Compile and install SShadowsocks-libev.. ####'
sleep '5s'
echo
SSLIBEV=$(ps -ef |grep 'ss-server' |grep -v grep |wc -l)
SSSTABLE=$(ps -ef |grep 'ssserver' |grep -v grep |wc -l)
SSLIBEV_PID=$(ps -ef | grep 'ss-server' | grep -v 'grep' | sed -n "1,1p" | awk '{print $2}')
SSLIBEV_USER=$(ps -ef | grep 'ss-server' | grep -v 'grep' | sed -n "1,1p" | awk '{print $1}')
SSSTABLE_PID=$(ps -ef | grep 'ssserver' | grep -v 'grep' | sed -n "1,1p" | awk '{print $2}')
SSSTABLE_USER=$(ps -ef | grep 'ssserver' | grep -v 'grep' | sed -n "1,1p" | awk '{print $1}')


if [ $SSLIBEV -gt "0" ]; then
    echo "安装程序检测到，在您的系统中已经安装了 Shadowsocks-libev 服务器的 C libev版 并且正在运行中..."
	echo "如果您想继续安装，请关闭正在运行的 Shadowsocks..."
    echo "以 ${SSLIBEV_USER} 用户身份运行  PID: ${SSLIBEV_PID}"
    echo
    echo
    echo
    exit 0
elif [ $SSSTABLE -gt "0" ]; then
    echo "安装程序检测到，在您的系统中已经安装了 Shadowsocks 服务器原版 并且正在运行中..."
	echo "如果您想继续安装，请关闭正在运行的 Shadowsocks..."
    echo "以 ${SSSTABLE_USER} 用户身份运行  PID: ${SSSTABLE_PID}"
    echo
    echo
    echo
    exit 0
elif [ ! -d shadowsocks-libev ]; then
    sudo git clone https://github.com/shadowsocks/shadowsocks-libev.git 2>>${INSTALL_LOG_FILE}
    cd shadowsocks-libev
    sudo ./configure && sudo make
    sudo make install
else
    cd shadowsocks-libev
    sudo ./configure && sudo make
    sudo make install
fi

echo -e "\n\n"
echo '######## // Shadowsocks-libev 源码包编译安装 结束 // ######## Source package installation End'
echo
echo
echo '######## // Shadowsocks-libev 设置开机启动服务 // ########'
echo
echo 'Shadowsock-libev is already installed and is being installed the Shadowsock-libev Service...'
sleep '3s'

# check_install || {
#  cd shadowsocks-libev
#  ./configure && make
#  make install
# }

sleep '3s'
cd ..
echo -e "\n\n"
echo Current path in: "`pwd`"
echo -e "\n\n\n\n\n\n"

#### FIXME
#### FIXME OK

if [ ! -d /etc/shadowsocks ]; then
    sudo mkdir -p /etc/shadowsocks 2>>${INSTALL_LOG_FILE}
    sudo /bin/cp ${SSLIBEV_CONFIG_FILE_PATH} /etc/shadowsocks 2>>${INSTALL_LOG_FILE}
    sudo /bin/cp ${SSLIBEV_SERVICE_PATH} /etc/systemd/system  2>>${INSTALL_LOG_FILE}
    sudo /bin/cp ${SSLIBEV_PORT_PATH} /usr/lib/firewalld/services 2>>${INSTALL_LOG_FILE}
elif [ -d /etc/shadowsocks ]; then
    sudo /bin/cp /etc/shadowsocks/config.json{,.old.bak} 2>>${INSTALL_LOG_FILE}
    sudo /bin/cp ${SSLIBEV_CONFIG_FILE_PATH} /etc/shadowsocks 2>>${INSTALL_LOG_FILE}
    sudo /bin/cp ${SSLIBEV_SERVICE_PATH} /etc/systemd/system 2>>${INSTALL_LOG_FILE}
    sudo /bin/cp ${SSLIBEV_PORT_PATH} /usr/lib/firewalld/services 2>>${INSTALL_LOG_FILE}
else
	echo 'config.json 配置文件不存在，请您确保 Shadowsocks-libev 安装或配置文件的名称是正确的！'
    echo 'config.json file is not existed or check Make sure the Shadowsocks-libev is installed and that the configuration is correct !'
    exit 0
fi
#### FIXME DONE

echo '######## // 添加 Shadowsocks-libev 端口规则到防火墙 // ######## Adding Shadowsocks-libev Port Mapping Firewall To Rules...' 
echo -e "\n\n"

sudo firewall-cmd --add-service=Shadowsocks-libev-firewall-port --zone=public --permanent 2>>${INSTALL_LOG_FILE}
sudo firewall-cmd --reload 2>>${INSTALL_LOG_FILE}

echo -e "\n\n"
echo '######## // 关于 Shadowsocks-libev 的端口在防火墙的信息 // #### About Shadowsocks-libev Port in the Firewall Information ####'
echo -e "\n\n"

echo '######## 列出已添加端口的映射情况 // ######## Listed The Mapping Of The Added Port'
sudo firewall-cmd --list-all

echo -e "\n\n"
echo '######## // 防火墙配置完毕 // ######## End Firewall Configure'
echo -e "\n\n\n\n\n\n"

echo '######## // 添加SS开机自启动 -- 并立即启动SS // ######## Adding Shadowsocks-libev to Startup and Booting...'
echo
echo
sudo systemctl enable ${SHADOWSOCKS_LIBEV_SERVICE_NAME} 2>>${INSTALL_LOG_FILE}
sudo systemctl restart ${SHADOWSOCKS_LIBEV_SERVICE_NAME} 2>>${INSTALL_LOG_FILE}

echo -e "\n\n\n\n\n\n"


echo '######## // 查看SS服务的运行状态 // ########  SShadowsocks-libev Running Status Information'
echo
echo
sudo systemctl status ${SHADOWSOCKS_LIBEV_SERVICE_NAME} 2>>${INSTALL_LOG_FILE}
echo
echo
echo
echo
#echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all
echo 'This Original Configuration All Backup Locale Following:'
echo
echo
find / -type f -iname *.old.bak
echo
echo
echo
echo
## 列出安装完成后的所有信息
echo                   '######## Install Information ########'
echo
echo                 'Your Shadowsocks-libev Server Port is [ 8388 ]'
echo
echo                           'Begin enjoy it ;) !!!'
echo
echo
echo
echo


