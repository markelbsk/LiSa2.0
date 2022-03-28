#!/bin/ash
# Active forwarding bit
echo 1 > /proc/sys/net/ipv4/ip_forward

# Set default policies
iptables -P FORWARD ACCEPT 

/sbin/iptables -N LOGDROP
/sbin/iptables -A LOGDROP -j LOG
/sbin/iptables -A LOGDROP -j DROP

# Disable bruteforcing
# This rule will block an IP if it attempts more than 3 connections per minute to SSH. Notice that the state is set to NEW
# Ref: https://www.rackaid.com/blog/how-to-block-ssh-brute-force-attacks/
iptables -I FORWARD -p tcp --dport 22 -i eth0 -m state --state NEW -m recent --set
iptables -I FORWARD -p tcp --dport 22 -i eth0 -m state --state NEW -m recent  --update --seconds 60 --hitcount 4 -j LOGDROP

# FTP
iptables -I FORWARD -p tcp --dport 21 -i eth0 -m state --state NEW -m recent --set
iptables -I FORWARD -p tcp --dport 21 -i eth0 -m state --state NEW -m recent  --update --seconds 60 --hitcount 4 -j LOGDROP

# Telnet
iptables -I FORWARD -p tcp --dport 23 -i eth0 -m state --state NEW -m recent --set
iptables -I FORWARD -p tcp --dport 23 -i eth0 -m state --state NEW -m recent  --update --seconds 60 --hitcount 4 -j LOGDROP

# HTTP attacks (different vulnerabilties)
iptables -I FORWARD -p tcp -m string --string "/boaform/admin/formLogin?" --algo kmp -j LOGDROP 
iptables -I FORWARD -p tcp -m string --string "/GponForm/diag_Form?images/" --algo kmp -j LOGDROP 
iptables -I FORWARD -p tcp -m string --string "/setup.cgi?" --algo kmp -j LOGDROP 
iptables -I FORWARD -p tcp -m string --string "/HNAP1/" --algo kmp -j LOGDROP 

# port scanning 
iptables -N LOGPSCAN
iptables -A LOGPSCAN -p tcp --syn -m limit --limit 100/minute -j RETURN
iptables -A LOGPSCAN -m limit --limit 100/minute -j LOG --log-prefix "DROPPED Port scan: "
iptables -A LOGPSCAN -j DROP
iptables -A INPUT -p tcp --syn -j LOGPSCAN

# block ping (icmp)
iptables -A FORWARD -p icmp --icmp-type echo-request -j LOGDROP

# Use the Firewall as a NAT 
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Start bash to dont kill the container
# /bin/ash
tcpdump -i eth0
