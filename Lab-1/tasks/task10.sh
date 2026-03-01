#!/bin/bash

getent group g1 | cut -d: -f4 | tr ',' '\n' | paste -sd "," - >> $1
