# -*- mode: ruby -*-
# vi: set ft=ruby :

require './boot/plugins/vagrant-provision-reboot-plugin'

Vagrant.configure('2') do |config|

  config.vm.define :DeVM do |t| end

  config.ssh.paranoid = true
  if ARGV[0] == 'ssh' ? config.ssh.shell = ENV['VM_SHELL_SSH']
                      : config.ssh.shell = ENV['VM_SHELL']
  end

  config.vm.box = ENV['VM_BOX']
  config.vm.box_check_update = true

  #config.vm.network :forwarded_port, guest:ENV['PORT_IN_0'],
                                      #host:ENV['PORT_OUT_0']
  config.vm.network :forwarded_port, guest:ENV['PORT_IN_1'],
                                      host:ENV['PORT_OUT_1']
  #config.vm.network :forwarded_port, guest:ENV['PORT_IN_2'],
                                      #host:ENV['PORT_OUT_2']

  config.vm.synced_folder '.', '/vagrant', disabled:true
  config.vm.synced_folder '.', ENV['VM_PATH']
  config.vm.synced_folder '.zerotier', ENV['VM_PATH_ZT'], owner:'root',
                                                          group:'root',
                                                          create:true

  config.vm.provision :shell, env:{'BOOT_DEBUG' => ENV['BOOT_DEBUG']},
                              path:ENV['VM_BOOT'], :args => '-c' # bootstrap
  config.vm.provision :unix_reboot
  config.vm.provision :shell, env:{'ZT_GPG_KEY'     => ENV['ZT_GPG_KEY'],
                                   'ZT_INSTALL'     => ENV['ZT_INSTALL'],
                                   'ZT_INSTALL_TMP' => ENV['ZT_INSTALL_TMP'],
                                   'ZT_NETWORK'     => ENV['ZT_NETWORK']},
                              path:ENV['VM_BOOT'], :args => '-v' # zerotier
  #config.vm.provision :shell, path:ENV['VM_BOOT'], :args => '-x' # nginx
  #config.vm.provision :shell, path:ENV['VM_BOOT'], :args => '-n' # nodejs
  #config.vm.provision :shell, path:ENV['VM_BOOT'], :args => '-u' # nvm
  #config.vm.provision :shell, path:ENV['VM_BOOT'], :args => '-y' # yarn
  config.vm.provision :shell, path:ENV['VM_BOOT'], :args => '-p' # python
  config.vm.provision :shell, path:ENV['VM_BOOT'], :args => '-r' # virtualenv
  config.vm.provision :shell, env:{'BOOT_DEBUG'      => ENV['BOOT_DEBUG'],
                                   'DOCKER_APT_REPO' => ENV['DOCKER_APT_REPO'],
                                   'DOCKER_GPG_KEY'  => ENV['DOCKER_GPG_KEY'],
                                   'DOCKER_KEY_SERV' => ENV['DOCKER_KEY_SERV'],
                                   'DOCKER_SOURCES'  => ENV['DOCKER_SOURCES'],
                                   'DOCKER_UBUNTU'   => ENV['DOCKER_UBUNTU'],
                                   'UBUNTU_GPG_KEY'  => ENV['UBUNTU_GPG_KEY'],
                                   'UBUNTU_KEY_SERV' => ENV['UBUNTU_KEY_SERV']},
                              path:ENV['VM_BOOT'], :args => '-d' # docker
  config.vm.provision :unix_reboot
  config.vm.provision :shell, privileged:false,
                              env:{'DOCKER_VERSION' => ENV['DOCKER_VERSION'],
                                   'DVM_ACTIVATE'   => ENV['DVM_ACTIVATE'],
                                   'DVM_INSTALL'    => ENV['DVM_INSTALL'],
                                   'VM_BASHRC'      => ENV['VM_BASHRC']},
                              path:ENV['VM_BOOT'], :args => '-b' # dvm
  config.vm.provision :shell, path:ENV['VM_BOOT'], :args => '-z' # compose
  config.vm.provision :shell, env:{'DOCKER_PY_PATH' => ENV['DOCKER_PY_PATH']},
                              path:ENV['VM_BOOT'], :args => '-f' # flask
  #config.vm.provision :shell, path:ENV['VM_BOOT'], :args => '-j' # jupyter

end
