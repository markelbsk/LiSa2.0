#!/bin/bash

# ip routing proxy
ip route delete default
ip route add default via 172.42.0.25
echo "ip route"
ip route

/bin/bash
