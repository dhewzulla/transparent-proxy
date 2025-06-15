sudo sysctl -w net.inet.ip.forwarding=1



#rdr pass on en0 inet proto tcp to any port {80, 443} -> 127.0.0.1 port 8080