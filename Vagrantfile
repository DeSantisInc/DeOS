# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
  config.ssh.paranoid = true
  config.vm.box = "bento/ubuntu-16.04"
  config.vm.define :DeVM do |t| end
  config.vm.network :forwarded_port, guest:5000, host:1335
  config.vm.network :forwarded_port, guest:8888, host:1336
  config.vm.network :forwarded_port, guest:80, host:1337
  config.vm.provision :shell, path: "./src/devm/bootstrap.sh", :args => "-c"
  config.vm.provision :shell, path: "./src/devm/bootstrap.sh", :args => "-n"
  config.vm.provision :shell, path: "./src/devm/bootstrap.sh", :args => "-u"
  config.vm.provision :shell, path: "./src/devm/bootstrap.sh", :args => "-y"
  config.vm.provision :shell, path: "./src/devm/bootstrap.sh", :args => "-x"
  config.vm.provision :shell, path: "./src/devm/bootstrap.sh", :args => "-p"
  config.vm.provision :shell, path: "./src/devm/bootstrap.sh", :args => "-d"
  config.vm.provision :shell, path: "./src/devm/bootstrap.sh", :args => "-z"
  config.vm.provision :shell, path: "./src/devm/bootstrap.sh", :args => "-f"
  config.vm.provision :shell, path: "./src/devm/bootstrap.sh", :args => "-j"
end
