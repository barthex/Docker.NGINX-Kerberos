#!/bin/bash
echo "configuring nginx..."
localhost=$1
domain=$2
uppercasedomain=${domain^^}
lowercasedomain=${domain,,}
remoteip=$3
remoteport=$4
listenPort=$5
cat > /etc/nginx/conf.d/default.conf << EOF
server {
        server_name $localhost.$lowercasedomain;

	listen $listenPort;

    location ~* .(svg|gif|ttf|woff|woff2|ico|eot|png|gif|ico|jpg|jpeg)$ {
        # Matches requests ending in list, Dont check for authorization

        proxy_pass http://$remoteip:$remoteport;
		proxy_http_version 1.1;
		proxy_set_header Upgrade \$http_upgrade;
		proxy_set_header Connection keep-alive;
		proxy_set_header Host \$host;
		proxy_set_header X-Real-IP \$remote_addr;
		proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto \$scheme;
		proxy_set_header X-Forwarded-Host \$server_name;
    }

	location / {
		proxy_pass http://$remoteip:$remoteport;
		proxy_http_version 1.1;
		proxy_set_header Upgrade \$http_upgrade;
		proxy_set_header Connection keep-alive;
		proxy_set_header Host \$host;
		proxy_set_header X-Real-IP \$remote_addr;
		proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto \$scheme;
		proxy_set_header X-Forwarded-Host \$server_name;
		proxy_cache_bypass \$http_upgrade;
		auth_gss on;
		auth_gss_keytab /etc/nginx/user.keytab;
		auth_gss_service_name HTTP/$localhost.$lowercasedomain;
		auth_gss_realm $uppercasedomain;
		auth_gss_allow_basic_fallback on;


	}


}
EOF
echo "nginx configured as:"
cat /etc/nginx/conf.d/default.conf
