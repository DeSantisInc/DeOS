#!/usr/bin/env bash

apt-get update;
apt-get install -y nginx;

rm /etc/nginx/nginx.conf;
ln -s /vagrant/etc/nginx/nginx.conf /etc/nginx/nginx.conf;

if ! [ -L /etc/nginx/sites-available/default ]; then
  rm -rf /etc/nginx/sites-available/default;
  ln -s /vagrant/etc/nginx/sites-available/deos.conf /etc/nginx/sites-available/deos.conf;
fi
