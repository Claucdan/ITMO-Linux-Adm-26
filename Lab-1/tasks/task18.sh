#!/bin/bash

echo "u1 ALL=(root) /usr/bin/passwd" > /etc/sudoers.d/u1
chmod 440 /etc/sudoers.d/u1

