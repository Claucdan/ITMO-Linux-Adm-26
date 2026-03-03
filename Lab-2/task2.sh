#!/bin/bash

sudo blkid /dev/sdb1
sudo mkfs.ext4 -b 4096 /dev/sdb1
sudo blkid -s UUID -o value /dev/sdb1 > /root/uuid_sdb1.txt
