sudo fdisk /dev/sdb

# n
# p
# 2
# default
# +12M
# w

sudo mke2fs -O journal_dev /dev/sdb2
sudo tune2fs -J device=/dev/sdb2 /dev/sdb1
