#!/bin/bash

echo root:TripleOpenInfra | chpasswd
sed -i 's/^PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl restart sshd

systemctl stop firewalld
systemctl disable firewalld
setenforce 0

yum clean all
yum install -y libvirt libvirt-daemon-kvm virt-install vim wget centos-release-openstack-stein screen
yum install -y python2-virtualbmc
systemctl enable libvirtd
systemctl start libvirtd

# libvirt resources
for i in overcloud deploy; do
    virsh net-define $i.xml
    virsh net-autostart $i
    virsh net-start $i
done

#wget .../undercloud.qcow2 -O /var/lib/libvirt/images/undercloud.qcow2
if [ -e undercloud.qcow2 ]; then
    cp undercloud.qcow2 /var/lib/libvirt/images/undercloud.qcow2
fi

for i in controller compute; do
    qemu-img create -f qcow2 /var/lib/libvirt/images/$i.qcow2 50G
done
virsh define undercloud.xml
virsh autostart undercloud
virsh start undercloud

for i in controller compute; do
    virsh define $i.xml
done
vbmc add --username tripleo --password tripleo --port 4001 controller
vbmc start controller
vbmc add --username tripleo --password tripleo --port 4002 compute
vbmc start compute

echo "undercloud: ssh root@192.168.122.10"
echo "password: TripleOpenInfra"
