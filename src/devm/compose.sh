#!/usr/bin/env bash

printd() { printf "\x1b[34;01m########[ $1 ]########\x1b[34;01m\n"; echo "$1" | bash; }

printd "sudo apt-get install -y python-pip"

printd "sudo pip install docker-compose"

printd "docker-compose -h"

exit 0
