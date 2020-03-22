#!/bin/bash
set -ex

for hostname in "$@"
do
    ssh-keyscan "$hostname" >> /home/ceph-lab-admin/.ssh/known_hosts
    ssh-copy-id ceph-lab-admin@"$hostname"
done