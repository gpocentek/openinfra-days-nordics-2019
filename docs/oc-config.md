# Overcloud configuration

Once the roles and networks are define, you need to chose which features to enable, and how they should be configure. This is done by including existing and custom Heat templates and configuration files.

Our only configuration is `local_config.yaml`. In includes a minimalist set of options to deploy an overcloud.

The `openstack overcloud deploy` command can be used to include additional templates and configuration files. The complete command to use for our deployment is:

```console
$ openstack overcloud deploy \
    --templates \
    -r roles_data.yaml \
    -n network_data.yaml \
    -e $TE/network-isolation.yaml \
    -e local_config.yaml
```

We use our roles and network definition files, and 2 templates:

* `local_config.yaml`
* the TripleO `network-isolation.yaml` template which enables our custom network setup.