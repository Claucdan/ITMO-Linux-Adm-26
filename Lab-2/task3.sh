#!/bin/bash

sudo mkfs.ext4 -b 4096 /dev/sdb1
# [02-03-2026 23:31:40] {40ab33fa} student@vm-amd:~$ sudo mkfs.ext4 -b 4096 /dev/sdb1
# mke2fs 1.47.0 (5-Feb-2023)
# Creating filesystem with 128000 4k blocks and 128000 inodes
# Filesystem UUID: 4e24904f-e7df-4400-ad5a-cf88f926773f
# Superblock backups stored on blocks: 
# 	32768, 98304
#
# Allocating group tables: done                            
# Writing inode tables: done                            
# Creating journal (4096 blocks): done
# Writing superblocks and filesystem accounting information: done
