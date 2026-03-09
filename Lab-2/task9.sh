sudo blkid /dev/sdb1
sudo vim /etc/fstab
sudo mount -a
sudo reboot
mount | grep newdisk

cd /mnt/newdisk
echo -e '#!/bin/bash\necho TEST' > test.sh # ??? 
chmod +x test.sh
./test.sh

# /dev/sdb1: UUID="fd5851b5-203c-4446-8c13-074b897717af" BLOCK_SIZE="4096" TYPE="ext4" PARTUUID="2dcc3fe0-01"
