#!/usr/bin/bash
nasm -f bin -o main.bin initial.asm && qemu-system-i386 -hda main.bin  
