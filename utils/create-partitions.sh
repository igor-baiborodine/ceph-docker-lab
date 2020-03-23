#!/bin/bash
set -ex

disk=$1

#sudo parted --script "$disk" mklabel gpt mkpart primary 1MiB 200GiB

sudo parted --script "$disk" \
    mklabel gpt \
    mkpart primary   1MiB 250GiB \
    mkpart primary 250GiB 500GiB \
    mkpart primary 500GiB 750GiB \
#    mkpart primary 750GiB 900GiB \
    print
