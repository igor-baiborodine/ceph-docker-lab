#!/bin/bash
set -ex

for hostname in "$@"
do
    ssh-keyscan "$hostname" >> /home/ceph-lab-admin/.ssh/known_hosts
    ssh-copy-id -f ceph-lab-admin@"$hostname"
done