## Host environment
* Ubuntu 18.04.4 LTS
* Docker version 19.03.8
* 1TB USB-based external drive(spinner)
* 3 disk partitions 250G each

```bash
~$ lsblk -I 8
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sdc      8:32   0 931.5G  0 disk 
├─sdc1   8:33   0   250G  0 part 
├─sdc2   8:34   0   250G  0 part 
└─sdc3   8:35   0   250G  0 part 
```

## Docker images
CentOS-based:
* ceph-admin-node: admin node
* ceph-infra-node(systemd enabled): monitor, manager, OSD and RADOS gateway nodes

## Cluster configuration
TODO: diagram 

## Preflight checklist & Ceph node setup
Refs:
* https://docs.ceph.com/docs/mimic/start/quick-start-preflight/
* https://docs.ceph.com/docs/mimic/start/quick-start-preflight/#ceph-node-setup

TODO: 
* map preflight checklist requirements & initial setup steps to implemented Dockerfile and docker-compose files
* elaborate on Docker networking

## Clone repository and build Docker images
```bash
~/GitRepos$ git clone https://github.com/igor-baiborodine/ceph-docker-lab.git
~/GitRepos$ cd ceph-docker-lab
~/GitRepos/ceph-docker-lab$ docker build --rm -t ceph-admin-node admin-node
~/GitRepos/ceph-docker-lab$ docker build --rm -t ceph-infra-node infra-node
~/GitRepos/ceph-docker-lab$ docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
ceph-infra-node     latest              0e799d02e962        4 days ago          307MB
ceph-admin-node     latest              ee9ca9ec556d        4 days ago          304MB
```

TODO: define network in docker-compose(ceph-public-network)
## Create cluster
```bash

```
