#!/usr/bin/env bash

printd() { printf "\x1b[34;01m########[ $1 ]########\x1b[34;01m\n"; echo "$1" | bash; }

printd 'curl -L https://github.com/docker/compose/releases/download/1.9.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose'

printd "chmod +x /usr/local/bin/docker-compose"
