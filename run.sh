#!/bin/sh
nasm -fbin pixl512.asm -o pixl.bin
used=$(wc -c < pixl.bin)
echo Used: $used
echo Remaining: $((512 - $used))
if [ $used==512 ]; then
    qemu-system-x86_64 -drive file=pixl.bin,format=raw
fi
