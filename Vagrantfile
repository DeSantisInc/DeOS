# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
  config.vm.box = "bento/ubuntu-16.04"
  config.vm.define :DeVM do |t| end
  config.vm.network :forwarded_port, guest:80, host:1337
  config.vm.network :forwarded_port, guest:8888, host:1321
  config.vm.provision :shell, path: "./src/devm/common.sh"
  config.vm.provision :shell, path: "./src/devm/node.sh"
  config.vm.provision :shell, path: "./src/devm/nvm.sh"
  config.vm.provision :shell, path: "./src/devm/yarn.sh"
  config.vm.provision :shell, path: "./src/devm/docker.sh"
  config.vm.provision :shell, path: "./src/devm/compose.sh"
end
