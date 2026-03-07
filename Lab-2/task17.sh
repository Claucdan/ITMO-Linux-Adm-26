sudo fdisk /dev/sde
sudo pvcreate /dev/sde1
sudo vgextend vg01 /dev/sde1
sudo lvextend -l +100%FREE /dev/vg01/lv01
sudo resize2fs /dev/vg01/lv01
df -h /mnt/vol01
