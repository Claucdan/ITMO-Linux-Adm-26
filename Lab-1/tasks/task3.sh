#!/bin/bash

cut -d: -f1 /etc/group | paste -sd "," - >> $1
