task1:
	@cat /etc/apt/sources.list
	@echo "================================================"
	@cat /etc/apt/sources.list.d/ubuntu.sources
	@echo "================================================"
	@ls /etc/apt/sources.list.d/ | xargs -I {} cat /etc/apt/sources.list.d/{}
task2:
	@sudo apt update
task3:
	@apt show build-essential
task4:
	@sudo apt install build-essential
task5:
	@apt search . | grep -i "clone with a bastard algorithm"
task6:
	@mkdir Downloads
	@cd Downloads
	@sudo apt source bastet
task7:
	@cd bastet-0.43
	@sudo apt build-dep bastet
task8:
	# vim Makefile
task9:
	# bastet
task10:
	@cd ~/lab-3
	@dpkg-query -l > ~/lab-3/task10.log
task11:
	@apt-cache depends gcc > ~/lab-3/task11.log
task12:
	@apt-cache rdepends libgpm2 > ~/lab-3/task12.log
task13:
	@sudo su
	@mkdir -p /root/localrepo
	@cd /root/localrepo
	@wget https://snapshot.debian.org/archive/debian/20250711T144811Z/pool/main/h/htop/htop_3.4.1-5_amd64.deb
	@wget https://snapshot.debian.org/archive/debian/20250408T150802Z/pool/main/h/htop/htop_3.4.0-5_amd64.deb
	@wget https://snapshot.debian.org/archive/debian/20250209T210016Z/pool/main/h/htop/htop_3.3.0-5_amd64.deb
	@wget https://snapshot.debian.org/archive/debian/20230227T025930Z/pool/main/h/htop/htop_3.2.2-2_amd64.deb
	@wget https://snapshot.debian.org/archive/debian/20210502T143907Z/pool/main/h/htop/htop_3.0.5-7_amd64.deb
	@exit
task14:
	@sudo su
	@cd /root/localrepo
	@apt-ftparchive packages . > Packages
	@apt-ftparchive release . > Release
	# vim Release
task15:
	#vim /etc/apt/sources.list.d/localrepo.list
	@apt update
task16:
	@cat /etc/apt/sources.list >> ~/lab-3/task16.log
	@ls -la /etc/apt/sources.list.d/ >> ~/lab-3/task16.log
	@cat /etc/apt/sources.list.d/localrepo.list 2>/dev/null >> ~/lab-3/task16.log
	@apt-cache policy >> ~/lab-3/task16.log
task17:
	@apt list -a htop > ~/lab-3/task17.log
task18:
	@exit
	@cd ~/lab-3/Downloads
	@apt download nano
	@mkdir -p nano-rebuild
	@cd nano-rebuild
	@dpkg-deb -x ../nano_*.deb temp
	@dpkg-deb -e ../nano_*.deb temp/DEBIAN
	@cd temp/usr/bin
	@ln -s nano newnano
	@cd ~/lab-3/Downloads/nano-rebuild
	@dpkg-deb -b temp newnano.deb
	@sudo dpkg -i newnano.deb
