# -*- mode: ruby -*-
# vi: set ft=ruby :

$rootScript = <<SCRIPT
  sudo apt-get update;
  sudo apt-get install -y build-essential;
  sudo apt-get install -y libssl-dev;

  # nginx
  sudo apt-get install -y nginx;
  rm /etc/nginx/nginx.conf;
  ln -s /vagrant/etc/nginx/nginx.conf /etc/nginx/nginx.conf;
  if ! [ -L /etc/nginx/sites-available/default ]; then
    rm -rf /etc/nginx/sites-available/default;
    ln -s /vagrant/etc/nginx/sites-available/deos.conf /etc/nginx/sites-available/deos.conf;
  fi

  # docker
  sudo apt-get install -y apt-transport-https;
  sudo apt-get install -y ca-certificates;
  sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D;
  echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | sudo tee /etc/apt/sources.list.d/docker.list;
  sudo apt-get update;
  sudo apt-cache policy docker-engine;
  sudo apt-get install -y docker-engine;
  sudo service docker start;
  sudo docker run hello-world;
SCRIPT

$userScript = <<SCRIPT
  cd /home/vagrant

  # Installing nvm
  wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | sh

  # This enables NVM without a logout/login
  export NVM_DIR="/home/vagrant/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

  # Install a node and alias
  nvm install 0.10.33
  nvm alias default 0.10.33

  # You can also install other stuff here
  npm install -g bower ember-cli
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.provision :shell, inline: $rootScript
  config.vm.provision :shell, inline: $userScript, privileged: false
  config.vm.network :forwarded_port, guest: 80, host: 4567
end
