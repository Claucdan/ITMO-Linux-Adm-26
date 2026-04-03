task0:
	@sudo apt update
	@sudo apt install -y cgroup-tools sysstat stress stress-ng docker.io fio util-linux

task1:
	@sudo useradd -m user-72
	@sudo systemctl set-property user-72.slice CPUQuota=70%
	@systemctl show user-72.slice | grep CPUQuota

task2:
	@sudo mkdir /sys/fs/cgroup/memlimit_72
	@echo 1220M | sudo tee /sys/fs/cgroup/memlimit_72/memory.max
	@stress --vm 1 --vm-bytes 1220M --vm-keep &
	@sudo bash -c 'echo $$ > /sys/fs/cgroup/memlimit_72/cgroup.procs; exec stress --vm 1 --vm-bytes 1320M --vm-keep'
	
task3:
	@lsblk
	@cat /sys/block/sda/dev
	@sudo mkdir /sys/fs/cgroup/io_backup_72
	@echo "8:0 riops=1720 wiops=1200" | sudo tee /sys/fs/cgroup/io_backup_72/io.max

