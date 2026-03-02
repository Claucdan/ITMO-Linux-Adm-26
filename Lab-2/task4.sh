#!/bin/bash

sudo tune2fs -l /dev/sdb1

# [02-03-2026 23:33:42] {40ab33fa} student@vm-amd:~$ sudo tune2fs -l /dev/sdb1
# tune2fs 1.47.0 (5-Feb-2023)
# Filesystem volume name:   <none>
# Last mounted on:          <not available>
# Filesystem UUID:          4e24904f-e7df-4400-ad5a-cf88f926773f
# Filesystem magic number:  0xEF53
# Filesystem revision #:    1 (dynamic)
# Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent 64bit flex_bg sparse_super large_file huge_file dir_nlink extra_isize metadata_csum
# Filesystem flags:         signed_directory_hash 
# Default mount options:    user_xattr acl
# Filesystem state:         clean
# Errors behavior:          Continue
# Filesystem OS type:       Linux
# Inode count:              128000
# Block count:              128000
# Reserved block count:     6400
# Overhead clusters:        12296
# Free blocks:              115698
# Free inodes:              127989
# First block:              0
# Block size:               4096
# Fragment size:            4096
# Group descriptor size:    64
# Reserved GDT blocks:      62
# Blocks per group:         32768
# Fragments per group:      32768
# Inodes per group:         32000
# Inode blocks per group:   2000
# Flex block group size:    16
# Filesystem created:       Mon Mar  2 23:33:16 2026
# Last mount time:          n/a
# Last write time:          Mon Mar  2 23:33:16 2026
# Mount count:              0
# Maximum mount count:      -1
# Last checked:             Mon Mar  2 23:33:16 2026
# Check interval:           0 (<none>)
# Lifetime writes:          273 kB
# Reserved blocks uid:      0 (user root)
# Reserved blocks gid:      0 (group root)
# First inode:              11
# Inode size:	         256
# Required extra isize:     32
# Desired extra isize:      32
# Journal inode:            8
# Default directory hash:   half_md4
# Directory Hash Seed:      64569a6b-faf4-4b0c-9c9d-694515b4a087
# Journal backup:           inode blocks
# Checksum type:            crc32c
# Checksum:                 0x87cbb761
