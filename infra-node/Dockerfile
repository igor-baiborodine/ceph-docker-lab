FROM centos:7

ARG CEPH_LAB_ADMIN_PWD=abc123
ENV container docker

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;

# https://docs.ceph.com/docs/master/start/quick-start-preflight/
RUN set -ex; \
    yum -y update; \
    yum install -y \
        which \
        sudo \
        lvm2 \
        iproute \
        openssh-server \
        chrony; \
    yum clean all; \
    useradd ceph-lab-admin; \
    echo "ceph-lab-admin:$CEPH_LAB_ADMIN_PWD" | chpasswd; \
    echo "ceph-lab-admin ALL = (root) NOPASSWD:ALL" > /etc/sudoers.d/ceph-lab-admin; \
    chmod 0440 /etc/sudoers.d/ceph-lab-admin

#https://serverfault.com/a/804655
RUN set -ex; \
    sed -i 's/udev_sync = 1/udev_sync = 0/' /etc/lvm/lvm.conf; \
    sed -i 's/udev_rules = 1/udev_rules = 0/' /etc/lvm/lvm.conf; \
    cat /etc/lvm/lvm.conf | grep 'udev_'

VOLUME ["/sys/fs/cgroup"]

CMD ["/usr/sbin/init"]
