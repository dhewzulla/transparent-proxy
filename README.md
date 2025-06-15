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
