#!/bin/bash
set -ex

disk=$1

sudo pvcreate "$disk"
sudo vgcreate vgceph "$disk"
sudo pvs

# monitor
sudo lvcreate -y -L 10G -n lvmon1 vgceph
sudo lvcreate -y -L 10G -n lvmon2 vgceph
sudo lvcreate -y -L 10G -n lvmon3 vgceph

sudo mkfs.xfs /dev/vgceph/lvmon1
sudo mkfs.xfs /dev/vgceph/lvmon2
sudo mkfs.xfs /dev/vgceph/lvmon3

sudo mkdir -p /var/lib/{ceph-mon-1,ceph-mon-2,ceph-mon-3}

sudo mount /dev/vgceph/lvmon1 /var/lib/ceph-mon-1
sudo mount /dev/vgceph/lvmon2 /var/lib/ceph-mon-2
sudo mount /dev/vgceph/lvmon3 /var/lib/ceph-mon-3

# osd
sudo lvcreate -L 250G -n lvosd1 vgceph
sudo lvcreate -L 250G -n lvosd2 vgceph
sudo lvcreate -L 250G -n lvosd3 vgceph

lsblk -I 8
