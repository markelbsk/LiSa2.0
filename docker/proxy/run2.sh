#!/bin/bash

# Active forwarding bit
# echo 1 > /proc/sys/net/ipv4/ip_forward

# Set default policies
# iptables -P FORWARD ACCEPT 

# Use the Firewall as a NAT 
# iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Start bash to dont kill the container
# /bin/ash
# tcpdump -i eth0
