FROM centos:7

# https://docs.ceph.com/docs/master/start/quick-start-preflight/
RUN set -ex; \
    yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

COPY /etc/yum.repos.d /etc/yum.repos.d
COPY /etc/opt/ceph/preflight /etc/opt/ceph/preflight

RUN set -ex; \
    yum -y update; \
    yum install -y iproute openssh-server openssh-clients ceph-deploy; \
    yum clean all; \
    useradd ceph-lab-admin

USER ceph-lab-admin

RUN cat /dev/zero | ssh-keygen -q -N ""

WORKDIR /home/ceph-lab-admin
