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

  config.vm.network :forwarded_port, guest:5000, host:1335

  config.vm.network :forwarded_port, guest:8888, host:1336

  config.vm.synced_folder ".", "/vagrant", disabled:true

  config.vm.synced_folder ".", ENV['VM_PATH']

  config.vm.synced_folder ".zerotier/", "/var/lib/zerotier-one", owner:"root",
                                                                 group:"root",
                                                                 create:true

  config.vm.provision :shell, privileged:true, path:ENV['VM_BOOTSTRAP'],
                      :args => "-c" # common

  config.vm.provision :unix_reboot

  config.vm.provision :shell, privileged:true, path:ENV['VM_BOOTSTRAP'],
                      :args => "v" # zerotier

  config.vm.provision :shell, privileged:true, path:ENV['VM_BOOTSTRAP'],
                      :args => "-x" # nginx

  #config.vm.provision :shell, # nodejs
    #privileged:true,
    #path:ENV['VM_BOOTSTRAP'],
    #:args => "-n"
  #config.vm.provision :shell, # nvm
    #privileged:true,
    #path:ENV['VM_BOOTSTRAP'],
    #:args => "-u"
  #config.vm.provision :shell, # yarn
    #privileged:true,
    #path:ENV['VM_BOOTSTRAP'],
    #:args => "-y"

  config.vm.provision :shell, privileged:true, path:ENV['VM_BOOTSTRAP'],
                      :args => "-p" # python

  config.vm.provision :shell, privileged:true, path:ENV['VM_BOOTSTRAP'],
                      :args => "-r" # virtualenv

  #config.vm.provision :shell, # docker
    #privileged:true,
    #path:ENV['VM_BOOTSTRAP'],
    #:args => "-d"
  #config.vm.provision :unix_reboot
  #config.vm.provision :shell, # dvm
    #privileged:false,
    #path:ENV['VM_BOOTSTRAP'],
    #:args => "-b"
  #config.vm.provision :shell, # compose
    #privileged:true,
    #path:ENV['VM_BOOTSTRAP'],
    #:args => "-z"
  #config.vm.provision :shell, # flask
    #privileged:true,
    #path:ENV['VM_BOOTSTRAP'],
    #:args => "-f"

  config.vm.provision :shell, privileged:true, path:ENV['VM_BOOTSTRAP'],
                      :args => "-j" # jupyter

end
