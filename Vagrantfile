# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "bento/ubuntu-16.04"
  config.vm.network :forwarded_port, guest:80, host:1337
  config.vm.network :forwarded_port, guest:8888, host:1321
  config.vm.define :DeVM do |t| end

  config.vm.provision :shell, inline:<<-SHELL
    curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb http://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt-get update
    sudo apt-get install -y build-essential
    sudo apt-get install -y llvm
    sudo apt-get install -y clang-3.4
    sudo apt-get install -y ntp
    sudo apt-get install -y libffi-dev
    sudo apt-get install -y libssl-dev
    sudo apt-get install -y apt-transport-https
    sudo apt-get install -y ca-certificates
    sudo apt-get install -y git
    sudo apt-get install -y nodejs
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash
    nvm install v7.0.0
    nvm use v7.0.0
    sudo apt-get install yarn
    export PATH="$PATH:`yarn global bin`"
  SHELL

  config.vm.provision :shell, inline:<<-SHELL
    sudo apt-get install -y nginx
    rm /etc/nginx/nginx.conf
    ln -s /vagrant/src/nginx/nginx.conf /etc/nginx/nginx.conf
    sudo service nginx reload
  SHELL

  config.vm.provision :shell, inline:<<-SHELL
    apt-get install -y python2.7
    apt-get install -y python-pip
    apt-get install -y python-dev
    apt-get install -y ipython
    apt-get install -y ipython-notebook
    pip install --upgrade pip
    pip install --upgrade pyopenssl
    pip install ndg-httpsclient
    pip install pyasn1
    pip install --upgrade requests[security]
    pip install jupyter
    pip install ipyparallel
    ipcluster nbextension enable
  SHELL

  config.vm.provision :shell, privileged:false, inline:<<-SHELL
    ipython profile create vagrant
    if ! [ -L /home/vagrant/.ipython/profile_vagrant/ipython_config.py ]; then
      rm /home/vagrant/.ipython/profile_vagrant/ipython_config.py
      ln -s /vagrant/src/ipython/ipython_config.py \
            /home/vagrant/.ipython/profile_vagrant/ipython_config.py
    fi
  SHELL

  config.vm.provision :shell, privileged:false, run:"always", inline:<<-SHELL
    jupyter notebook --notebook-dir=/vagrant/var/notebook \
                     --no-browser \
                     --ip=0.0.0.0 &
  SHELL
end
