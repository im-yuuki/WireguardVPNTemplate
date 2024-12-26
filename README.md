This is a configuration template for creating a Wireguard tunnel to use as a VPN connection with NAT features.
***IMPORTANT: Replace all keys used in this example with your own keys.***

In this example:
- VPN subnet is `172.16.1.0/24`
- The server is `172.16.1.1`, listening on port `51820/udp`, and has internet access over `eth0` interface (public IP address: `123.123.12.23`)
- Client 1 is `172.16.1.2`, and needs to forward all traffic through the VPN
- Client 2 is `172.16.1.3`, and needs to access the VPN subnet only
- Forwarding port range `10000-20000` from the server to the client 2

*Note: Currently this configuration does not support IPv6*