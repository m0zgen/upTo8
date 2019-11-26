#!/bin/bash
# Author: Yevgeniy Goncharov aka xck, http://sys-adm.in
# Script update CentOS 7 to 8

# Update
yum update -y && yum -y install rpmconf yum-utils epel-release

# Resolve conflict packages
yum install rpmconf && rpmconf -a

# Clean
package-cleanup --leaves && package-cleanup --orphans

# Install dnf and clean yum
yum install dnf -y
dnf -y remove yum yum-metadata-parser && rm -Rf /etc/yum

# Upgrade and clean
dnf -y upgrade
dnf -y upgrade https://mirror.yandex.ru/centos/8/BaseOS/x86_64/os/Packages/centos-release-8.0-0.1905.0.9.el8.x86_64.rpm
dnf -y upgrade https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
dnf clean all && rpm -e $(rpm -q kernel) && rpm -e --nodeps sysvinit-tools
dnf -y --releasever=8 --allowerasing --setopt=deltarpm=false distro-sync
dnf -y install kernel-core && dnf -y groupupdate "Core" "Minimal Install"

# Final step :)
cat /etc/redhat-release