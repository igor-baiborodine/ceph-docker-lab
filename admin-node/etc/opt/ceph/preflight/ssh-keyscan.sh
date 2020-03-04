#!/bin/bash
set -e

for hostname in "$@"
do
    ssh-keyscan "$hostname" >> ~/.ssh/known_hosts
done