sudo vgcreate vg01 /dev/sdc1 /dev/sdd1
sudo lvcreate -i2 -I64 -l 100%FREE -n lv01 vg01
sudo mkfs.ext4 /dev/vg01/lv01
