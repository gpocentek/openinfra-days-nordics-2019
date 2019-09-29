#!/bin/bash

. /home/stack/stackrc

TE=/usr/share/openstack-tripleo-heat-templates/environments

time openstack overcloud deploy \
    --templates \
    -r roles_data.yaml \
    -n network_data.yaml \
    -e $TE/network-isolation.yaml \
    -e local_config.yaml \
    "$@"
