#!/bin/bash

*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]

-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# DROP INVALID SYN PACKETS
-A INPUT -p tcp --tcp-flags ALL ACK,RST,SYN,FIN -j DROP
-A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
-A INPUT -p tcp --tcp-flags SYN,RST SYN,RST -j DROP

# MAKE SURE NEW INCOMING TCP CONNECTIONS ARE SYN PACKETS
-A INPUT -p tcp ! --syn -m state --state NEW -j DROP

# DROP PACKETS WITH INCOMING FRAGMENTS
-A INPUT -f -j DROP

# DROP INCOMING MALFORMED XMAS PACKETS
-A INPUT -p tcp --tcp-flags ALL ALL -j DROP

# DROP INCOMING MALFORMED NULL PACKETS
-A INPUT -p tcp --tcp-flags ALL NONE -j DROP

# Allow all traffic to localhost
-A INPUT -i lo -j ACCEPT

# Allow specific ports
-A INPUT -i eth0 -p tcp --dport 514 -j ACCEPT

# Log all other traffic (Outside of the permitted)
-A INPUT -m state --state NEW -j LOG --log-prefix " FW-IN-ACCEPT "

# Reject all other traffic
-A INPUT -j REJECT --reject-with icmp-host-prohibited

-A OUTPUT -p udp --dport 514 -j ACCEPT

-A OUTPUT -m state --state NEW -j LOG --log-prefix "FW-OUT-ACCEPT "

COMMIT
