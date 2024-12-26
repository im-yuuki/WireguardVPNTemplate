#!/bin/bash

MODE="-D"
IF="eth0" # Change to your WAN interface
WG="wg0" # Change to your WireGuard interface
SN="172.16.1.0/24" # Change to your WireGuard subnet

## NAT ##
iptables -t nat $MODE POSTROUTING -s $SN -o $IF -j MASQUERADE
iptables        $MODE INPUT       -i $WG        -j ACCEPT
iptables        $MODE FORWARD     -i $IF -o $WG -j ACCEPT
iptables        $MODE FORWARD     -i $WG -o $IF -j ACCEPT
iptables        $MODE FORWARD     -i $WG -o $WG -j ACCEPT

## Port Forwarding ##
tcpfwd() {
    local ip=$1
    local ps=$2
    local pe=$3

    iptables -t nat $MODE PREROUTING -i $IF -p tcp --dport $ps:$pe -j DNAT --to-destination $ip:$ps-$pe
    iptables -t nat $MODE POSTROUTING -p tcp -d $ip --dport $ps:$pe -j MASQUERADE
    iptables $MODE FORWARD -p tcp -d $ip --dport $ps:$pe -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
}

udpfwd() {
    local ip=$1
    local ps=$2
    local pe=$3

    iptables -t nat $MODE PREROUTING -i $IF -p udp --dport $ps:$pe -j DNAT --to-destination $ip:$ps-$pe
    iptables -t nat $MODE POSTROUTING -p udp -d $ip --dport $ps:$pe -j MASQUERADE
    iptables $MODE FORWARD -p udp -d $ip --dport $ps:$pe -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
}

tcpfwd "172.16.1.3" 10000 20000
udpfwd "172.16.1.3" 10000 20000