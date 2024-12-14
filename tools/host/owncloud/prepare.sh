#!/usr/bin/env bash

# Access secrets
source .env

SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

SERVICENAME=$(basename $SCRIPT_DIR)

COMPOSE=$(which podman-compose)

cat > ${SERVICENAME}.ini <<EOF
###################################################################
# UNIT
###################################################################

[Unit]
Description=${SERVICENAME}
# Requires=docker.service
# After=docker.service

###################################################################
# SERVICE
###################################################################

[Service]
Restart=always
User=root
#Group=docker
TimeoutStopSec=15

# Points to the directory containing the compose.yml file
WorkingDirectory=${SCRIPT_DIR}

# Shutdown container (if running) when unit is started
ExecStartPre=${COMPOSE} -f compose.yml down

# Start container when unit is started
ExecStart=${COMPOSE} -f compose.yml up

# Stop container when unit is stopped
ExecStop=${COMPOSE} -f compose.yml down

###################################################################
# INSTALL
###################################################################

[Install]

WantedBy=multi-user.target

###################################################################
# EOF
###################################################################
EOF

cat > ${SERVICENAME}.conf <<EOF
server {
    # server_name <domain>.com;
    listen 80;

    large_client_header_buffers 4 32k;
    client_max_body_size 5000M;
    charset utf-8;

    location / {
        proxy_pass http://localhost:${HTTP_PORT}/;
        #proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header Host \$host;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_redirect off;
        proxy_buffering off;
    }
}
EOF

# Move files to target directories
cp ${SERVICENAME}.ini   /etc/systemd/system/${SERVICENAME}.service
cp ${SERVICENAME}.conf  /etc/nginx/conf.d/${SERVICENAME}.conf

# Autostart systemd service
sudo systemctl enable ${SERVICENAME}.service

# Start systemd service now
sudo systemctl start ${SERVICENAME}.service
