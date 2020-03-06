FROM centos:7

ARG CEPH_LAB_ADMIN_PWD=abc123

# https://docs.ceph.com/docs/master/start/quick-start-preflight/
COPY ceph.repo /etc/yum.repos.d

RUN set -ex; \
    yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm; \
    yum -y update; \
    yum install -y nc iproute openssh-server openssh-clients ceph-deploy; \
    yum clean all; \
    useradd ceph-lab-admin; \
    echo "ceph-lab-admin:$CEPH_LAB_ADMIN_PWD" | chpasswd

COPY config /home/ceph-lab-admin/.ssh/config

RUN chown -R ceph-lab-admin:ceph-lab-admin /home/ceph-lab-admin/.ssh; \
    chmod 600 /home/ceph-lab-admin/.ssh/config

USER ceph-lab-admin

COPY ceph-infra-ssh-config.sh /home/ceph-lab-admin

RUN cat /dev/zero | ssh-keygen -q -N ""

WORKDIR /home/ceph-lab-admin
