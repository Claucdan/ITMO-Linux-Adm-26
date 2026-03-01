#!/bin/bash

id myuser &>/dev/null || useradd -m myuser
usermod -aG g1 myuser
