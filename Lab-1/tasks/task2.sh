#!/bin/bash

chage -l root | grep "Last password change" >> $1
