#!/usr/bin/env bash

DERUN() {
  printf "\x1b[34;01m########[ $1 ]########\x1b[34;01m\n"
  echo "$1" | bash
}

EXIT_SUCCESS() {
  exit 0
}

export -f DERUN
export -f EXIT_SUCCESS

while getopts cnuyxpdzfj x
do
  case "$x" in
    c)  (chmod +x "/vagrant/src/devm/common.sh")
        (exec "/vagrant/src/devm/common.sh") ;;
    n)  (chmod +x "/vagrant/src/devm/node.sh")
        (exec "/vagrant/src/devm/node.sh") ;;
    u)  (chmod +x "/vagrant/src/devm/nvm.sh")
        (exec "/vagrant/src/devm/nvm.sh") ;;
    y)  (chmod +x "/vagrant/src/devm/yarn.sh")
        (exec "/vagrant/src/devm/yarn.sh") ;;
    x)  (chmod +x "/vagrant/src/devm/nginx.sh")
        (exec "/vagrant/src/devm/nginx.sh") ;;
    p)  (chmod +x "/vagrant/src/devm/python.sh")
        (exec "/vagrant/src/devm/python.sh") ;;
    d)  (chmod +x "/vagrant/src/devm/docker.sh")
        (exec "/vagrant/src/devm/docker.sh") ;;
    z)  (chmod +x "/vagrant/src/devm/compose.sh")
        (exec "/vagrant/src/devm/compose.sh") ;;
    f)  (chmod +x "/vagrant/src/devm/flask.sh")
        (exec "/vagrant/src/devm/flask.sh") ;;
    j)  (chmod +x "/vagrant/src/devm/jupyter.sh")
        (exec "/vagrant/src/devm/jupyter.sh") ;;
    ?)  EXIT_SUCCESS ;;
  esac
done
