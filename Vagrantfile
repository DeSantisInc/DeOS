# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-16.04"
  config.vm.network :forwarded_port, guest:80, host:1337
  config.vm.define :DeVM do |t| end
  config.vm.provision :shell, inline:<<-SHELL
    curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb http://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt-get update
    sudo apt-get install -y build-essential
    sudo apt-get install -y nodejs
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash
    nvm install v7.0.0
    nvm use v7.0.0
    sudo apt-get install yarn
    export PATH="$PATH:`yarn global bin`"
  SHELL
end
