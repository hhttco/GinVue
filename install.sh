#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

version="v1.0.0"

main() {
	apt -y update && apt -y install curl wget git vim zip nginx
	systemctl enable --now nginx
	cd /var/www && git clone https://github.com/hhttco/GinVue.git && cd GinVue
	chown -R www-data:www-data /var/www/GinVue
    chmod -R 755 /var/www/GinVue
	chmod +x gin-demo
	nohup ./gin-demo >nohup.out 2>&1 &

	echo "server {
    listen       8080;
    server_name  localhost;
    root         /var/www/GinVue/dist;
    index        index.html;
    client_max_body_size 0;

    location / {
      try_files \$uri \$uri/ /index.html;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
      root   /usr/share/nginx/html;
    }
}" > /etc/nginx/conf.d/dist.conf

    systemctl reload nginx

    echo -e "${green}=====创建成功=====${plain}"
    echo -e "${green}=====访问地址：http://ip:8080=====${plain}"
}

main
