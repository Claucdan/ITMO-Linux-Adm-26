#!/bin/bash

sudo mkdir /mnt/newdisk
sudo mount /dev/sdb1 /mnt/newdisk
mount | grep sdb1
