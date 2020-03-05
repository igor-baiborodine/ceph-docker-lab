#!/bin/bash
set -ex

for hostname in "$@"
do
    ssh-keyscan "$hostname" >> /home/ceph-lab-admin/.ssh/known_hosts
    ssh-copy-id ceph-lab-admin@"$hostname"
    {
      echo "Host $hostname";
      echo "    Hostname $hostname";
      echo "    User ceph-lab-admin"
    } >> /home/ceph-lab-admin/.ssh/config
done