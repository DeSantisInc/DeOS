DERUN "sudo apt-get install -y nginx"

DERUN "rm /etc/nginx/nginx.conf"

cat <<EOT >> /vagrant/var/docker/nginx/nginx.conf
user www-data;
worker_processes 4;
pid /run/nginx.pid;

events {
    worker_connections 768;
}

http {
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
    gzip on;
    gzip_disable "msie6";
    upstream ws_server {
      server localhost:8282;
    }
    server {
        listen 80;
        server_name localhost;
        location / {
           proxy_pass http://ws_server/;
           proxy_redirect off;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
        }
    }
}
EOT

DERUN "ln -s /vagrant/var/docker/nginx/nginx.conf /etc/nginx/nginx.conf"

DERUN "sudo service nginx reload"

EXIT_SUCCESS
