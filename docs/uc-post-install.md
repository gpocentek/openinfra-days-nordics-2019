# Undercloud - post installation steps

## Images

Ironic needs pre-built images to run the introspection process and to deploy a base operating system. The TripleO community povides images, but it is also possible to build your own, customiwed images: https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/deployment/install_overcloud.html#get-images

```console
$ . ~/stackrc
$ cd ~/images
$ tar xf ironic-python-agent.tar
$ tar xf overcloud-full.tar
$ ls -1
ironic-python-agent.initramfs
ironic-python-agent.kernel
ironic-python-agent.tar
overcloud-full.initrd
overcloud-full.qcow2
overcloud-full.tar
overcloud-full.vmlinuz
$ openstack overcloud image upload
```

Check the images using tthe Glance API:

```console
$ openstack image list
$ openstack image show overcloud-full
```

## Registering the overcloud nodes

Ironic also needs information about the available physical nodes:

* How to manage them
* What network interface should be used for deployment

Let's get the overcloud data:

```console
$ cd
$ git clone https://github.com/gpocentek/openinfra-days-nordics-2019.git
$ cp -R openinfra-days-nordics-2019/overcloud .
$ cd overcloud/
$ cat nodes.json
```

* The `capabilities` option defines the profile for each machine: this a mecanism used to manage different types of hardware and roles in TripleO
* The `pm_*` options define how Ironic should handle power management: we use IPMI
* The `mac`option defines a list of network interfaces that can be used for PXE boot

## Nodes introspection

We can register the nodes and introspect them with:

```console
$ openstack overcloud node import --introspect --provide nodes.json
```

To keep track of the progress you can use an SSH tunnel and a VNC client:

* ```console
  $ ssh centos@HOST_IP -L 5901:localhost:5901
  ```
* Connect to `localhost:5901` with your VNC client.

Let's have a look at the Ironic data:

```console
$ openstack baremetal node list
$ openstack baremetal node show <NODE_ID>
$ openstack baremetal port list
$ openstack baremetal introspection data save <NODE_ID> | jq . | less
```

## Flavors setup

Ironic uses metadata set on physical nodes and flavors to deploy the correct setup on machines.

In our setup the controller host has a `profile:controller` capability, but the `control` flavor doesn't have the same value. Let's update it:

```console
$ openstack flavor set control --property capabilities:profile='controller'
```

We are now ready to configure and deploy the Overcloud.