https://access.redhat.com/documentation/en-us/red_hat_ceph_storage/3/html/installation_guide_for_red_hat_enterprise_linux/manually-installing-red-hat-ceph-storage

re: devices - https://docs.docker.com/engine/reference/commandline/run/

ceph-deploy --cluster {cluster-name} new {host [host], ...}

TODO: 
* verify ntp sync
* lvm configuration for mon and osd nodes

|Node|VG|LV|Partition|Space(GB)|
|:-|:-|:-|:-|:-:|
|ceph-mon-1|vgceph|lvmon1|/var/lib/ceph-mon-1|10|
|ceph-mon-2|vgceph|lvmon2|/var/lib/ceph-mon-2|10|
|ceph-mon-3|vgceph|lvmon3|/var/lib/ceph-mon-3|10|
|ceph-osd-1|vgceph|lvosd1||250|
|ceph-osd-2|vgceph|lvosd2||250|
|ceph-osd-3|vgceph|lvosd2||250|

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
```bash
[ceph-lab-admin@ceph-admin cluster]$ lsblk -I 8
sdc               8:32   0 931.5G  0 disk 
├─vgceph-lvmon1 253:0    0    10G  0 lvm  /var/lib/ceph-mon-1
├─vgceph-lvmon2 253:1    0    10G  0 lvm  /var/lib/ceph-mon-2
├─vgceph-lvmon3 253:2    0    10G  0 lvm  /var/lib/ceph-mon-3
├─vgceph-lvosd1 253:3    0   250G  0 lvm  
├─vgceph-lvosd2 253:4    0   250G  0 lvm  
└─vgceph-lvosd3 253:5    0   250G  0 lvm  
```

OSD: zap device
```bash
[ceph-lab-admin@ceph-admin lab-cluster]$ ssh ceph-osd-1

[ceph-lab-admin@ceph-osd-1 ~]$ udevadm info --query=property /dev/sdc
<...>
[ceph-lab-admin@ceph-osd-1 ~]$ sudo systemctl stop ceph\*.service ceph\*.target && sudo ceph-volume lvm zap /dev/sdc --destroy
[ceph-lab-admin@ceph-osd-1 ~]$ sudo ceph-volume lvm zap /dev/sdc --destroy
--> Zapping: /dev/sdc
Running command: /bin/dd if=/dev/zero of=/dev/sdc bs=1M count=10
 stderr: 10+0 records in
10+0 records out
10485760 bytes (10 MB) copied
 stderr: , 0.201899 s, 51.9 MB/s
--> Zapping successful for: <Raw Device: /dev/sdc>

[ceph-lab-admin@ceph-osd-1 ~]$ sudo blkid /dev/sdc1
/dev/sdc1: PARTLABEL="primary" PARTUUID="477b63b8-bba1-40d4-92bf-7eaa63a44238" 
```
docker run -d --privileged=true -v /dev/:/dev/ -e OSD_DEVICE=/dev/sdc ceph/daemon zap_device

https://docs.ceph.com/docs/master/rados/operations/operating/

time sync with chrony:
https://www.linuxtechi.com/sync-time-in-linux-server-using-chrony/

Pools, placement groups
https://docs.ceph.com/docs/mimic/rados/operations/pools/
https://docs.ceph.com/docs/mimic/rados/operations/data-placement/

RGW
```bash
igor@tlpacr-2018:~/GitRepos/ceph-docker-lab$ curl http://localhost:80 | xmllint --format -
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   214    0   214    0     0  53500      0 --:--:-- --:--:-- --:--:-- 71333
<?xml version="1.0" encoding="UTF-8"?>
<ListAllMyBucketsResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
  <Owner>
    <ID>anonymous</ID>
    <DisplayName/>
  </Owner>
  <Buckets/>
</ListAllMyBucketsResult>
```

```bash
[ceph-lab-admin@ceph-rgw-0 ~]$ sudo radosgw-admin user create --uid="igor" --display-name="Igor"
{
    "user_id": "igor",
    "display_name": "Igor",
    "email": "",
    "suspended": 0,
    "max_buckets": 1000,
    "auid": 0,
    "subusers": [],
    "keys": [
        {
            "user": "igor",
            "access_key": "ZADNRUAEAB2VM4UAUF4R",
            "secret_key": "ffzwkpCuKKYpnJ0YjPG4JDvit09LVxI5iDmTyRvZ"
        }
    ],
    "swift_keys": [],
    "caps": [],
    "op_mask": "read, write, delete",
    "default_placement": "",
    "placement_tags": [],
    "bucket_quota": {
        "enabled": false,
        "check_on_raw": false,
        "max_size": -1,
        "max_size_kb": 0,
        "max_objects": -1
    },
    "user_quota": {
        "enabled": false,
        "check_on_raw": false,
        "max_size": -1,
        "max_size_kb": 0,
        "max_objects": -1
    },
    "temp_url_keys": [],
    "type": "rgw",
    "mfa_ids": []
}
```


```bash
sudo apt install -y s3cmd
```

Manager
```bash
[ceph-lab-admin@ceph-mgr-0 ~]$ sudo ceph mgr module enable dashboard
[ceph-lab-admin@ceph-mgr-0 ~]$ sudo ceph mgr module ls
{
    "enabled_modules": [
        "balancer",
        "crash",
        "dashboard",
        "iostat",
        "restful",
        "status"
    ],
```

