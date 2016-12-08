# -*- mode: ruby -*-
# vi: set ft=ruby :

require './boot/plugins/vagrant-provision-reboot-plugin'

Vagrant.configure('2') do |config|

  config.vm.define :DeVM do |t| end

  config.vm.box = ENV['VM_BOX']
  config.vm.box_check_update = true

  config.ssh.paranoid = true
  if ARGV[0] == 'ssh' ? config.ssh.shell = ENV['VM_SHELL_SSH']
                      : config.ssh.shell = ENV['VM_SHELL']
  end

  if ENV['SERVER'] != '0'
    config.vm.network :forwarded_port,
                 guest:ENV['PORT_IN_0'],
                  host:ENV['PORT_OUT_0']
    config.vm.network :forwarded_port,
                 guest:ENV['PORT_IN_1'],
                  host:ENV['PORT_OUT_1']
    config.vm.network :forwarded_port,
                 guest:ENV['PORT_IN_2'],
                  host:ENV['PORT_OUT_2']
  end

  config.vm.synced_folder '.', '/vagrant', disabled:true
  config.vm.synced_folder '.', ENV['VM_PATH']
  config.vm.synced_folder '.zerotier', ENV['VM_PATH_ZT'], owner:'root',
                                                          group:'root',
                                                         create:true

  config.vm.provision :shell, # bootstrap
                  path:ENV['VM_BOOT'],
                   env:{'BOOT_DEBUG' => ENV['BOOT_DEBUG']},
                      :args=>'-c'
  config.vm.provision :unix_reboot
  config.vm.provision :shell, # zerotier
                  path:ENV['VM_BOOT'],
                   env:{'ZT_GPG_KEY'=>ENV['ZT_GPG_KEY'],
                        'ZT_INSTALL'=>ENV['ZT_INSTALL'],
                        'ZT_INSTALL_TMP'=>ENV['ZT_INSTALL_TMP'],
                        'ZT_NETWORK'=>ENV['ZT_NETWORK']},
                      :args=>'-v'

  if ENV['BUILDJS'] != '0'
    config.vm.provision :shell, # nginx
                    path:ENV['VM_BOOT'],
                        :args=>'-x'
    config.vm.provision :shell, # nodejs
                    path:ENV['VM_BOOT'],
                        :args=>'-n'
    config.vm.provision :shell, # nvm
                    path:ENV['VM_BOOT'],
                        :args => '-u'
    config.vm.provision :shell, # yarn
                    path:ENV['VM_BOOT'],
                        :args => '-y'
  end

  config.vm.provision :shell, # python
                  path:ENV['VM_BOOT'],
                      :args=>'-p'
  config.vm.provision :shell, # virtualenv
                  path:ENV['VM_BOOT'],
                      :args=>'-r'
  config.vm.provision :shell, # docker
                  path:ENV['VM_BOOT'],
                   env:{'BOOT_DEBUG'=>ENV['BOOT_DEBUG'],
                        'DOCKER_APT_REPO'=>ENV['DOCKER_APT_REPO'],
                        'DOCKER_GPG_KEY'=>ENV['DOCKER_GPG_KEY'],
                        'DOCKER_KEY_SERV'=>ENV['DOCKER_KEY_SERV'],
                        'DOCKER_SOURCES'=>ENV['DOCKER_SOURCES'],
                        'DOCKER_UBUNTU'=>ENV['DOCKER_UBUNTU'],
                        'UBUNTU_GPG_KEY'=>ENV['UBUNTU_GPG_KEY'],
                        'UBUNTU_KEY_SERV'=>ENV['UBUNTU_KEY_SERV']},
                      :args=>'-d'
  config.vm.provision :unix_reboot
  config.vm.provision :shell, # dvm
            privileged:false,
                  path:ENV['VM_BOOT'],
                   env:{'DOCKER_VERSION'=>ENV['DOCKER_VERSION'],
                        'DVM_ACTIVATE'=>ENV['DVM_ACTIVATE'],
                        'DVM_INSTALL'=>ENV['DVM_INSTALL'],
                        'VM_BASHRC'=>ENV['VM_BASHRC']},
                      :args=>'-b'
  config.vm.provision :shell, # compose
                  path:ENV['VM_BOOT'],
                      :args=>'-z'
  config.vm.provision :shell, # flask
                  path:ENV['VM_BOOT'],
                   env:{'DOCKER_PY_PATH'=>ENV['DOCKER_PY_PATH']},
                      :args=>'-f'

  if ENV['SERVER'] != '0'
    config.vm.provision :shell, # jupyter
                    path:ENV['VM_BOOT'],
                        :args => '-j'
  end

end
