# Overcloud network

## Networks used in the workshop

* ctlplane: 192.168.24.0/24

  Used to communicate with the undercloud. All the overcloud nodes are connected to this network with a dedicated interface.

* External: 10.8.15.0/24, VLAN 815

  Used to expose the OpenStack APIs to the outside world. Only needed on the controller nodes.

* InternalApi: 172.16.1.0/24, VLAN 161

  Used for all the internal OpenStack communication: APIs, database, message queue, cache services, and so on.

* Tenant: 172.16.2.0/24, VLAN 162

  Used as an encapsulation layer for instance to instance communication.

The external, internalApi and tenant networks will be hosted on the same interface, with VLAN segmentation.

## Global network data file

The information about these networks must be defined in a yaml file: `network_data.yaml`.

## Network configuration for hosts

How the network is configured on hosts depends on the role, and on the available hardware.

Each TripleO Role will have an associated NIC configuration, provided as a Heat template. Writting these files is not easy, and understanding the underlying tool is often necessary.

TripleO uses `os-net-config`to configure the network. The host configuration needs to be written in s json or yaml specific format. Example:

```json
{
  "network_config": [
    {
      "addresses": [
        {
          "ip_netmask": "192.168.24.25/24"
        }
      ],
      "dns_servers": [
        "8.8.8.8"
      ],
      "domain": [],
      "mtu": 1500,
      "name": "nic1",
      "routes": [
        {
          "destination": "169.254.169.254/32",
          "nexthop": "192.168.24.12"
        },
        {
          "default": true,
          "next_hop": "192.168.24.1"
        }
      ],
      "type": "interface",
      "use_dhcp": false
    },
    {
      "dns_servers": [
        "8.8.8.8"
      ],
      "members": [
        {
          "name": "nic2",
          "type": "interface"
        },
        {
          "addresses": [
            {
              "ip_netmask": "10.8.15.68/24"
            }
          ],
          "mtu": 1500,
          "type": "vlan",
          "vlan_id": 815
        },
        {
          "addresses": [
            {
              "ip_netmask": "172.16.1.99/24"
            }
          ],
          "mtu": 1500,
          "type": "vlan",
          "vlan_id": 161
        },
        {
          "addresses": [
            {
              "ip_netmask": "172.16.2.116/24"
            }
          ],
          "mtu": 1500,
          "type": "vlan",
          "vlan_id": 162
        }
      ],
      "name": "br-ex",
      "type": "ovs_bridge",
      "use_dhcp": false
    }
  ]
}
```

The json data must be "templatized" to let TripleO generate the appropriate configuration for each host:

```console
$ cat nic-configs/controller.yaml
$ cat nic-configs/compute.yaml
```

The nic-config templates are associated with roles in `local_config.yaml` using Heat resource registry settings:

```yaml
resource_registry:
  OS::TripleO::Controller::Net::SoftwareConfig: nic-configs/controller.yaml
  OS::TripleO::Compute::Net::SoftwareConfig: nic-configs/compute.yaml
```