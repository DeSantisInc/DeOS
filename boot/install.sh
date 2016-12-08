#!/usr/bin/env bash

DERUN() {
  printf "\x1b[34;01mΔ => [ $1 ]\x1b[34;01m\n"
  echo "$1" | bash
}

RUN() {
  printf "\x1b[34;01mΔ => [ $1 ]\x1b[34;01m\n"
  echo "$1" | bash
}

EXIT_SUCCESS() {
  exit 0
}

export -f DERUN
export -f RUN
export -f EXIT_SUCCESS

while getopts cnuyvxpdbzfj x
do
  case "$x" in
    c)  (chmod +x "/deos/boot/bootstrap.sh")
        (exec "/deos/boot/bootstrap.sh") ;;
    n)  (chmod +x "/deos/src/devm/node.sh")
        (exec "/deos/src/devm/node.sh") ;;
    u)  (chmod +x "/deos/src/devm/nvm.sh")
        (exec "/deos/src/devm/nvm.sh") ;;
    y)  (chmod +x "/deos/src/devm/yarn.sh")
        (exec "/deos/src/devm/yarn.sh") ;;
    x)  (chmod +x "/deos/boot/nginx.sh")
        (exec "/deos/boot/nginx.sh") ;;
    p)  (chmod +x "/deos/boot/python.sh")
        (exec "/deos/boot/python.sh") ;;
    b)  (chmod +x "/deos/boot/dvm.sh")
        (exec "/deos/boot/dvm.sh") ;;
    d)  (chmod +x "/deos/boot/docker.sh")
        (exec "/deos/boot/docker.sh") ;;
    v)  (chmod +x "/deos/boot/zerotier.sh")
        (exec "/deos/boot/zerotier.sh") ;;
    z)  (chmod +x "/deos/src/devm/compose.sh")
        (exec "/deos/src/devm/compose.sh") ;;
    f)  (chmod +x "/deos/src/devm/flask.sh")
        (exec "/deos/src/devm/flask.sh") ;;
    j)  (chmod +x "/deos/boot/jupyter.sh")
        (exec "/deos/boot/jupyter.sh") ;;
    ?)  EXIT_SUCCESS ;;
  esac
done
