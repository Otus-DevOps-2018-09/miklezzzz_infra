#!/bin/bash

#Simple script for deploying our awesome app 

cd /opt && git clone -b monolith https://github.com/express42/reddit.git && cd reddit && bundle install
PUMA_PATH=`whereis puma | awk {'print $2'}`

cat <<EOF>> /etc/systemd/system/puma.service
[Unit]
Description=Test Puma Service
After=network.target

[Service]
ExecStart=$PUMA_PATH
ExecStop=killall puma
WorkingDirectory=/opt/reddit

[Install]
WantedBy=default.target
EOF

chmod 664 /etc/systemd/system/puma.service

systemctl daemon-reload

systemctl enable puma.service

