#!/bin/bash

echo "=== Start cleanup ==="

if id u1 &>/dev/null; then
    userdel -r u1
    echo "User u1 deleted"
fi

if id u2 &>/dev/null; then
    userdel -r u2
    echo "User u2 deleted"
fi

if id myuser &>/dev/null; then
    userdel -r myuser
    echo "User myuser deleted"
fi

if getent group g1 &>/dev/null; then
    groupdel g1
    echo "Group g1 deleted"
fi

rm -rf /home/test13
rm -rf /home/test14
rm -rf /home/test15

echo "Dirs test13, test14, test15 deleted"

rm -f work3.log
rm -f /etc/skel/readme.txt
rm -f /etc/sudoers.d/u1

echo "Files work3.log, readme.txt and sudoers rool deleted"

echo "=== End cleanup ==="
