#!/usr/bin/env bash

RUN(){(printf "\x1b[34;01mΔ => [ $1 ]\x1b[34;01m\n"; echo "$1" | bash)}
ADD_REPO(){(RUN "add-apt-repository $1")}
INSTALL(){(RUN "apt-get -y install $1 $BOOT_DEBUG")}
MAINTAINER(){(echo "$1" > /dev/null)}
UPDATE(){(RUN "apt-get update")}
UPGRADE(){(RUN "apt-get -y upgrade $BOOT_DEBUG")}
EXIT_SUCCESS(){(exit 0)}

for op in RUN ADD_REPO INSTALL MAINTAINER UPDATE UPGRADE EXIT_SUCCESS; do
  export -f $op
done

while getopts abcnuyvxpdzfjr x; do
  case "$x" in
    a)  (chmod +x "/deos/src/boot/bootstrap.sh")
        (exec "/deos/src/boot/bootstrap.sh") ;;
    b)  (chmod +x "/deos/src/boot/bitcoin.sh")
        (exec "/deos/src/boot/bitcoin.sh") ;;
    n)  (chmod +x "/deos/src/boot/node.sh")
        (exec "/deos/src/boot/node.sh") ;;
    u)  (chmod +x "/deos/src/boot/nvm.sh")
        (exec "/deos/src/boot/nvm.sh") ;;
    y)  (chmod +x "/deos/src/boot/yarn.sh")
        (exec "/deos/src/boot/yarn.sh") ;;
    x)  (chmod +x "/deos/src/boot/nginx.sh")
        (exec "/deos/src/boot/nginx.sh") ;;
    p)  (chmod +x "/deos/src/boot/python.sh")
        (exec "/deos/src/boot/python.sh") ;;
    r)  (chmod +x "/deos/src/boot/virtualenv.sh")
        (exec "/deos/src/boot/virtualenv.sh") ;;
    m)  (chmod +x "/deos/src/boot/dvm.sh")
        (exec "/deos/src/boot/dvm.sh") ;;
    d)  (chmod +x "/deos/src/boot/docker.sh")
        (exec "/deos/src/boot/docker.sh") ;;
    v)  (chmod +x "/deos/src/boot/zerotier.sh")
        (exec "/deos/src/boot/zerotier.sh") ;;
    z)  (chmod +x "/deos/src/boot/compose.sh")
        (exec "/deos/src/boot/compose.sh") ;;
    f)  (chmod +x "/deos/src/boot/flask.sh")
        (exec "/deos/src/boot/flask.sh") ;;
    j)  (chmod +x "/deos/src/boot/jupyter.sh")
        (exec "/deos/src/boot/jupyter.sh") ;;
    ?)  EXIT_SUCCESS ;;
  esac
done
