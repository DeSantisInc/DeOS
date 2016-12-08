sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee /etc/apt/sources.list.d/docker.list
RUN "sudo apt-get update"
RUN "sudo apt-get -y install linux-image-extra-$(uname -r)"
RUN "sudo apt-get -y install linux-image-extra-virtual 2> /dev/null"
RUN "sudo apt-get -y install docker-engine 2> /dev/null"
RUN "sudo service docker start"
RUN "sudo usermod -aG docker vagrant"
RUN "sudo systemctl enable docker"
EXIT_SUCCESS
