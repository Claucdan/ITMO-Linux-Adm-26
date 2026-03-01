#!/bin/bash

cut -d: -f1,3 /etc/passwd | while IFS=: read u id
do
  echo "user $u has id $id" >> $1
done
