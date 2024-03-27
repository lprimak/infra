#!/bin/bash -p

targetcli /backstores/fileio/ create block_storage /var/block_storage.img {{ block_storage_size_override }}
targetcli /loopback create {{ block_storage_id_override }}
targetcli /loopback/{{ block_storage_id_override }}/luns create /backstores/fileio/block_storage
targetcli saveconfig
