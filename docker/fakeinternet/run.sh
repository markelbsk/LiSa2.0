#!/bin/bash

inetsim > ./inetsim.log &

tcpdump -i eth0
