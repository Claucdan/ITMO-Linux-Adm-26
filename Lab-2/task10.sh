
sudo umount /mnt/newdisk
sudo fdisk /dev/sdb

# p — показать таблицу разделов
# запомнить Start sector раздела /dev/sdb1
# d — удалить раздел
# 1 — номер раздела
# n — создать новый
# p — primary
# 1 — номер раздела
# First sector → ввести прежний Start sector
# Last sector → +1G
# w — сохранить
#
# Disk /dev/sdb: 2 GiB, 2147483648 bytes, 4194304 sectors
# Disk model: VBOX HARDDISK   
# Units: sectors of 1 * 512 = 512 bytes
# Sector size (logical/physical): 512 bytes / 512 bytes
# I/O size (minimum/optimal): 512 bytes / 512 bytes
# Disklabel type: dos
# Disk identifier: 0x2dcc3fe0
#
# Device     Boot Start     End Sectors  Size Id Type
# /dev/sdb1        2048 1026047 1024000  500M 83 Linux


sudo e2fsck -f /dev/sdb1
sudo resize2fs /dev/sdb1
