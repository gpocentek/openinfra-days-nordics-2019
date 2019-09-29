# Overcloud roles

The roles in TripleO can be entirely customized. Each role describes:

* Which networks should the hosts be connected to
* Naming and metadata to match hosts registered in Ironic
* A list of services to deploy

A set of roles are predefined in TripleO:

```console
$ . ~/stackrc
$ openstack overcloud roles list
$ openstack overcloud roles show ComputeHCI
```

We are going to use customized versions of the Controller and Compute roles:

```console
$ cd ~/overcloud
$ . ~/stackrc
$ openstack overcloud roles generate -o initial_roles_data.yaml Controller Compute
$ vi initial_roles_data.yaml 
```

We will rename a few parameters and remove services we don't plan to install. The resulting roles file is `roles_data.yaml`. You can check the changes with:

```console
$ diff -Naur initial_roles_data.yaml roles_data.yaml
```