#!/bin/sh

SCRIPT_DIR="$(cd ${0%/*} ; pwd)"
GIT_DIR=${SCRIPT_DIR}/../git
KERNEL_DIR=${SCRIPT_DIR}/../../../linux-xlnx
NAMESERVER="${NAMESERVER:-10.56.190.1} 10.56.190.1 194.90.0.1, 212.143.0.1"
HOSTNAME=xilinx

if [ "${PROJ_DIR}" == "" ]; then
    echo -e "PROJ_DIR is not defined... Failed"
    exit 1
fi

. ${SCRIPT_DIR}/common.sh

echo -e "Starting to customize rootfs in ${PROJ_DIR}"

echo -e "Switching to project directory ${PROJ_DIR}... "
cd ${PROJ_DIR}
check_failure $?

echo -e "Copying uImage..."
cp ${KERNEL_DIR}/arch/arm/boot/uImage boot
check_failure $?

echo -e "Copying qemu-arm-static..."
cp /usr/bin/qemu-arm-static rootfs/usr/bin/
check_failure $?

echo -e "Creating /etc/resolv.conf..."
for ns in ${NAMESERVER}; do
    echo "nameserver ${ns}" >> rootfs/etc/resolv.conf
    check_failure $?
done

echo -e "Creating /etc/hostname..."
echo ${HOSTNAME} > rootfs/etc/hostname
check_failure $?

echo -e "Copying stage1 script..."
cp ${SCRIPT_DIR}/stage1.sh rootfs/root/
check_failure $?
chmod 755 rootfs/root/stage1.sh
check_failure $?

echo -e "Copying stage2 script..."
cp ${SCRIPT_DIR}/stage2.sh rootfs/root/
check_failure $?
chmod 755 rootfs/root/stage2.sh
check_failure $?

echo -e "Copying /etc files..."
cp ${SCRIPT_DIR}/../etc/motd ${SCRIPT_DIR}/../etc/issue rootfs/root/
check_failure $?

#echo -e "Chrooting and running stage #1..."
#chroot rootfs /root/stage1.sh
#check_failure $?
