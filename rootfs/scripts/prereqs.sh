#!/bin/bash

PREREQS_REQUIRED="qemu-user-static debootstrap binfmt-support dosfstools"
PREREQS_FAILED=""

for prereq in ${PREREQS_REQUIRED}; do
    echo -en "Checking for ${prereq}... "
    installed=$(dpkg-query -W -f='${Status}' ${prereq} 2>/dev/null | grep -c "ok installed")
    if [ $installed -eq 0 ]; then
        echo 'failed'
        PREREQS_FAILED="${prereq} ${PREREQS_FAILED}"
    else
        echo 'ok'
    fi
done

if [ "${PREREQS_FAILED}" != "" ]; then
    echo -e 'Prereqs check failed'
    echo -e 'Please run the following command to install required packages:'
    echo -e "sudo apt-get install ${PREREQS_FAILED}"
    exit 1
fi

exit 0
