
script_file_folder=$(dirname "${BASH_SOURCE[0]}")
router_folder="$script_file_folder/../router"


ssh_authorized_folder=/etc/dropbear
ssh_authorized_file="authorized_keys"


firewall_user_file_folder=/etc
firewall_user_filename="firewall.user"


router_ssh_user_name="root"

router_ip_address="192.168.8.1"

charles_proxy_ip_address=192.168.0.25
charles_proxy_port=8888


# host_key_algorithm="HostKeyAlgorithms=+ssh-rsa"




router_ssh_login(){

# ssh -o$host_key_algorithm -i ~/.ssh/id_rsa $router_ssh_user_name@$router_ip_address
ssh  -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa $router_ssh_user_name@$router_ip_address

}


open_router_browser(){

open "http://$router_ip_address"
}


upload_router_scripts(){

  scp -O \
  -o HostKeyAlgorithms=+ssh-rsa \
  -o PubkeyAcceptedKeyTypes=+ssh-rsa \
  -i ~/.ssh/id_rsa \
  "$router_folder/install_iptable.sh" \
  "$router_ssh_user_name@$router_ip_address:install_iptable.sh"
}
execute_install_iptable_script(){

  ssh -o HostKeyAlgorithms=+ssh-rsa \
  -o PubkeyAcceptedKeyTypes=+ssh-rsa \
  -i ~/.ssh/id_rsa \
  $router_ssh_user_name@$router_ip_address "sh install_iptable.sh"
}

download_router_authorized_keys(){
  mkdir -p  "$router_folder$ssh_authorized_folder"
  
  scp -O \
  -o HostKeyAlgorithms=+ssh-rsa \
  -o PubkeyAcceptedKeyTypes=+ssh-rsa \
  -i ~/.ssh/id_rsa \
  $router_ssh_user_name@$router_ip_address:$ssh_authorized_folder/$ssh_authorized_file  \
  $router_folder$ssh_authorized_folder/$ssh_authorized_file
}
download_router_dhcp_config(){
  mkdir -p  "$router_folder/etc/config"
  
  scp -O \
  -o HostKeyAlgorithms=+ssh-rsa \
  -o PubkeyAcceptedKeyTypes=+ssh-rsa \
  -i ~/.ssh/id_rsa \
  $router_ssh_user_name@$router_ip_address:/etc/config/dhcp  \
  $router_folder/etc/config/dhcp
}

upload_router_authorized_keys(){
  
  scp -O \
  -o HostKeyAlgorithms=+ssh-rsa \
  -o PubkeyAcceptedKeyTypes=+ssh-rsa \
  -i ~/.ssh/id_rsa \
  $router_folder$ssh_authorized_folder/$ssh_authorized_file \
  $router_ssh_user_name@$router_ip_address:$ssh_authorized_folder/$ssh_authorized_file
}




download_firewall_user_file(){
  mkdir -p  "$router_folder$firewall_user_file_folder"
  
  scp -O \
  -o HostKeyAlgorithms=+ssh-rsa \
  -o PubkeyAcceptedKeyTypes=+ssh-rsa \
  -i ~/.ssh/id_rsa \
  $router_ssh_user_name@$router_ip_address:$firewall_user_file_folder/$firewall_user_filename  \
  $router_folder$firewall_user_file_folder/$firewall_user_filename
}

upload_firewall_user_file(){
    
  scp -O \
  -o HostKeyAlgorithms=+ssh-rsa \
  -o PubkeyAcceptedKeyTypes=+ssh-rsa \
  -i ~/.ssh/id_rsa \
  $router_folder$firewall_user_file_folder/$firewall_user_filename \
  $router_ssh_user_name@$router_ip_address:$firewall_user_file_folder/$firewall_user_filename
}

restart_firewall(){
  ssh -o HostKeyAlgorithms=+ssh-rsa \
  -o PubkeyAcceptedKeyTypes=+ssh-rsa \
  -i ~/.ssh/id_rsa \
  $router_ssh_user_name@$router_ip_address "/etc/init.d/firewall restart"
  
}
restart_dnsmasq(){
  ssh -o HostKeyAlgorithms=+ssh-rsa \
  -o PubkeyAcceptedKeyTypes=+ssh-rsa \
  -i ~/.ssh/id_rsa \
  $router_ssh_user_name@$router_ip_address "/etc/init.d/dnsmasq restart"
}
list_network_interfaces(){
  ifconfig -a | grep -E '^[a-zA-Z0-9]+' | awk '{print $1}' | sed 's/://g' | sort -u
}
get_allnetowrk_interfaces_ip_addresses(){
  ifconfig -a | grep -E '^[a-zA-Z0-9]+' | awk '{print $1}' | sed 's/://g' | sort -u | while read interface; do
    ip_address=$(ifconfig $interface | grep 'inet ' | awk '{print $2}')
    echo "$interface: $ip_address"
  done
}

listAllIPAddress(){
  
  interfaces_and_ip_address=$(get_allnetowrk_interfaces_ip_addresses)  
  echo $interfaces_and_ip_address | grep -Eo '192\.168\.[0-9]{1,3}\.[0-9]{1,3}'
  
}

# getProxyIPAddress(){
#   # | head -n 1
#   ipaddress=$(listAllIPAddress)
#   echo $ipaddress | grep -Eo '192\.168\.[8]{1,3}\.[0-9]{1,3}' | head -n 1
# }


add_http_proxy_to_firewall_user_file(){  
  filepath="$router_folder$firewall_user_file_folder/$firewall_user_filename"
  echo "" >> $filepath
  echo "" >> $filepath
  echo "# Charles HTTPS redirect" >> $filepath
  echo "iptables -t nat -A PREROUTING -p tcp -s 192.168.8.0/24 ! -d 192.168.8.0/24 --dport 80 -j DNAT --to-destination $charles_proxy_ip_address:$charles_proxy_port" >> $filepath
  
}