#!/bin/bash -p

hostname=$(hostname)
ip_addr=$(ip -4 addr show eth1 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

for interface in eth0 eth1;
do
  eval $(route -n | awk -v interface=$interface '{ if ($8 ==interface && $2 != "0.0.0.0") print "route del default gw " $2; }')
done
route add default gw 10.0.1.1

exec sed -i "s/.*$hostname.*/$ip_addr $hostname/" /etc/hosts
