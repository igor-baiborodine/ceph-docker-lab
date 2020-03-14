#!/bin/bash
set -ex

disk=$1

sudo umount /dev/vgceph/lvmon1
sudo umount /dev/vgceph/lvmon2
sudo umount /dev/vgceph/lvmon3

sudo lvremove -y /dev/vgceph/lvmon1
sudo lvremove -y /dev/vgceph/lvmon2
sudo lvremove -y /dev/vgceph/lvmon3

sudo lvremove -y /dev/vgceph/lvosd1
sudo lvremove -y /dev/vgceph/lvosd2
sudo lvremove -y /dev/vgceph/lvosd3

sudo vgremove -y vgceph
sudo pvremove -y "$disk"

sudo dd if=/dev/zero of="$disk" bs=512 count=1

lsblk -I 8
