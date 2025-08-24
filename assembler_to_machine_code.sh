#!/bin/bash
# Convert MIPS 32bit assembler code to MIPS machine code.

> machine_code.txt
touch temp.txt

mipsel-linux-gnu-as Test.asm
mipsel-linux-gnu-objcopy -O binary --only-section=.text a.out a.out.text.bin
hexdump -v -e '/4 "%08x\n"' a.out.text.bin >> temp.txt
tac temp.txt | sed '/^00000000$/d' | tac >> machine_code.txt

rm temp.txt
rm a.out
rm a.out.text.bin
