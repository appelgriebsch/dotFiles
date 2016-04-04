#!/bin/bash
# config
SD_DIR=/Volumes/Data/
FILENAME=file_speed_test.deleteme
SIZE=100 # in MB (mac os x)
#
#create large file first
echo "creating file"
mkfile 100m $TMPDIR$FILENAME
echo "done creating file"
#
# measure time at the beginning
echo "Starting to WRITE to SD"
START=$(date +%s)
cp $TMPDIR$FILENAME $SD_DIR
END=$(date +%s)
#
#calculate diff
DIFFw=$(( $END - $START ))
SPEEDw=$(echo $SIZE/$DIFFw | bc -l)
echo "It took $DIFFw seconds to write"
#
# delete file 
rm $TMPDIR$FILENAME
#
# read speed
echo "Starting to READ from SD"
START=$(date +%s)
cp $SD_DIR$FILENAME $TMPDIR
END=$(date +%s)
rm $TMPDIR$FILENAME
rm $SD_DIR/$FILENAME
#
#calculate diff
DIFFr=$(( $END - $START ))
SPEEDr=$(echo $SIZE/$DIFFr | bc -l)
echo "It took $DIFFr seconds to read"
#
echo "---------- RESULTS ------------"
echo "It took $DIFFw seconds to write $SIZE MB --> WRITE Speed: $SPEEDw MB/s"
echo "It took $DIFFr seconds to read $SIZE MB  --> READ  Speed: $SPEEDr MB/s"
#
#
