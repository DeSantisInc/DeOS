# -*- mode: ruby -*-
# vi: set ft=ruby :

require './src/devm/plugins/vagrant-provision-reboot-plugin'

Vagrant.configure("2") do |config|

  config.ssh.paranoid = true

  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  config.vm.box = "bento/ubuntu-16.04"

  config.vm.define :DeVM do |t| end

  config.vm.network :forwarded_port, guest:80, host:1337

  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.synced_folder ".", "/deos"

  config.vm.provision :shell, path: "./src/devm/bootstrap.sh",
                      :args => "-c" # common

  config.vm.provision :unix_reboot

  config.vm.provision :shell, path: "./src/devm/bootstrap.sh",
                      :args => "-x" # nginx

end

#config.vm.network :forwarded_port, guest:5000, host:1335
#config.vm.network :forwarded_port, guest:8888, host:1336
#config.vm.provision :shell, path: "./src/devm/bootstrap.sh", :args => "-u"
#config.vm.provision :shell, path: "./src/devm/bootstrap.sh", :args => "-y"
#config.vm.provision :shell, path: "./src/devm/bootstrap.sh", :args => "-n"
#config.vm.provision :shell, path: "./src/devm/bootstrap.sh", :args => "-p"
#config.vm.provision :shell, path: "./src/devm/bootstrap.sh", :args => "-d"
#config.vm.provision :shell, path: "./src/devm/bootstrap.sh", :args => "-z"
#config.vm.provision :shell, path: "./src/devm/bootstrap.sh", :args => "-f"
#config.vm.provision :shell, path: "./src/devm/bootstrap.sh", :args => "-j"
