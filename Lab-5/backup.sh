#!/bin/bash
sudo cgexec -g io:io_limit_31 fio --name=write_test --filename=testfile --size=1G --bs=4k --rw=write --direct=1 --iodepth=1 --runtime=10 --time_based
sudo cgexec -g io:io_limit_31 fio --name=read_test --filename=testfile --size=1G --bs=4k --rw=read --direct=1 --iodepth=1 --runtime=10 --time_based
