FROM centos:7

ARG CEPH_LAB_ADMIN_PWD=abc123

# https://docs.ceph.com/docs/master/start/quick-start-preflight/
COPY ceph.repo /etc/yum.repos.d

RUN set -ex; \
    yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm; \
    yum -y update; \
    yum install -y sudo nc iproute openssh-server openssh-clients ceph-deploy python-setuptools; \
    yum clean all; \
    useradd ceph-lab-admin; \
    echo "ceph-lab-admin:$CEPH_LAB_ADMIN_PWD" | chpasswd; \
    echo "ceph-lab-admin ALL = (root) NOPASSWD:ALL" > /etc/sudoers.d/ceph-lab-admin; \
    mkdir /home/ceph-lab-admin/lab-cluster

COPY config /home/ceph-lab-admin/.ssh/config
COPY ceph-infra-ssh-config.sh /home/ceph-lab-admin

RUN chown -R ceph-lab-admin:ceph-lab-admin /home/ceph-lab-admin; \
    chmod 600 /home/ceph-lab-admin/.ssh/config

USER ceph-lab-admin

RUN cat /dev/zero | ssh-keygen -q -N ""

WORKDIR /home/ceph-lab-admin/lab-cluster
