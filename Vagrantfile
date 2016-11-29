# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network :forwarded_port, guest:80, host:1337
  config.vm.define :DeVM do |t| end
  config.vm.provision :shell, inline:<<-SHELL
    sudo apt-get update
    sudo apt-get install -y build-essential
  SHELL
end
