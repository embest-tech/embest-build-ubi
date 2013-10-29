#!/bin/sh

ROOT_DIR=out/target/product/$1/rootfs

[ -d ${ROOT_DIR} ] && rm -Rf ${ROOT_DIR}

[ -d ${ROOT_DIR} ] || mkdir -p ${ROOT_DIR}

[ -d ${ROOT_DIR} ] || {
	echo "###~### root dir ${ROOT_DIR} not exist"
	exit 1
}

pushd ${ROOT_DIR} 2>&1 >/dev/null
cp -Rf ../root/* ./
[ -d system ] || mkdir system
cp -Rf ../system/* system/

#cd bin
#for i in sh clear cp vi mv cat find grep uname; do
#	[ -f $i ] && rm -f $i
#	ln -s busybox $i
#done
#cd ..

popd 2>&1 >/dev/null

#cd OMAP35x_Android_Graphics_SDK_3_01_00_03
#make OMAPES=5.x install
#cd ..

MKFSUBI=$HOME/tools/mkfs.ubifs
MKFSUBI_ARG="-r ${ROOT_DIR} -m 2048 -e 126976 -c 4063 -o temp/ubifs.img"
UBINIZE=$HOME/tools/ubinize
UBINIZECFG=$HOME/tools/ubinize_256.cfg
UBINIZE_ARG="-o ubi.img -m 2048 -p 128KiB -s 512 -O 2048 ${UBINIZECFG}"

#set -x

[ -d temp ] || mkdir temp
[ "$(whoami)" = "android" ] &&						\
echo -e "android\n" | sudo -p ... -S ${MKFSUBI} ${MKFSUBI_ARG}	||	\
sudo ${MKFSUBI} ${MKFSUBI_ARG} 
pushd temp 2>&1 >/dev/null
[ "$(whoami)" = "android" ] &&						\
echo -e "android\n" | sudo -p ... -S ${UBINIZE} ${UBINIZE_ARG}	||	\
sudo ${UBINIZE} ${UBINIZE_ARG}
popd 2>&1 >/dev/null

echo "###~### file temp/ubi.img generated ###"
ls -l temp/ubi.img

