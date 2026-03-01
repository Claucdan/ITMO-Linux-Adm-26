#!/bin/bash

mkdir /home/test15
echo "secret" > /home/test15/secret_file
chmod 711 /home/test15
chmod 444 /home/test15/secret_file
