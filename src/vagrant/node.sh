#!/usr/bin/env bash

printd() { printf "\x1b[34;01m########[ $1 ]########\x1b[34;01m\n"; echo "$1" | bash; }

printd "sudo apt-get update"

printd "curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -"

printd "sudo apt-get -y install nodejs 2> /dev/null"

printd "sudo apt-get -y install npm 2> /dev/null"

printd "sudo apt-get -y install build-essential 2> /dev/null"

printd "sudo apt-get -y install libssl-dev 2> /dev/null"

printd "sudo apt-get -y install git 2> /dev/null"

printd "sudo apt-get -y install curl 2> /dev/null"

git clone https://github.com/creationix/nvm.git /home/vagrant/.nvm && cd /home/vagrant/.nvm && git checkout `git describe --abbrev=0 --tags`

source /home/vagrant/.nvm/nvm.sh

cd /vagrant && nvm install && nvm use

n=$(which node); n=${n%/bin/node}; chmod -R 755 $n/bin/*; sudo cp -r $n/{bin,lib,share} /usr/local

printd "curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -"

echo "deb http://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

printd "sudo apt-get update && sudo apt-get -y install yarn 2> /dev/null"

export PATH="$PATH:`yarn global bin`"

printd "cd /vagrant && yarn install && cd app && yarn install"
