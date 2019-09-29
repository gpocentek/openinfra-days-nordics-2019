# Overcloud deployment

## All in one

To deploy tthe overcloud with a single command use:

```console
$ cd ~/overcloud
$ ./deploy.sh
```

The process is long, it is a good idea to run it in a screen or tmux session.

## Split deployment

It is also possible to run the deployment in multiple steps:

1. Run the stack deployment. This will take care of configuration creation and baremetal nodes deployment:

   ```console
   $ ./deploy.sh --stack-only
   ```

   Once the stack has been deployed you can access the overcloud nodes:

   ```console
   $ openstack server list
   $ ssh heat-admin@NODE_IP
   ```

2. Get the ansible playbook used for application deployment and generate an inventory:

   ```console
   $ openstack overcloud config download  --name overcloud --config-dir config-download
   $ tripleo-ansible-inventory --ansible_ssh_user heat-admin --static-yaml-inventory config-download/inventory.yaml
   $ cat > config-download/ansible.cfg << EOF
   [defaults]
   inventory = ./inventory.yaml
   retry_files_enabled = False
   log_path = /home/stack/overcloud/config-download/ansible.log
   remote_user = heat-admin

   [ssh_connection]
   ssh_args = -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ControlMaster=auto -o ControlPersist=30m -o ServerAliveInterval=5 -o ServerAliveCountMax=5
   pipelining = True
   EOF

3. Run the application playbook:

   ```console
   $ cd config-download
   $ ansible-playbook -b -i inventory.yaml deploy_steps_playbook.yaml

In our setup we also need to add a route to reach the External network from the undercloud:

```console
$ sudo ip link add link eth2 name vlan815 type vlan id 815
$ sudo ip addr add dev vlan815 10.8.15.9/24
$ sudo ip link set vlan815 up
```

We can now use the overcloud OpenStack:

```console
$ . ./overcloudrc
$ openstack service list
$ openstack hypervisor list
$ openstack network agent list
```