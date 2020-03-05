FROM centos:7

# https://docs.ceph.com/docs/master/start/quick-start-preflight/
RUN set -ex; \
    yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

COPY ceph.repo /etc/yum.repos.d

RUN set -ex; \
    yum -y update; \
    yum install -y iproute openssh-server openssh-clients ceph-deploy; \
    yum clean all; \
    useradd ceph-lab-admin

USER ceph-lab-admin

RUN cat /dev/zero | ssh-keygen -q -N ""
COPY ceph-infra-ssh-config.sh /home/ceph-lab-admin

WORKDIR /home/ceph-lab-admin
