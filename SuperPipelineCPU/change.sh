#!/bin/bash


./assembler/assembler.exe < ./assembler/opcode.txt > ./assembler/opcode.result

im_vhd_path="./im.vhd"


pos=$(cat "$im_vhd_path"|grep -nE '(^architecture|^--end architecture)'|awk -F: '{print $1}'|xargs)

line=$(cat $im_vhd_path|wc -l)

top=$(echo $pos|awk '{print $1}')
under=$((line-$(echo $pos|awk '{print $2}')+1))

touch tmp.im.vhd

head -n$top $im_vhd_path > tmp.im.vhd
cat ./assembler/opcode.result >> tmp.im.vhd
tail -n$under $im_vhd_path >> tmp.im.vhd

cat < tmp.im.vhd > $im_vhd_path
rm tmp.im.vhd