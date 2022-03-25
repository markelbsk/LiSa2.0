#!/bin/ash

# Activate forwarding bit
echo 1 > /proc/sys/net/ipv4/ip_forward

# Set default policies
iptables -P FORWARD ACCEPT

/sbin/iptables -N LOGDROP
/sbin/iptables -A LOGDROP -j LOG
/sbin/iptables -A LOGDROP -j DROP

# This rule will block an IP if it attempts more than 3 connections per minute to SSH, Telnet
iptables -I INPUT -p tcp --dport 21,22,23 -i eth0 -m state --state NEW -m recent --set
iptables -I INPUT -p tcp --dport 21,22,23 -i eth0 -m state --state NEW -m recent  --update --seconds 60 --hitcount 4 -j LOGDROP

# XMAS Packet
iptables -A INPUT -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP

# SYN Flood
iptables -A INPUT -p tcp -m state --state NEW -m limit --limit 2/second --limit-burst 2 -j ACCET
iptables -A INPUT –p tcp –m state --state NEW –j DROP

# set up NAT with iptables
iptables --table nat --append POSTROUTING --out-interface eth0 -j MASQUERADE


# start bash
/bin/ash
