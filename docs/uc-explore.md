# Exploring the undercloud

## Containers

Since the Stein release the default container tool is **podman**. It's CLI is compatible with Docker:

```console
$ sudo podman container ls
$ sudo podman container restart heat_api
```

## Network configuration and tools

The deployment creates a `br-ctlplane` interface: it is an Open vSwitch bridge used by:

* OpenStack APIs
* PXE booting tools

```console
$ ip a
...
8: br-ctlplane: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether 52:54:00:5d:8b:79 brd ff:ff:ff:ff:ff:ff
    inet 192.168.24.10/24 brd 192.168.24.255 scope global br-ctlplane
       valid_lft forever preferred_lft forever
    inet 192.168.24.12/32 scope global br-ctlplane
       valid_lft forever preferred_lft forever
    inet 192.168.24.11/32 scope global br-ctlplane
```

A dnsmasq DHCP server configured for PXE boot is also deployed:

```console
$ ps aux | grep dnsmasq
```

## OpenStack APIs

You can use the `openstack` client to talk to the undercloud OpenStack:

```console
$ . ~/stackrc  # authentication
$ openstack service list  # list tthe avaiable APIs
```

A few resources are already defined:

```console
$ openstack network list  # control plane network
$ openstack subnet show <SUBNET_ID>
$ openstack flavor list  # we'll map these with overcloud roles
```

But we need to create more:

```console
$ openstack baremetal node list  # no physical host defined
$ openstack image list  # no deployment images available
```