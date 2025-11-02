# Transparent Proxy Toolkit

**Author:** Dilshat Hewzulla

A comprehensive collection of scripts and configurations for setting up transparent proxy functionality across multiple platforms including macOS, OpenWrt routers, DD-WRT routers, Charles Proxy/mitmproxy integration, and a custom DNS server for advanced network control.

## Overview

This is collection of my attempts over the years for intercepting and redirecting network traffic transparently, enabling network analysis, debugging, and security testing across different network environments.

### 🖥️ macOS

- **Packet Filter (PF) Configuration**: Automated setup of macOS packet filtering rules
- **IP Forwarding**: Enable and configure IP forwarding for transparent proxying
- **Traffic Redirection**: Redirect HTTP/HTTPS traffic to local proxy instances

### 🌐 OpenWrt Router

- **Remote Router Management**: SSH-based configuration and deployment
- **Firewall Configuration**: Automated iptables rules for traffic interception
- **DNS Redirection**: Force DNS queries through specified servers
- **SSH Key Management**: Secure authentication setup and management

### 📡 DD-WRT Router Compatibility

- Configuration support for DD-WRT firmware
- Firewall rules and traffic routing

### 🔍 Charles Proxy/mitmproxy

- **Transparent Mode**: traffic interception
- **Upstream Proxy**: Chain proxies
- **Hardware Listing**: Network interface discovery and configuration

### 🌐 Custom DNS Server

- **Client-Specific DNS Resolution**: Different DNS responses based on client IP addresses
- **Domain Override**: Custom domain-to-IP mappings for testing and development
- **DNS Forwarding**: Fallback to upstream DNS servers for unmatched queries
- **Access Control**: Block unauthorized clients from DNS resolution
- **Low TTL Configuration**: Short TTL values for instant configuration changes
- **Logging & Monitoring**: Comprehensive DNS query logging and analysis
- **Docker Support**: Containerized deployment with Docker
- **HTTP Configuration Interface**: Web-based configuration management

### Network Management

- **Router Configuration**: Automated deployment of firewall rules and network settings
- **SSH Automation**: Secure remote access and configuration management
- **Configuration Backup**: Download and upload router configurations safely
- **Service Integration**: Compatible with existing network services and VPN setups

## Architecture

I aims to cover multiple layers:

1. **Client Layer**: End-user devices with transparent traffic redirection
2. **Network Layer**: Router-based traffic interception and routing
3. **DNS Layer**: Custom DNS server for domain resolution control and client-specific responses
4. **Proxy Layer**: Charles Proxy/mitmproxy or custom proxy servers for traffic analysis
5. **Management Layer**: Automated configuration and deployment scripts

## Network Flow

```
Client Device → DNS Server → Router (iptables/PF rules) → Proxy Server → Destination
     ↑             ↓                                          ↓
     └─────────── Custom DNS Resolution ←──────────────────────┘
     ↑                                                         ↓
     └─────────────── Traffic Analysis & Logging ←─────────────┘
```

**Note**: The script is designed for legitimate network administration, security testing, and research purposes. Users are responsible for ensuring compliance with applicable laws and regulations when deploying network monitoring solutions.



# GL-MT300N-V2



br-lan: 192.168.8.1/24  (LAN interface)
eth0.2: 192.168.0.138/24 (WAN interface)


# Factory reset
```
firstboot
reboot

```

```

opkg update
opkg install tcpdump
```


```
opkg install iptables-mod-nat-extra
```



```
PROXY_IP="192.168.0.25"
PROXY_PORT="8888"

# Avoid proxy loop
iptables -t nat -A PREROUTING -s $PROXY_IP -j RETURN

# Intercept LAN->WAN HTTP and DNAT to proxy
iptables -t nat -A PREROUTING -i br-lan \
  -p tcp --dport 80 -j DNAT --to-destination ${PROXY_IP}:${PROXY_PORT}

# Allow LAN->proxy forwarding
iptables -A FORWARD -i br-lan -o eth0.2 \
  -d ${PROXY_IP} -p tcp --dport ${PROXY_PORT} -j ACCEPT

# Proxy sees router as source so return routing works
iptables -t nat -A POSTROUTING -o eth0.2 \
  -d ${PROXY_IP} -p tcp --dport ${PROXY_PORT} -j MASQUERADE

```









# OpenWrt has three layers of firewall logic:

1.  Raw netfilter rule insertion (/etc/firewall.user)
2️. w3 dynamic rules generated from /etc/config/firewall
3️. Zone-based policies (LAN ➜ WAN allowed, LAN ➜ LAN rejected, etc.)


# fw3 accept rule

```
uci add firewall rule
uci set firewall.@rule[-1].name='Allow_HTTP_Intercept'
uci set firewall.@rule[-1].src='lan'
uci set firewall.@rule[-1].dest='wan'
uci set firewall.@rule[-1].proto='tcp'
uci set firewall.@rule[-1].dest_port='80'
uci set firewall.@rule[-1].target='ACCEPT'
uci commit firewall
/etc/init.d/firewall restart

```


```
uci add firewall forwarding
uci set firewall.@forwarding[-1].src='lan'
uci set firewall.@forwarding[-1].dest='wan'
uci commit firewall
/etc/init.d/firewall restart

```

```
uci add firewall nat
uci set firewall.@nat[-1].name='Proxy_MASQ'
uci set firewall.@nat[-1].src='lan'
uci set firewall.@nat[-1].dest_ip='192.168.0.25'
uci set firewall.@nat[-1].proto='tcp'
uci set firewall.@nat[-1].dest_port='8888'
uci set firewall.@nat[-1].target='MASQUERADE'
uci commit firewall
/etc/init.d/firewall restart

```







# Testing
iptables -t nat -vnL PREROUTING | grep 80
iptables -t nat -vnL POSTROUTING | grep 8888

Expecting:
```
10   600 MASQUERADE tcp  -- * eth0.2 192.168.8.0/24 192.168.0.25 tcp dpt:8888

```


```
cat /proc/net/firewall
iptables -L -n
nft list ruleset

```

```
ip route
```

```
tcpdump -i br-lan port 80 -nn -c 5

```



# disable flow offloading so DNAT interception works

```
uci set firewall.@defaults[0].flow_offloading='0'
uci set firewall.@defaults[0].flow_offloading_hw='0'
uci commit firewall
/etc/init.d/firewall restart

```




# UIC Config Way
```
```
uci add firewall redirect
uci set firewall.@redirect[-1].name='http_to_proxy'
uci set firewall.@redirect[-1].src='lan'
uci set firewall.@redirect[-1].dest='wan'
uci set firewall.@redirect[-1].proto='tcp'
uci set firewall.@redirect[-1].src_dport='80'
uci set firewall.@redirect[-1].dest_ip='192.168.0.25'
uci set firewall.@redirect[-1].dest_port='8888'
uci set firewall.@redirect[-1].target='DNAT'
uci commit firewall
/etc/init.d/firewall restart

```

```
