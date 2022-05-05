#!/usr/bin/env bash

# WSL Ubuntu
# Ubuntu 替换软件源
# 编辑 /etc/apt/sources.list 替换默认的 http://archive.ubuntu.com/ 为 mirrors.aliyun.com
cat /etc/apt/sources.list
cp /etc/apt/sources.list /etc/apt/sources.list.backup
sed -i 's_archive.ubuntu.com_mirrors.aliyun.com_' /etc/apt/sources.list

# 以下内容参考：https://openwrt.org/docs/guide-user/additional-software/imagebuilder
# Ubuntu x86 安装开发依赖
sudo apt install build-essential libncurses5-dev libncursesw5-dev \
zlib1g-dev gawk git gettext libssl-dev xsltproc rsync wget unzip python

# 以 linksys wrt32x 为例编译
# Obtaining the Image Builder
wget https://mirror.sjtu.edu.cn/openwrt/releases/21.02.3/targets/mvebu/cortexa9/openwrt-imagebuilder-21.02.3-mvebu-cortexa9.Linux-x86_64.tar.xz

# Unpack the archive and change the working directory:
tar -J -x -f openwrt-imagebuilder-*.tar.xz
cd openwrt-imagebuilder-*/

# 查看可用 PROFILE，选择对应的型号
make info

# 替换软件源，将 downloads.openwrt.org 替换为 mirror.sjtu.edu.cn/openwrt
sed -i 's_downloads.openwrt.org_mirror.sjtu.edu.cn/openwrt_' repositories.conf

# 修改默认配置
#mkdir -p files/etc/config
#scp root@192.168.1.1:/etc/config/wireless files/etc/config/

# fix Windows WSL 下的 PATH 问题
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"

# 编译
# 定制增加软件包
# UI 中文包：luci-i18n-base-zh-cn luci-i18n-opkg-zh-cn 
# DDNS：luci-app-ddns luci-i18n-ddns-zh-cn ddns-scripts-cloudflare
# Wireguard：luci-proto-wireguard luci-app-wireguard
make image PROFILE="linksys_wrt32x" PACKAGES="luci-i18n-base-zh-cn luci-i18n-opkg-zh-cn luci-app-ddns luci-i18n-ddns-zh-cn ddns-scripts-cloudflare luci-proto-wireguard luci-app-wireguard"

# 文件位置：C:\Users\admin\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu20.04LTS_79rhkp1fndgsc\LocalState\rootfs\home\admin
