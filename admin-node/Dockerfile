FROM centos:7

# reference: https://docs.ceph.com/docs/master/start/quick-start-preflight/
RUN set -ex; \
    yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

COPY ceph.repo /etc/yum.repos.d

RUN set -ex; \
    yum -y update; \
    yum install -y which iproute nmcli openssh-server ceph-deploy; \
    useradd ceph-lab-admin

USER ceph-lab-admin

RUN cat /dev/zero | ssh-keygen -q -N ""
