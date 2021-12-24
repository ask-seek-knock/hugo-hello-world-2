#!/bin/sh
mkdir /tmp/trojan-go
wget -O /tmp/trojan-go/trojan-go.zip https://github.com/p4gefau1t/trojan-go/releases/latest/download/trojan-go-linux-amd64.zip
unzip /tmp/trojan-go/trojan-go.zip -d /tmp/trojan-go
install -d /usr/local/share/trojan-go /usr/local/etc/trojan-go
install -m 0755 /tmp/trojan-go/trojan-go /usr/local/bin/trojan-go
mv /tmp/trojan-go/geoip.dat /tmp/trojan-go/geosite.dat /usr/local/share/trojan-go
rm -rf /tmp/trojan-go
cat << EOF > /usr/local/etc/trojan-go/config.yaml
run-type: server
local-addr: 0.0.0.0
local-port: $PORT
remote-addr: mirrors.kernel.org
remote-port: 80
log-level: 5
password:
  - $HUGO_PASSWORD
router:
  enabled: true
  block:
    - 'geoip:private'
    - 'geoip:cn'
    - 'geosite:cn'
    - 'geosite:geolocation-cn'
    - 'geosite:category-ads'
  geoip: /usr/local/share/trojan-go/geoip.dat
  geosite: /usr/local/share/trojan-go/geosite.dat
websocket:
  enabled: true
  path: $WEBSOCKET_PATH
api:
  enabled: true
  api_addr: 127.0.0.1
  api_port: 61010
EOF

/usr/local/bin/trojan-go -config /usr/local/etc/trojan-go/config.yaml
