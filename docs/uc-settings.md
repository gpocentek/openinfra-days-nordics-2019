# Overview of undercloud.conf

The configuration file for the undercloud mostly defines:

* the network configuration
* the features to enable/disable

All the options are documented in the sample configuration file.

## Some options to consider

* `[DEFAULT]/debug`: True by default, generates a lot of logs; consider switching to False
* `[DEFAULT]/container_insecure_registries`: Use this option if you plan to use an http-only self-hosted container registry
* `[DEFAULT]/enable_node_discovery`: The undercloud can discover available physical nodes using IPMI and IP ranges. Be careful with this option, it can lead to serious problems if your IPMI network and authentication is not dedicated to TripleO.
* `[DEFAULT]/hieradata_override`: Can be used to define custom puppet settings for the undercloud deployment
* `[DEFAULT]/undercloud_enable_selinux`: Whether SELinux should be enabled on the undercloud (default: True)

## Network options

* `[DEFAULT]/local_interface`: The host interface used to configure the deployment network
* `[DEFAULT]/local_ip`: CIDR for the deployment interface IP configuration
* `[DEFAULT]/undercloud_admin_host`: Virtual IP that will be set on the local IP when using SSL endpoints
* `[DEFAULT]/undercloud_public_host`: Virtual IP that will be set on the local IP when using SSL endpoints

The deployment subnet must be named with the `[DEFAULT]/local_subnet`option, and defined in a `[<SUBNET_NAME>]`section. For the workshop:

```ini
[DEFAULT]
local_subnet = ctlplane-subnet

[ctlplane-subnet]
cidr = 192.168.24.0/24
dhcp_start = 192.168.24.20
dhcp_end = 192.168.24.30
gateway = 192.168.24.1
inspection_iprange = 192.168.24.100,192.168.24.120
```