#!/bin/bash
## Update: 2016-06-01 04:41
### Thanks for Viz advice.
INSTALL_LOG_FILE=Shadowsocks-libev.log

echo "SS Install on native machine and time is: $(date -d now '+%Y-%m-%d %T %A')"

echo
echo
echo '// 调整时区到国内'
echo
echo                           '#### Settings timeZone to CTS... ####'
timedatectl set-timezone 'Asia/Shanghai'

echo
echo
echo '// 首次更新系统软件清单'
echo
echo                       '#### First Update System Software Lists... ####'
echo
yum update -y

echo
echo

echo '// 预备程序环境'
echo
echo                         '#### Ready Programs Environment... ####'
echo
yum install -y gcc automake autoconf libtool \
               make build-essential bash-completion vim curl \
               curl-devel zlib-devel openssl-devel perl git \
               perl-devel cpio expat-devel gettext-devel htop \
               ncurses-devel

echo
echo

echo '// 用户自定义环境'
echo

echo '// 第一用户环境'
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

if [ -f /etc/profile.old.bak ]; then
    echo "/etc/profile.old.bak file existing don't Backup" 1>>${INSTALL_LOG_FILE}
else
    /bin/cp /etc/profile{,.old.bak} 2>>${INSTALL_LOG_FILE}
fi

if [ -f /etc/pam.d/login.old.bak ]; then
    echo "/etc/pam.d/login.old.bak file existing don't Backup" 1>>${INSTALL_LOG_FILE}
else
    /bin/cp /etc/pam.d/login{,.old.bak} 2>>${INSTALL_LOG_FILE}
fi

if [ -f /etc/pam.d/su.old.bak ]; then
    echo "/etc/pam.d/su.old.bak file existing don't Backup" 1>>${INSTALL_LOG_FILE}
else
    /bin/cp /etc/pam.d/su{,.old.bak} 2>>${INSTALL_LOG_FILE}
fi

echo '// 第二用户环境'
echo
echo "export LS_OPTIONS='--color=auto'" >> $HOME/.bashrc 2>>${INSTALL_LOG_FILE}
echo "eval \"\`dircolors\`\"" >> $HOME/.bashrc 2>>${INSTALL_LOG_FILE}
echo "alias ls='ls \$LS_OPTIONS'" >> $HOME/.bashrc 2>>${INSTALL_LOG_FILE}
echo "alias ll='ls \$LS_OPTIONS -alh'" >> $HOME/.bashrc 2>>${INSTALL_LOG_FILE}
echo "alias  l='ls \$LS_OPTIONS -lA'" >> $HOME/.bashrc 2>>${INSTALL_LOG_FILE}
echo "alias grep='grep --colour=auto'" >> $HOME/.bashrc 2>>${INSTALL_LOG_FILE}
echo "alias vi='vim'" >> $HOME/.bashrc 2>>${INSTALL_LOG_FILE}

/bin/cp ./ss/root/.vimrc $HOME 2>>${INSTALL_LOG_FILE}

source $HOME/.bashrc 2>> ${INSTALL_LOG_FILE}
source $HOME/.vimrc 2>> ${INSTALL_LOG_FILE}


cat <<EOF >> /etc/profile
export TMOUT=300
EOF

cat <<EOF >> /etc/pam.d/login
auth required pam_tally2.so deny=6 unlock_time=180 even_deny_root root_unlock_time=180
EOF

cat <<EOF >> /etc/pam.d/su
auth            required        pam_wheel.so use_uid
EOF

echo '######## // 用户自定义环境 结束 // ########'
echo
echo
echo '######## // 准备安装 Shadowsocks-libev ... // ########'

echo -e "\n\n\n\n\n\n"

echo '######## // Shadowsocks-libev 开始源码包编译安装 // ########'
echo
echo                          '#### Configure And Install SS.. ####'
sleep '5s'
echo
SSLIBEV=$(ps -ef |grep 'ss-server' |grep -v grep |wc -l)
SSSTABLE=$(ps -ef |grep 'ssserver' |grep -v grep |wc -l)
SSLIBEV_PID=$(ps -ef | grep 'ss-server' | grep -v 'grep' | sed -n "1,1p" | awk '{print $2}')
SSLIBEV_USER=$(ps -ef | grep 'ss-server' | grep -v 'grep' | sed -n "1,1p" | awk '{print $1}')
SSSTABLE_PID=$(ps -ef | grep 'ssserver' | grep -v 'grep' | sed -n "1,1p" | awk '{print $2}')
SSSTABLE_USER=$(ps -ef | grep 'ssserver' | grep -v 'grep' | sed -n "1,1p" | awk '{print $1}')


if [ $SSLIBEV -gt "0" ]; then
    echo "在您的系统中已经安装了 Shadowsocks-libev 并且正在运行之中..."
    echo "以 ${SSLIBEV_USER} 用户身份运行  PID: ${SSLIBEV_PID}"
    echo
    echo
    echo
    exit 0
elif [ $SSSTABLE -gt "0" ]; then
    echo "在您的系统中已经安装了 Shadowsocks稳定版 并且正在运行之中..."
    echo "以 ${SSSTABLE_USER} 用户身份运行  PID: ${SSSTABLE_PID}"
    echo
    echo
    echo
    exit 0
elif [ ! -d shadowsocks-libev ]; then
    git clone https://github.com/shadowsocks/shadowsocks-libev.git 2>>${INSTALL_LOG_FILE}
    cd shadowsocks-libev
    ./configure && make
    make install
fi

echo -e "\n\n"
echo '######## // Shadowsocks-libev 源码包编译安装 结束 // ########'
echo
echo
echo '######## // Shadowsocks-libev 设置开机启动服务 // ########'
echo
echo 'Shadowsock-libev Install Done And following Install Shadowsock-libev Service......'
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
    mkdir -p /etc/shadowsocks 2>>${INSTALL_LOG_FILE}
    /bin/cp ./ss/config.json /etc/shadowsocks 2>>${INSTALL_LOG_FILE}
    /bin/cp ./ss/shadowsocks-server.service /etc/systemd/system  2>>${INSTALL_LOG_FILE}
    /bin/cp ./ss/ss-server.xml /usr/lib/firewalld/services 2>>${INSTALL_LOG_FILE}
elif [ -d /etc/shadowsocks ]; then
    /bin/cp /etc/shadowsocks/config.json{,.old.bak} 2>>${INSTALL_LOG_FILE}
    /bin/cp ./ss/config.json /etc/shadowsocks 2>>${INSTALL_LOG_FILE}
    /bin/cp ./ss/shadowsocks-server.service /etc/systemd/system 2>>${INSTALL_LOG_FILE}
    /bin/cp ./ss/ss-server.xml /usr/lib/firewalld/services 2>>${INSTALL_LOG_FILE}
else
    echo 'config.json file is not existed or check Make sure the Shadowsocks-libev is installed and that the configuration is correct !'
    exit 0
fi
#### FIXME DONE

## 添加SSH 备用端口和SS端口规则到防火墙
echo                          '#### Adding Port mapping Firewall to rules... ####'
echo -e "\n\n"

firewall-cmd --add-service=ss-server --zone=public --permanent 2>>${INSTALL_LOG_FILE}
firewall-cmd --reload 2>>${INSTALL_LOG_FILE}

echo -e "\n\n"
echo                          '#### About Firewall Information Port ####'
echo -e "\n\n"

## 列出已添加端口的映射情况
firewall-cmd --list-all

echo -e "\n\n"
## 防火墙配置完毕
echo                          '#### Over Firewall Configure ####'

echo -e "\n\n\n\n\n\n"

## 添加SS开机自启动 -- 并立即启动SS
echo                          '#### Adding SS to Startup... ####'
systemctl enable shadowsocks-server.service 2>>${INSTALL_LOG_FILE}
systemctl restart shadowsocks-server.service 2>>${INSTALL_LOG_FILE}

echo -e "\n\n\n\n\n\n"



## 配置计算机名
echo                          '#### Configure Computer MachineName ####'

echo -e "\n\n"

if [ -f /etc/hostname.old.bak ]; then
    echo "/etc/hostname.old.bak file existing don't Backup" 1>>${INSTALL_LOG_FILE}
else
    /bin/cp /etc/hostname{,.old.bak} 2>>${INSTALL_LOG_FILE}
fi

echo -e "\n\n"

if [ -f /etc/hosts.old.bak ]; then
    echo "/etc/hosts.old.bak file existing don't Backup" 1>>${INSTALL_LOG_FILE}
else
    /bin/cp /etc/hosts{,.old.bak} 2>>${INSTALL_LOG_FILE}
fi

echo -e "\n\n"

cat <<EOF > /etc/hostname
localhost.vultr.guest
EOF

cat <<EOF > /etc/hosts
127.0.0.1 localhost.vultr.guest
EOF

## 查看SS服务的运行状态
echo                          '#### Shadowsocks status Information ####'
echo
systemctl status shadowsocks-server.service 2>>${INSTALL_LOG_FILE}
echo
echo
echo
echo

echo 'This Original Configuration All Backup Locale Following:'
find / -type f -iname *.old.bak
echo
echo
echo
echo
## 列出安装完成后的所有信息
echo                           '#### Install Information ####'
echo
echo                          'Your Shadowsocks port is: 34302'
echo
echo                             'Your SSH port is: 22'
echo
echo                            '#### Begin enjoy it !!! ####'
echo
echo
echo
echo


