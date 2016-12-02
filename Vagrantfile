# -*- mode: ruby -*-
# vi: set ft=ruby :

require './src/devm/plugins/vagrant-provision-reboot-plugin'

Vagrant.configure("2") do |config|
  config.ssh.paranoid = true
  config.ssh.shell = ENV['VM_SHELL']
  config.vm.box = ENV['VM_BOX']
  config.vm.define :DeVM do |t| end
  config.vm.network :forwarded_port, guest:ENV['VM_GUEST'], host:ENV['VM_HOST']
  config.vm.synced_folder ".", "/vagrant", disabled:true
  config.vm.synced_folder ".", ENV['VM_PATH']
  config.vm.provision :shell, path:ENV['VM_BOOTSTRAP'], :args=>"-c" # common
  config.vm.provision :unix_reboot
  config.vm.provision :shell, path:ENV['VM_BOOTSTRAP'], :args=>"-x" # nginx
  #config.vm.provision :shell, path:ENV['VM_BOOTSTRAP'], :args=>"-n" # nodejs
  #config.vm.provision :shell, path:ENV['VM_BOOTSTRAP'], :args=>"-u" # nvm
  #config.vm.provision :shell, path:ENV['VM_BOOTSTRAP'], :args=>"-y" # yarn
  config.vm.provision :shell, path:ENV['VM_BOOTSTRAP'], :args => "-p" # python
  #config.vm.provision :shell, path:ENV['VM_BOOTSTRAP'], :args => "-d" # docker
  #config.vm.provision :shell, path:ENV['VM_BOOTSTRAP'], :args => "-z" # compose
  #config.vm.provision :shell, path:ENV['VM_BOOTSTRAP'], :args => "-f" # flask
  config.vm.provision :shell, path:ENV['VM_BOOTSTRAP'], :args => "-j" # jupyter
end
