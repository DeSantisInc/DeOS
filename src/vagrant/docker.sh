#!/usr/bin/env bash

printd() { printf "\x1b[34;01m########[ $1 ]########\x1b[34;01m\n"; echo "$1" | bash; }

printd "sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D"

printd "sudo apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main'"

printd "sudo apt-get update"

printd "apt-cache policy docker-engine"

printd "sudo apt-get install -y docker-engine"

printd "sudo systemctl status docker"

printd 'sudo usermod -aG docker $(whoami)'

printd "docker run hello-world"
