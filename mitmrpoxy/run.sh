# sudo mitmproxy --mode transparent --listen-host 0.0.0.0 --listen-port 9000 --showhost

mkdir -p ~/mitmproxy-data
chmod 777 ~/mitmproxy-data

docker run --rm -it --name mitmproxy -p 9000:9000 -v ~/mitmproxy-data:/home/mitmproxy/.mitmproxy  mitmproxy/mitmproxy mitmproxy --mode transparent --listen-port 9000 --showhost