#!/bin/bash
set -eux

HTTP_SERVER=112.124.9.243

# hack for me
PCNAME=`hostname`
if [ x"${PCNAME}" = x"tzs-i7pc" ]; then
       HTTP_SERVER=192.168.1.9
fi

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git -b kernel-5.4.y sd-fuse_rk3399
cd sd-fuse_rk3399
wget http://${HTTP_SERVER}/dvdfiles/rk3399/images-for-eflasher/friendlywrt-images.tgz
tar xzf friendlywrt-images.tgz
wget http://${HTTP_SERVER}/dvdfiles/rk3399/images-for-eflasher/emmc-flasher-images.tgz
tar xzf emmc-flasher-images.tgz
wget http://${HTTP_SERVER}/dvdfiles/rk3399/rootfs/rootfs-friendlywrt.tgz
tar xzf rootfs-friendlywrt.tgz
echo hello > friendlywrt/rootfs/root/welcome.txt
(cd friendlywrt/rootfs/root/ && {
	wget http://${HTTP_SERVER}/dvdfiles/rk3399/images-for-eflasher/friendlywrt-images.tgz -O deleteme.tgz
});
./build-rootfs-img.sh friendlywrt/rootfs friendlywrt
sudo ./mk-sd-image.sh friendlywrt
sudo ./mk-emmc-image.sh friendlywrt
