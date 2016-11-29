#!/usr/bin/env bash

printf '\x1b[34;01m### apt-get update ### \x1b[34;01m'
sudo apt-get update

printf '\x1b[34;01m### apt-get install nodejs ### \x1b[34;01m'
curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
sudo apt-get -y install nodejs 2> /dev/null

printf '\x1b[34;01m### apt-get install npm ### \x1b[34;01m'
sudo apt-get install npm 2> /dev/null

printf '\x1b[34;01m### apt-get install build-essential ### \x1b[34;01m'
sudo apt-get -y install build-essential 2> /dev/null

printf '\x1b[34;01m### apt-get install build-essential ### \x1b[34;01m'
sudo apt-get -y install libssl-dev 2> /dev/null

printf '\x1b[34;01m### apt-get install git ### \x1b[34;01m'
sudo apt-get -y install git 2> /dev/null

printf '\x1b[34;01m### apt-get install curl ### \x1b[34;01m'
sudo apt-get -y install curl 2> /dev/null

printf '\x1b[34;01m### git clone https://github.com/creationix/nvm.git ### \x1b[34;01m'
git clone https://github.com/creationix/nvm.git /home/vagrant/.nvm && cd /home/vagrant/.nvm && git checkout `git describe --abbrev=0 --tags`

source /home/vagrant/.nvm/nvm.sh
cd /vagrant && nvm install
cd /vagrant && nvm use
n=$(which node);n=${n%/bin/node}; chmod -R 755 $n/bin/*; sudo cp -r $n/{bin,lib,share} /usr/local

printf '\x1b[34;01m### apt-get install yarn ### \x1b[34;01m'
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb http://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get -y install yarn 2> /dev/null
export PATH="$PATH:`yarn global bin`"

printf '\x1b[34;01m### yarn install ### \x1b[34;01m'
cd /vagrant && yarn install && cd app && yarn install
