sudo mkdir /mnt/vol01
sudo mount /dev/vg01/lv01 /mnt/vol01

# automount
sudo blkid /dev/vg01/lv01
sudo vim /etc/fstab
sudo mount -a
