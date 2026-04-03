#!/bin/bash

CGROUP="/sys/fs/cgroup/dynamic_cpu_31"
PID=$1

if [ -z "$PID" ]; then
    echo "Usage: $0 <PID>"
    exit 1
fi

echo $PID | sudo tee $CGROUP/cgroup.procs > /dev/null

echo "Monitoring CPU load..."

while true; do
    CPU_LOAD=$(mpstat 1 1 | awk '/Average/ {print 100 - $NF}')

    CPU_LOAD_INT=${CPU_LOAD%.*}

    echo "CPU load: $CPU_LOAD_INT%"

    if [ "$CPU_LOAD_INT" -lt 20 ]; then
        echo "Setting CPU limit to 80%"
        echo "80000 100000" | sudo tee $CGROUP/cpu.max > /dev/null
    elif [ "$CPU_LOAD_INT" -gt 60 ]; then
        echo "Setting CPU limit to 30%"
        echo "30000 100000" | sudo tee $CGROUP/cpu.max > /dev/null
    fi

    sleep 2
done
