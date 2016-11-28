# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/trusty64"
  config.vm.network :forwarded_port, guest:80, host:1337
  config.vm.network :forwarded_port, guest:8888, host:1321
  config.vm.define :DeVM do |t| end

  config.vm.provision :shell, inline:<<-SHELL
    apt-get update
    apt-get install -y build-essential
    apt-get install -y llvm
    apt-get install -y clang-3.4
    apt-get install -y ntp
    apt-get install -y libffi-dev
    apt-get install -y libssl-dev
    apt-get install -y apt-transport-https
    apt-get install -y ca-certificates
    apt-get install -y git
  SHELL

end
