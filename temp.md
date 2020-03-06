```bash
cd admin-node
docker build --rm -t ceph-admin-node .
```

```bash
cd infra-node
docker build --rm -t ceph-infra-node .
```

```bash
docker-compose up -d ceph-admin
docker-compose up -d ceph-mon-1
```

```bash
docker exec -it ceph-admin bash
```

```bash
[ceph-lab-admin@ceph-admin ~]$ ./ceph-infra-ssh-config.sh ceph-mon-1
+ for hostname in '"$@"'
+ ssh-keyscan ceph-mon-1
# ceph-mon-1:22 SSH-2.0-OpenSSH_7.4
# ceph-mon-1:22 SSH-2.0-OpenSSH_7.4
# ceph-mon-1:22 SSH-2.0-OpenSSH_7.4
+ ssh-copy-id ceph-lab-admin@ceph-mon-1
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/ceph-lab-admin/.ssh/id_rsa.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
ceph-lab-admin@ceph-mon-1's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'ceph-lab-admin@ceph-mon-1'"
and check to make sure that only the key(s) you wanted were added.

[ceph-lab-admin@ceph-admin ~]$ ssh ceph-mon-1
[ceph-lab-admin@ceph-mon-1 ~]$ ip addr | grep inet
    inet 127.0.0.1/8 scope host lo
    inet 172.21.0.2/16 brd 172.21.255.255 scope global eth0
[ceph-lab-admin@ceph-mon-1 ~]$ exit
logout
Connection to ceph-mon-1 closed.
```






