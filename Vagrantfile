# -*- mode: ruby -*-
# vi: set ft=ruby :

require './boot/plugins/vagrant-provision-reboot-plugin'

Vagrant.configure("2") do |config|

  config.vm.define :DeVM do |t| end

  config.vm.box = ENV['VM_BOX']

  config.vm.box_check_update = true

  config.ssh.paranoid = true

  if ARGV[0] == "ssh" ? config.ssh.shell = "bash -l"
                      : config.ssh.shell = ENV['VM_SHELL']
  end

  config.vm.network :forwarded_port, guest:ENV['VM_GUEST'], host:ENV['VM_HOST']

  #config.vm.network :forwarded_port, guest:5000, host:1335

  #config.vm.network :forwarded_port, guest:8888, host:1336

  config.vm.synced_folder ".", "/vagrant", disabled:true

  config.vm.synced_folder ".", ENV['VM_PATH']

  config.vm.synced_folder ".zerotier/", "/var/lib/zerotier-one", owner:"root",
                                                                 group:"root",
                                                                 create:true

  config.vm.provision :shell, privileged:true, path:ENV['VM_BOOT'],
                      :args => "-c" # common

  config.vm.provision :unix_reboot

  config.vm.provision :shell, privileged:true, path:ENV['VM_BOOT'],
                      :args => "-v" # zerotier

  config.vm.provision :shell, privileged:true, path:ENV['VM_BOOT'],
                      :args => "-x" # nginx

  #config.vm.provision :shell, privileged:true, path:ENV['VM_BOOT'],
                      #:args => "-n" # nodejs

  #config.vm.provision :shell, privileged:true, path:ENV['VM_BOOT'],
                      #:args => "-u" # nvm

  #config.vm.provision :shell, privileged:true, path:ENV['VM_BOOT'],
                      #:args => "-y" # yarn

  config.vm.provision :shell, privileged:true, path:ENV['VM_BOOT'],
                      :args => "-p" # python

  config.vm.provision :shell, privileged:true, path:ENV['VM_BOOT'],
                      :args => "-r" # virtualenv

  #config.vm.provision :shell, privileged:true, path:ENV['VM_BOOT'],
                      #:args => "-d" # docker

  #config.vm.provision :unix_reboot

  #config.vm.provision :shell, privileged:false, path:ENV['VM_BOOT'],
                      #:args => "-b" # dvm

  #config.vm.provision :shell, # compose
    #privileged:true,
    #path:ENV['VM_BOOT'],
    #:args => "-z"

  #config.vm.provision :shell, # flask
    #privileged:true,
    #path:ENV['VM_BOOT'],
    #:args => "-f"

  config.vm.provision :shell, privileged:true, path:ENV['VM_BOOT'],
                      :args => "-j" # jupyter

end
