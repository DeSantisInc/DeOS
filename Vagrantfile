# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network :forwarded_port, guest: 80, host: 4567
  config.vm.network :forwarded_port, guest: 8888, host: 8888
  config.vm.provision :shell, inline: <<-SHELL
    sudo apt-get update
    sudo apt-get install -y build-essential
    sudo apt-get install -y libssl-dev
  SHELL
  config.vm.provision :shell, inline: <<-SHELL
    sudo apt-get install -y nginx
    rm /etc/nginx/nginx.conf
    ln -s /vagrant/etc/nginx/nginx.conf /etc/nginx/nginx.conf
    if ! [ -L /etc/nginx/sites-available/default ]; then
      rm -rf /etc/nginx/sites-available/default
      ln -s /vagrant/etc/nginx/sites-available/deos.conf /etc/nginx/sites-available/deos.conf
    fi
  SHELL
  config.vm.provision :shell, inline: <<-SHELL
    sudo apt-get install -y python2.7 python-pip python-dev
    sudo apt-get -y install ipython ipython-notebook
    sudo -H pip install --upgrade pip
    sudo -H pip install jupyter
    sudo -H pip install ipyparallel
    sudo ipcluster nbextension enable
  SHELL
  config.vm.provision :shell, privileged: false, inline: <<-SHELL
    cd /home/vagrant
    wget -qO- https://raw.github.com/creationix/nvm/v0.32.1/install.sh | sh
    export NVM_DIR="/home/vagrant/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    cd /vagrant && nvm install && nvm use
  SHELL
  config.vm.provision :shell, privileged: false, run: "always", inline: <<-SHELL
    jupyter notebook --notebook-dir=/vagrant/var/notebook --no-browser --ip=0.0.0.0 &
  SHELL
end
