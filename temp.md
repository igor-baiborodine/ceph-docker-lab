https://access.redhat.com/documentation/en-us/red_hat_ceph_storage/3/html/installation_guide_for_red_hat_enterprise_linux/manually-installing-red-hat-ceph-storage

ceph-deploy --cluster {cluster-name} new {host [host], ...}

TODO: 
* verify ntp sync
* lvm configuration for mon and osd nodes

|Node|VG|LV|Partition|Space(GB)|
|:-|:-|:-|:-:|
|ceph-mon-1|vgmon|lvmon1|/var/lib/ceph-mon-1|50|
|ceph-mon-2|vgmon|lvmon2|/var/lib/ceph-mon-2|50|
|ceph-mon-3|vgmon|lvmon3|/var/lib/ceph-mon-3|50|
|ceph-osd-1|vgosd|lvosd1||300|
|ceph-osd-2|vgosd|lvosd2||300|
|ceph-osd-3|vgosd|lvosd2||300|

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
[ceph-lab-admin@ceph-admin cluster]$ ../ceph-infra-ssh-config.sh ceph-mon-1
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
```bash
[ceph-lab-admin@ceph-admin cluster]$ ceph-deploy new ceph-mon-1
[ceph_deploy.conf][DEBUG ] found configuration file at: /home/ceph-lab-admin/.cephdeploy.conf
[ceph_deploy.cli][INFO  ] Invoked (2.0.1): /usr/bin/ceph-deploy new ceph-mon-1
[ceph_deploy.cli][INFO  ] ceph-deploy options:
[ceph_deploy.cli][INFO  ]  username                      : None
[ceph_deploy.cli][INFO  ]  func                          : <function new at 0x7fbf83086d70>
[ceph_deploy.cli][INFO  ]  verbose                       : False
[ceph_deploy.cli][INFO  ]  overwrite_conf                : False
[ceph_deploy.cli][INFO  ]  quiet                         : False
[ceph_deploy.cli][INFO  ]  cd_conf                       : <ceph_deploy.conf.cephdeploy.Conf instance at 0x7fbf828003f8>
[ceph_deploy.cli][INFO  ]  cluster                       : ceph
[ceph_deploy.cli][INFO  ]  ssh_copykey                   : True
[ceph_deploy.cli][INFO  ]  mon                           : ['ceph-mon-1']
[ceph_deploy.cli][INFO  ]  public_network                : None
[ceph_deploy.cli][INFO  ]  ceph_conf                     : None
[ceph_deploy.cli][INFO  ]  cluster_network               : None
[ceph_deploy.cli][INFO  ]  default_release               : False
[ceph_deploy.cli][INFO  ]  fsid                          : None
[ceph_deploy.new][DEBUG ] Creating new cluster named ceph
[ceph_deploy.new][INFO  ] making sure passwordless SSH succeeds
[ceph-mon-1][DEBUG ] connected to host: ceph-admin 
[ceph-mon-1][INFO  ] Running command: ssh -CT -o BatchMode=yes ceph-mon-1
[ceph-mon-1][DEBUG ] connection detected need for sudo
[ceph-mon-1][DEBUG ] connected to host: ceph-mon-1 
[ceph-mon-1][DEBUG ] detect platform information from remote host
[ceph-mon-1][DEBUG ] detect machine type
[ceph-mon-1][DEBUG ] find the location of an executable
[ceph-mon-1][INFO  ] Running command: sudo /usr/sbin/ip link show
[ceph-mon-1][INFO  ] Running command: sudo /usr/sbin/ip addr show
[ceph-mon-1][DEBUG ] IP addresses found: [u'172.24.0.2']
[ceph_deploy.new][DEBUG ] Resolving host ceph-mon-1
[ceph_deploy.new][DEBUG ] Monitor ceph-mon-1 at 172.24.0.2
[ceph_deploy.new][DEBUG ] Monitor initial members are ['ceph-mon-1']
[ceph_deploy.new][DEBUG ] Monitor addrs are ['172.24.0.2']
[ceph_deploy.new][DEBUG ] Creating a random mon key...
[ceph_deploy.new][DEBUG ] Writing monitor keyring to ceph.mon.keyring...
[ceph_deploy.new][DEBUG ] Writing initial config to ceph.conf...
[ceph-lab-admin@ceph-admin cluster]$ 
```
```bash
[ceph-lab-admin@ceph-admin cluster]$ cat ceph.conf
[global]
fsid = b7cadf89-5399-4f15-af01-14776ad37d35
mon_initial_members = ceph-mon-1
mon_host = 172.24.0.2
auth_cluster_required = cephx
auth_service_required = cephx
auth_client_required = cephx
```




