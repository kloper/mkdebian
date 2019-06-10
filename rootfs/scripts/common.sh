#!/bin/bash

need_umount=0
need_detach=0
function check_failure() {
    if [ $1 -eq 0 ]; then
        echo "Succeeded"
    else        
        echo -e "Failed"
        if [ ${need_umount} -eq 1 ]; then
            umount rootfs
            umount boot            
        fi                
        if [ ${need_detach} -eq 1 ]; then
            partx -d /dev/loop0
            losetup -d /dev/loop0
        fi        
        exit 1
    fi
}

