#!/bin/bash -p

hostname=$(hostname)
current_ip_addr=$(ip -4 addr show eth1 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

case "$hostname" in
  controller) ip_suffix="1" ;;
  node1)      ip_suffix="2" ;;
  node2)      ip_suffix="3" ;;
  *)          echo "Unknown hostname"; exit 1 ;;
esac

ip_addr="10.0.13.${ip_suffix}"
if ! echo "$current_ip_addr" | grep -Fq "$ip_addr"; then
    ip addr add ${ip_addr}/16 dev eth1
    printf "search hope.nyc.ny.us\nnameserver 10.0.1.210\n" > /etc/resolv.conf
    sed -i "s/.*$hostname.*/$ip_addr $hostname/" /etc/hosts
fi
sudo ip link set eth1 up

for interface in eth0 eth1;
do
  eval $(ip route | awk -v interface=$interface '{ if ($5 ==interface && $1 == "default") print "ip route del default via " $3; }')
done
ip route add default via 10.0.1.1
