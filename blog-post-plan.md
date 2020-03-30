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

## Cluster configuration, the Docker way
**TODO**: diagram and write-up

## Preflight checklist & Ceph node setup
Refs:
* https://docs.ceph.com/docs/mimic/start/quick-start-preflight/
* https://docs.ceph.com/docs/mimic/start/quick-start-preflight/#ceph-node-setup

**TODO**: write-up 
* map preflight checklist requirements & initial setup steps to implemented Dockerfile and docker-compose files
* elaborate on Docker networks and networking in Compose:
    * https://docs.docker.com/config/containers/container-networking/
    * https://docs.docker.com/compose/networking/

## Clone repository and build Docker images
**TODO**: write-up
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

### Create cluster 
Refs:
* https://docs.ceph.com/docs/mimic/start/quick-ceph-deploy/#

**TODO**: write-up

### Monitors
```bash
~/GitRepos/ceph-docker-lab$ docker-compose up -d ceph-admin ceph-mon-0 ceph-mon-1 ceph-mon-2
Creating network "ceph-docker-lab_default" with the default driver
Creating ceph-admin ... done
Creating ceph-mon-2 ... done
Creating ceph-mon-1 ... done
Creating ceph-mon-0 ... done
```
```bash
~/GitRepos/ceph-docker-lab$ docker exec -it ceph-admin bash
```
Check if a monitor container is reachable
```bash
[ceph-lab-admin@ceph-admin lab-cluster]$ ping ceph-mon-0
PING ceph-mon-0 (172.24.0.4) 56(84) bytes of data.
64 bytes from ceph-mon-0.ceph-docker-lab_default (172.24.0.4): icmp_seq=1 ttl=64 time=0.068 ms
```
SSH config
```bash
[ceph-lab-admin@ceph-admin lab-cluster]$ ../infra-node-ssh-config.sh ceph-mon-0 ceph-mon-1 ceph-mon-2
+ for hostname in '"$@"'
+ ssh-keyscan ceph-mon-0
# ceph-mon-0:22 SSH-2.0-OpenSSH_7.4
# ceph-mon-0:22 SSH-2.0-OpenSSH_7.4
# ceph-mon-0:22 SSH-2.0-OpenSSH_7.4
+ ssh-copy-id ceph-lab-admin@ceph-mon-0
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/ceph-lab-admin/.ssh/id_rsa.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
ceph-lab-admin@ceph-mon-0's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'ceph-lab-admin@ceph-mon-0'"
and check to make sure that only the key(s) you wanted were added.
```
```bash
[ceph-lab-admin@ceph-admin lab-cluster]$ ssh ceph-mon-0
[ceph-lab-admin@ceph-mon-0 ~]$ ip addr | grep inet
    inet 127.0.0.1/8 scope host lo
    inet 172.24.0.4/16 brd 172.24.255.255 scope global eth0
[ceph-lab-admin@ceph-mon-0 ~]$ exit
logout
Connection to ceph-mon-0 closed.
```
```bash
[ceph-lab-admin@ceph-admin lab-cluster]$ ceph-deploy new ceph-mon-0 ceph-mon-1 ceph-mon-2
[ceph_deploy.conf][DEBUG ] found configuration file at: /home/ceph-lab-admin/.cephdeploy.conf
[ceph_deploy.cli][INFO  ] Invoked (2.0.1): /usr/bin/ceph-deploy new ceph-mon-0 ceph-mon-1 ceph-mon-2
[ceph_deploy.cli][INFO  ] ceph-deploy options:
[ceph_deploy.cli][INFO  ]  username                      : None
[ceph_deploy.cli][INFO  ]  func                          : <function new at 0x7f5fa2663d70>
[ceph_deploy.cli][INFO  ]  verbose                       : False
[ceph_deploy.cli][INFO  ]  overwrite_conf                : False
[ceph_deploy.cli][INFO  ]  quiet                         : False
[ceph_deploy.cli][INFO  ]  cd_conf                       : <ceph_deploy.conf.cephdeploy.Conf instance at 0x7f5fa1ddd3f8>
[ceph_deploy.cli][INFO  ]  cluster                       : ceph
[ceph_deploy.cli][INFO  ]  ssh_copykey                   : True
[ceph_deploy.cli][INFO  ]  mon                           : ['ceph-mon-0', 'ceph-mon-1', 'ceph-mon-2']
[ceph_deploy.cli][INFO  ]  public_network                : None
[ceph_deploy.cli][INFO  ]  ceph_conf                     : None
[ceph_deploy.cli][INFO  ]  cluster_network               : None
[ceph_deploy.cli][INFO  ]  default_release               : False
[ceph_deploy.cli][INFO  ]  fsid                          : None
[ceph_deploy.new][DEBUG ] Creating new cluster named ceph
[ceph_deploy.new][INFO  ] making sure passwordless SSH succeeds
[ceph-mon-0][DEBUG ] connected to host: ceph-admin 
[ceph-mon-0][INFO  ] Running command: ssh -CT -o BatchMode=yes ceph-mon-0
[ceph-mon-0][DEBUG ] connection detected need for sudo
[ceph-mon-0][DEBUG ] connected to host: ceph-mon-0 
[ceph-mon-0][DEBUG ] detect platform information from remote host
[ceph-mon-0][DEBUG ] detect machine type
[ceph-mon-0][DEBUG ] find the location of an executable
[ceph-mon-0][INFO  ] Running command: sudo /usr/sbin/ip link show
[ceph-mon-0][INFO  ] Running command: sudo /usr/sbin/ip addr show
[ceph-mon-0][DEBUG ] IP addresses found: [u'172.24.0.4']
[ceph_deploy.new][DEBUG ] Resolving host ceph-mon-0
[ceph_deploy.new][DEBUG ] Monitor ceph-mon-0 at 172.24.0.4
[ceph_deploy.new][INFO  ] making sure passwordless SSH succeeds
... output for ceph-mon-1 and ceph-mon-2
[ceph_deploy.new][DEBUG ] Monitor initial members are ['ceph-mon-0', 'ceph-mon-1', 'ceph-mon-2']
[ceph_deploy.new][DEBUG ] Monitor addrs are ['172.24.0.4', '172.24.0.3', '172.24.0.5']
[ceph_deploy.new][DEBUG ] Creating a random mon key...
[ceph_deploy.new][DEBUG ] Writing monitor keyring to ceph.mon.keyring...
[ceph_deploy.new][DEBUG ] Writing initial config to ceph.conf...
```
```bash
[ceph-lab-admin@ceph-admin lab-cluster]$ ls -al
total 16
-rw-rw-r-- 1 ceph-lab-admin ceph-lab-admin 5530 Mar 30 00:57 ceph-deploy-ceph.log
-rw-rw-r-- 1 ceph-lab-admin ceph-lab-admin  244 Mar 30 00:57 ceph.conf
-rw------- 1 ceph-lab-admin ceph-lab-admin   73 Mar 30 00:57 ceph.mon.keyring
[ceph-lab-admin@ceph-admin lab-cluster]$ cat ceph.conf
[global]
fsid = fce82e2f-ed75-4a7d-8f47-e96bb6c2174f
mon_initial_members = ceph-mon-0, ceph-mon-1, ceph-mon-2
mon_host = 172.24.0.4,172.24.0.3,172.24.0.5
auth_cluster_required = cephx
auth_service_required = cephx
auth_client_required = cephx
```
```bash
[ceph-lab-admin@ceph-admin lab-cluster]$ ceph-deploy deploy ceph-mon-0 ceph-mon-1 ceph-mon-2
```
```bash
[ceph-lab-admin@ceph-admin lab-cluster]$ ceph-deploy mon create-initial
[ceph-lab-admin@ceph-admin lab-cluster]$ ls
ceph-deploy-ceph.log        ceph.bootstrap-osd.keyring  ceph.conf
ceph.bootstrap-mds.keyring  ceph.bootstrap-rgw.keyring  ceph.mon.keyring
ceph.bootstrap-mgr.keyring  ceph.client.admin.keyring
```
```bash
[ceph-lab-admin@ceph-admin lab-cluster]$ ceph-deploy admin ceph-mon-0 ceph-mon-1 ceph-mon-2
[ceph-lab-admin@ceph-admin lab-cluster]$ ssh ceph-mon-0 sudo ceph -s
  cluster:
    id:     fce82e2f-ed75-4a7d-8f47-e96bb6c2174f
    health: HEALTH_OK
 
  services:
    mon: 3 daemons, quorum ceph-mon-1,ceph-mon-0,ceph-mon-2
    mgr: no daemons active
    osd: 0 osds: 0 up, 0 in
 
  data:
    pools:   0 pools, 0 pgs
    objects: 0  objects, 0 B
    usage:   0 B used, 0 B / 0 B avail
    pgs:     
```

### Manager
```bash
~/GitRepos/ceph-docker-lab$ docker-compose up -d ceph-mgr-0
Creating ceph-mgr-0 ... done
```
```bash
[ceph-lab-admin@ceph-admin lab-cluster]$ ../infra-node-ssh-config.sh ceph-mgr-0
[ceph-lab-admin@ceph-admin lab-cluster]$ ceph-deploy install ceph-mgr-0   
[ceph-lab-admin@ceph-admin lab-cluster]$ ceph-deploy admin ceph-mgr-0   
```
```bash
[ceph-lab-admin@ceph-admin lab-cluster]$ ssh ceph-mon-0 sudo ceph -s
  cluster:
    id:     fce82e2f-ed75-4a7d-8f47-e96bb6c2174f
    health: HEALTH_WARN
            OSD count 0 < osd_pool_default_size 3
 
  services:
    mon: 3 daemons, quorum ceph-mon-1,ceph-mon-0,ceph-mon-2
    mgr: ceph-mgr-0(active)
    osd: 0 osds: 0 up, 0 in
 
  data:
    pools:   0 pools, 0 pgs
    objects: 0  objects, 0 B
    usage:   0 B used, 0 B / 0 B avail
    pgs:     
```

### Dashboard
https://docs.ceph.com/docs/master/mgr/dashboard/
```bash
[ceph-lab-admin@ceph-admin lab-cluster]$ ssh ceph-mgr-0 sudo ceph mgr module enable dashboard
[ceph-lab-admin@ceph-admin lab-cluster]$ ssh ceph-mgr-0 sudo ceph mgr module ls           
{
    "enabled_modules": [
        "balancer",
        "crash",
        "dashboard",
        "iostat",
        "restful",
        "status"
    ],
    "disabled_modules": [
        {
            "name": "hello",
            "can_run": true,
            "error_string": ""
        },
    < more output >
    ]
}
```
```bash
[ceph-lab-admin@ceph-admin lab-cluster]$ ssh ceph-mgr-0 sudo ceph config set mgr mgr/dashboard/ssl false
[ceph-lab-admin@ceph-admin lab-cluster]$ ssh ceph-mgr-0 sudo ceph mgr services
{
    "dashboard": "http://ceph-mgr-0:8080/"
}
```
```bash
[ceph-lab-admin@ceph-admin lab-cluster]$ ssh ceph-mgr-0 sudo ceph dashboard set-login-credentials igor abc123
Username and password updated
```
Access the UI from the host at http://localhost:8080

**TODO**: elaborate on accessing from localhost:8080

Images:
* ceph-dashboard-login.png
* ceph-dashboard-main-view.png

### OSD

```bash
igor@tlpacr-2018:~/GitRepos/ceph-docker-lab$ docker-compose up -d ceph-osd-0 ceph-osd-1 ceph-osd-2
Creating ceph-osd-1 ... done
Creating ceph-osd-0 ... done
Creating ceph-osd-2 ... done
```
```bash
[ceph-lab-admin@ceph-admin lab-cluster]$ ../infra-node-ssh-config.sh ceph-osd-0 ceph-osd-1 ceph-osd-2
[ceph-lab-admin@ceph-admin lab-cluster]$ ceph-deploy install ceph-osd-0 ceph-osd-1 ceph-osd-2   
[ceph-lab-admin@ceph-admin lab-cluster]$ ceph-deploy admin ceph-osd-0 ceph-osd-1 ceph-osd-2   
```
```bash
[ceph-lab-admin@ceph-admin lab-cluster]$ ceph-deploy osd create --data /dev/sdc1 ceph-osd-0
[ceph_deploy.osd][DEBUG ] Host ceph-osd-0 is now ready for osd use.
[ceph-lab-admin@ceph-admin lab-cluster]$ ceph-deploy osd create --data /dev/sdc2 ceph-osd-1
[ceph_deploy.osd][DEBUG ] Host ceph-osd-1 is now ready for osd use.
[ceph-lab-admin@ceph-admin lab-cluster]$ ceph-deploy osd create --data /dev/sdc3 ceph-osd-2
[ceph_deploy.osd][DEBUG ] Host ceph-osd-2 is now ready for osd use.
```
Images:
* ceph-dashboard-with-osd.png

### RADOS Gateway(RGW)
```bash
igor@tlpacr-2018:~/GitRepos/ceph-docker-lab$ docker-compose up -d ceph-rgw-0 
Creating ceph-rgw-0 ... done
```
```bash
[ceph-lab-admin@ceph-admin lab-cluster]$ ../infra-node-ssh-config.sh ceph-rgw-0
[ceph-lab-admin@ceph-admin lab-cluster]$ ceph-deploy install ceph-rgw-0   
[ceph-lab-admin@ceph-admin lab-cluster]$ ceph-deploy admin ceph-rgw-0   
```
```bash
[ceph-lab-admin@ceph-admin lab-cluster]$ ceph-deploy rgw create ceph-rgw-0
```
Images:
* ceph-dashboard-with-rgw.png

https://docs.ceph.com/docs/master/mgr/dashboard/#enabling-the-object-gateway-management-frontend
```bash
[ceph-lab-admin@ceph-admin lab-cluster]$ ssh ceph-rgw-0 sudo radosgw-admin user create --uid=igor --display-name=Igor --system
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
            "access_key": "3EIRP6LE085KYW8Y224Y",
            "secret_key": "ut7hpdnTOUN1FEyqWDIzOoyRxaDfNhcgTQCShyUx"
        }
    ],
    "swift_keys": [],
    "caps": [],
    "op_mask": "read, write, delete",
    "system": "true",
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
[ceph-lab-admin@ceph-admin lab-cluster]$ ssh ceph-mgr-0 sudo ceph dashboard set-rgw-api-access-key 3EIRP6LE085KYW8Y224Y  
Option RGW_API_ACCESS_KEY updated
[ceph-lab-admin@ceph-admin lab-cluster]$ ssh ceph-mgr-0 sudo ceph dashboard set-rgw-api-secret-key ut7hpdnTOUN1FEyqWDIzOoyRxaDfNhcgTQCShyUx 
Option RGW_API_SECRET_KEY updated
```
Images:
* ceph-dashboard-rgw-daemons.png
* ceph-dashboard-rgw-users.png

**TODO**: elaborate on default pools, placement groups and CRASH maps

Check if the RGW instance is accessible from the host machine:
```bash
~/GitRepos/ceph-docker-lab$ curl http://localhost:80 | xmllint --format -
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

Install command line S3 client [s3cmd](https://s3tools.org/s3cmd)
```bash
~/GitRepos/ceph-docker-lab$ sudo apt install -y s3cmd
```

```bash
~/GitRepos/ceph-docker-lab$ s3cmd --configure -c s3-ceph-docker-lab.cfg
Enter new values or accept defaults in brackets with Enter.
Refer to user manual for detailed description of all options.

Access key and Secret key are your identifiers for Amazon S3. Leave them empty for using the env variables.
Access Key: 3EIRP6LE085KYW8Y224Y    
Secret Key: ut7hpdnTOUN1FEyqWDIzOoyRxaDfNhcgTQCShyUx
Default Region [US]: 

Use "s3.amazonaws.com" for S3 Endpoint and not modify it to the target Amazon S3.
S3 Endpoint [s3.amazonaws.com]: localhost:80

Use "%(bucket)s.s3.amazonaws.com" to the target Amazon S3. "%(bucket)s" and "%(location)s" vars can be used
if the target S3 system supports dns based buckets.
DNS-style bucket+hostname:port template for accessing a bucket [%(bucket)s.s3.amazonaws.com]: %(bucket)s.localhost:80

Encryption password is used to protect your files from reading
by unauthorized persons while in transfer to S3
Encryption password: 
Path to GPG program [/usr/bin/gpg]: 

When using secure HTTPS protocol all communication with Amazon S3
servers is protected from 3rd party eavesdropping. This method is
slower than plain HTTP, and can only be proxied with Python 2.7 or newer
Use HTTPS protocol [Yes]: No

On some networks all internet access must go through a HTTP proxy.
Try setting it here if you can't connect to S3 directly
HTTP Proxy server name: 

New settings:
  Access Key: 3EIRP6LE085KYW8Y224Y
  Secret Key: ut7hpdnTOUN1FEyqWDIzOoyRxaDfNhcgTQCShyUx
  Default Region: US
  S3 Endpoint: localhost:80
  DNS-style bucket+hostname:port template for accessing a bucket: %(bucket)s.localhost:80
  Encryption password: 
  Path to GPG program: /usr/bin/gpg
  Use HTTPS protocol: False
  HTTP Proxy server name: 
  HTTP Proxy server port: 0

Test access with supplied credentials? [Y/n] Y
Please wait, attempting to list all buckets...
Success. Your access key and secret key worked fine :-)

Now verifying that encryption works...
Not configured. Never mind.

Save settings? [y/N] y
Configuration saved to 's3-ceph-docker-lab.cfg'
```
Test bucket creation
```bash
igor@tlpacr-2018:~/GitRepos/ceph-docker-lab$ s3cmd -c s3-ceph-docker-lab.cfg mb s3://TEST_BUCKET
Bucket 's3://TEST_BUCKET/' created
```
Images:
* ceph-dashboard-s3-test-bucket.png

Upload a file to the test bucket
```bash
~/GitRepos/ceph-docker-lab$ s3cmd -c s3-ceph-docker-lab.cfg put README.md s3://TEST_BUCKET
upload: 'README.md' -> 's3://TEST_BUCKET/README.md'  [1 of 1]
 24 of 24   100% in    2s    10.84 B/s  done
~/GitRepos/ceph-docker-lab$ s3cmd -c s3-ceph-docker-lab.cfg la
2020-03-30 11:30        24   s3://TEST_BUCKET/README.md
```
