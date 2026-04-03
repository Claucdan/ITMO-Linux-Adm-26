#!/bin/bash

BASE=~/overlay_31
UPPER=$BASE/upper
LOWER=$BASE/lower
MERGED=$BASE/merged
LOG=~/overlay_31/31_audit.log

echo "OverlayFS audit report" > $LOG
echo "======================" >> $LOG

echo "Whiteout files:" >> $LOG
find $UPPER -name ".*" >> $LOG

echo "" >> $LOG
echo "Differences between lower and merged:" >> $LOG
diff -r $LOWER $MERGED >> $LOG

echo "Report saved to $LOG"
