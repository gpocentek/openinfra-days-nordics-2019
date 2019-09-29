# Initial workshop setup

SSH to the host and run the install script:

```console
ssh centos@HOST_IP  # password is TripleOpenInfra
ls
sudo ./install.sh
````

The installation script does the following:

* Disables firewalld and selinux to make our life easier
* Installs KVM and libvirt
* Creates virtual networks and VMs. You can check with the following commands:

  ```console
  $ sudo virsh list --all
  $ sudo virsh net-list
  ```

* Configures virtualBMC:

  ```console
  $ sudo vbmc list
  ```

You can now SSH to the undercloud:

```console
$ ssh root@192.168.122.10  # password TripleOpenInfra
$ exit
```

To make things easier let's create an SSH key and a bit of configuration on the host:

```console
$ ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
$ ssh-copy-id root@192.168.122.10
$ cat > ~/.ssh/config << EOF
Host uc
  Hostname 192.168.122.10
  User root
EOF
$ chmod 600 ~/.ssh/config
$ ssh uc
# su - stack
$ ls
```