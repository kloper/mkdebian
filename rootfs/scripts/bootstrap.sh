#!/bin/bash

SCRIPT_DIR="$(cd ${0%/*} ; pwd)"
IMAGE_DIR=${SCRIPT_DIR}/../image
PROJ_NAME=${PROJ_NAME:-$(date '+%d%m%Y-%H%M%S')}
PROJ_DIR=${IMAGE_DIR}/${PROJ_NAME}
DIST_NAME=${DIST_NAME:-jessie}
IMAGE_NAME="${DIST_NAME}.img"
DISK_SIZE_MB=${DISK_SIZE_MB:-1536}
BOOT_SIZE_MB=${BOOT_SIZE_MB:-50}
DEBIAN_MIRROR=${DEBIAN_MIRROR:-http://ftp.uk.debian.org/debian}
BOOT_FS_TYPE=FAT32
ARCH=armhf

. ${SCRIPT_DIR}/common.sh

echo -e "Creating rootfs image in ${PROJ_DIR}"
echo -e "Disk size ${DISK_SIZE_MB}MB"
echo -e "/boot partition size ${BOOT_SIZE_MB}MB"
echo

echo -e "Creating project directory ${PROJ_DIR}... "
mkdir -p ${PROJ_DIR}
check_failure $?
cd ${PROJ_DIR}
check_failure $?

echo -e "Creating raw disk file... "
dd if=/dev/zero of=${IMAGE_NAME} count=${DISK_SIZE_MB} bs=1M
check_failure $?

echo -e "Mounting loop... "
losetup /dev/loop0 ${IMAGE_NAME}
check_failure $?
need_detach=1

echo -e "Partitioning... "
fdisk /dev/loop0 <<EOF
n
p
1

+${BOOT_SIZE_MB}M
n
p



w
EOF
partx -a /dev/loop0
check_failure $?

echo -e "Formatting... "
check_failure $?
if [ "${BOOT_FS_TYPE}" == "FAT32" ]; then
    mkdosfs -F 32 -I /dev/loop0p1
elif [ "${BOOT_FS_TYPE}" == "EXT2" ]; then    
    mkfs.ext2 /dev/loop0p1
else
    echo 'Unknown file system type for boot'
    exit 1
fi
check_failure $?
mkfs.ext3 /dev/loop0p2
check_failure $?

echo -e "Mounting p2..."
mkdir rootfs
check_failure $?
mount /dev/loop0p2 rootfs
check_failure $?
need_umount=1

echo -e "Mounting p1..."
mkdir boot
check_failure $?
mount /dev/loop0p1 boot
check_failure $?
need_umount=1

echo -e "Creating debian stage #1..."
debootstrap --arch=${ARCH} --foreign ${DIST_NAME} rootfs ${DEBIAN_MIRROR}
check_failure $?

