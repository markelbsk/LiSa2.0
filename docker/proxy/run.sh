#!/bin/ash

# set up NAT with iptables
iptables --table nat --append POSTROUTING --out-interface eth0 -j MASQUERADE
