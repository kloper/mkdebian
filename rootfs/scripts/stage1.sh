#!/bin/bash

export distro=jessie

function check_failure() {
    if [ $1 -eq 0 ]; then
        echo "Succeeded"
    else        
        echo -e "Failed"
        exit 1
    fi
}

/debootstrap/debootstrap --second-stage
check_failure $?

cat <<EOF > /etc/apt/sources.list
deb http://ftp.uk.debian.org/debian ${distro} main contrib non-free
deb-src http://ftp.uk.debian.org/debian ${distro} main contrib non-free
deb http://ftp.uk.debian.org/debian ${distro}-updates main contrib non-free
deb-src http://ftp.uk.debian.org/debian ${distro}-updates main contrib non-free
deb http://security.debian.org/debian-security ${distro}/updates main contrib non-free
deb-src http://security.debian.org/debian-security ${distro}/updates main contrib non-free
EOF
check_failure $?

apt-get -q update -y
check_failure $?

apt-get -q install -y locales dialog
check_failure $?


echo "Etc/UTC" > /etc/timezone
check_failure $?

echo "LANG=en_US.UTF-8" > /etc/default/locale
check_failure $?

sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
check_failure $?

dpkg-reconfigure -f noninteractive locales
check_failure $?

dpkg-reconfigure -f noninteractive tzdata
check_failure $?


