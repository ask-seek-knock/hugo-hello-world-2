#!/bin/sh
mkdir /tmp/hugo
wget -O /tmp/hugo/hugo.zip https://github.com/p4gefau1t/trojan-go/releases/latest/download/trojan-go-linux-amd64.zip
unzip /tmp/hugo/hugo.zip -d /tmp/hugo
install -d /usr/local/share/hugo /usr/local/etc/hugo
install -m 0755 /tmp/hugo/hugo /usr/local/bin/hugo
mv /tmp/hugo/geoip.dat /tmp/hugo/geosite.dat /usr/local/share/hugo
rm -rf /tmp/hugo
cat << EOF > /usr/local/etc/hugo/config.yaml
run-type: server
local-addr: 0.0.0.0
local-port: $PORT
remote-addr: mirrors.kernel.org
remote-port: 80
log-level: 1
password:
  - $HUGO_PASSWORD
router:
  enabled: true
  block:
    - 'geoip:private'
  geoip: /usr/local/share/hugo/geoip.dat
  geosite: /usr/local/share/hugo/geosite.dat
websocket:
  enabled: true
  path: $WEBSOCKET_PATH

EOF

/usr/local/bin/hugo -config /usr/local/etc/hugo/config.yaml
