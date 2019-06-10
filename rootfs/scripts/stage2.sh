#!/bin/bash

function check_failure() {
    if [ $1 -eq 0 ]; then
        echo "Succeeded"
    else        
        echo -e "Failed"
        exit 1
    fi
}

apt-get -q update -y
check_failure $?

apt-get -q install -y openssh-server ntpdate tmux less python2.7 \
        wget lynx git ca-certificates ntp strace dnsutils tcpdump \
        i2c-tools
check_failure $?

apt-get -q --no-install-recommends install nmap
check_failure $?

if [ -f /etc/inittab ]; then
sed -i -e '/T1:/a T2:23:respawn:/sbin/getty -L ttyS2 115200n8 xterm-256color' /etc/inittab
check_failure $?
fi

sed -i -e '/Protocol /a UseDNS no' /etc/ssh/sshd_config
check_failure $?

sed -i -e 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
check_failure $?

if [ -f /etc/securettyi ]; then
sed -i -e '/ttysclp0/a # xilinx\nttyPS0' /etc/securetty
check_failure $?
fi

sed -i -e "/source-directory/a #\nauto eth0\nallow-hotplug eth0\niface eth0 inet dhcp\n" /etc/network/interfaces
check_failure $?

sed -i -e "/You do need to talk/a server timeserver.iix.net.il\nserver time.google.com" /etc/ntp.conf
check_failure $?

echo -e "12345\n12345\n" | passwd
check_failure $?

cp /root/motd /etc
check_failure $?

cp /root/issue /etc
check_failure $?

cp /root/issue /etc/issue.net
check_failure $?

wget https://bootstrap.pypa.io/ez_setup.py
check_failure $?

python2.7 ez_setup.py
check_failure $?

#easy_install python-daemon
#check_failure $?


