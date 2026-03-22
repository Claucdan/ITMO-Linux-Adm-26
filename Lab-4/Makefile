# Part 1
task1-1:
	@systemd-analyze
task1-2:
	@systemd-analyze blame
task1-3:
	@apt show build-essential
	@systemctl list-dependencies --reverse sshd.service
task1-4:
	@systemd-analyze plot > boot_plot.svg

# Part 2
task2-1:
	@systemctl list-units --type=service --state=running
task2-2:
	@systemctl list-unit-files --type=service --state=enabled
task2-3:
	@systemctl list-dependencies sshd.service --all
task2-4:
	@systemctl status cron
task2-5:
	@systemctl show cron.service --all
task2-6:
	@sudo systemctl disable cron

# Part 3
task3-1:
	@sudo vim /etc/systemd/system/mymsg.service
task3-2:
	@sudo systemctl enable mymsg.service
	@sudo systemctl status mymsg.service 
	@systemctl is-enabled mymsg.service
task3-3:
	@sudo systemctl start mymsg.service
	@sudo systemctl status mymsg.service 

# Part 4
task4-1:
	@journalctl | grep mymsg
	# @journalctl -u mymsg.service
	@systemctl list-units --type=service --state=running
task4-2:
	@journalctl -u mymsg.service --output=verbose
task4-3:
	@journalctl -p err
task4-4:
	@journalctl --disk-usage

# Part 5
task5-1:
	@lsblk
	# @sudo fdisk /dev/sdb
	# @sudo mkfs.ext4 /dev/sdb1
	@sudo mkdir -p /mnt/mydata
task5-2:
	@sudo vim /etc/systemd/system/mnt-mydata.mount
	@systemctl list-unit-files --type=service --state=enabled
task5-3:
	@sudo systemctl daemon-reload
	@systemd-analyze verify /etc/systemd/system/mnt-mydata.mount
	@sudo systemctl enable mnt-mydata.mount
	@sudo systemctl start mnt-mydata.mount
	@sudo systemctl status mnt-mydata.mount
	@mount | grep mydata

# Part 6
task6-1:
	@ls -la /etc/systemd/system/mnt-mydata.mount
	@mount | grep mydata
	@sudo systemctl stop mnt-mydata.mount
	@mount | grep mydata
	@sudo systemctl start mnt-mydata.mount
	@mount | grep mydata
task6-2:
	@sudo vim /etc/systemd/system/mnt-mydata.automount
	@sudo systemctl daemon-reload
	@systemd-analyze verify /etc/systemd/system/mnt-mydata.automount
task6-3:
	@sudo systemctl start mnt-mydata.automount
	@sudo systemctl status mnt-mydata.automount
	@mount | grep mydata
	@lsblk | grep mydata
	@ls -la /mnt/mydata
	@lsblk | grep mydata
	@mount | grep mydata
