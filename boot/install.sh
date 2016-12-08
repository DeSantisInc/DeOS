#!/usr/bin/env bash

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
    n)  (chmod +x "/deos/boot/node.sh")
        (exec "/deos/boot/node.sh") ;;
    u)  (chmod +x "/deos/boot/nvm.sh")
        (exec "/deos/boot/nvm.sh") ;;
    y)  (chmod +x "/deos/boot/yarn.sh")
        (exec "/deos/boot/yarn.sh") ;;
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
    z)  (chmod +x "/deos/boot/compose.sh")
        (exec "/deos/boot/compose.sh") ;;
    f)  (chmod +x "/deos/boot/flask.sh")
        (exec "/deos/boot/flask.sh") ;;
    j)  (chmod +x "/deos/boot/jupyter.sh")
        (exec "/deos/boot/jupyter.sh") ;;
    ?)  EXIT_SUCCESS ;;
  esac
done
