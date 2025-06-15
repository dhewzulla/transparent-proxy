
script_file_folder=$(dirname "${BASH_SOURCE[0]}")
router_folder="$script_file_folder/../router"


router_ip_address="192.168.1.1"

charles_proxy_ip_address=192.168.0.25
charles_proxy_port=8888


# host_key_algorithm="HostKeyAlgorithms=+ssh-rsa"




open_router_browser(){

open "http://$router_ip_address"
}
