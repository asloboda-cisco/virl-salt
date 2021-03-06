#!/bin/bash
mkdir /tmp/bridge
cd /tmp/bridge/
version=`uname -r`
apt-get install -y linux-headers-$version
apt-get source -y linux-image-$version
cd linux*/
sed -i -e '/BR_GROUPFWD_RESTRICTED/s/4007/0000/' net/bridge/br_private.h
cp /usr/src/linux-headers-$version/Module.symvers .
make olddefconfig
make prepare modules_prepare
make SUBDIRS=scripts/mod
make SUBDIRS=net/bridge modules
cp net/bridge/bridge.ko /lib/modules/$version/kernel/net/bridge/
depmod
rmmod bridge
modprobe bridge
service neutron-plugin-linuxbridge-agent restart
service neutron-dhcp-agent restart
service neutron-l3-agent restart
