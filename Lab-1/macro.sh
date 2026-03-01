#!/bin/bash

LOG=work3.log
for i in {1..18}; do
    echo "=== Task $i ==="
    ./tasks/task$i.sh $LOG
done
