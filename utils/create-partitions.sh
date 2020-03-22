#!/bin/bash
set -ex

disk=$1

#sudo parted --script "$disk" mklabel gpt mkpart primary 1MiB 200GiB

sudo parted --script "$disk" \
    mklabel gpt \
    mkpart primary   1MiB 200GiB \
    mkpart primary 200GiB 400GiB \
    mkpart primary 400GiB 600GiB \
    mkpart primary 600GiB 800GiB \
    print
