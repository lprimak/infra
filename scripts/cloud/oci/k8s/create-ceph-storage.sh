#!/bin/bash -p

targetcli /backstores/fileio/ create ceph_storage /var/ceph_storage.img {{ ceph_storage_size_override }}
targetcli /loopback create {{ ceph_storage_id_override }}
targetcli /loopback/{{ ceph_storage_id_override }}/luns create /backstores/fileio/ceph_storage
targetcli saveconfig
