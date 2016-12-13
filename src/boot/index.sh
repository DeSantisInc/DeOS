#!/usr/bin/env bash

RUN() {
  printf "\x1b[34;01mΔ => [ $1 ]\x1b[34;01m\n"
  echo "$1" | bash
}

ADD_REPO() {
  RUN "add-apt-repository $1"
}

INSTALL() {
  RUN "apt-get -y install $1 $DeOS_BOOT_DEBUG"
}

MAINTAINER() {
  echo "$1" > /dev/null
}

UPDATE() {
  RUN "apt-get update"
}

UPGRADE() {
  RUN "apt-get -y upgrade $DeOS_BOOT_DEBUG"
}

EXIT_SUCCESS() {
  exit 0
}

for op in RUN ADD_REPO INSTALL MAINTAINER UPDATE UPGRADE EXIT_SUCCESS; do
  export -f $op
done

while getopts abcnuyvxpdzfjr x; do
  case "$x" in
    a)  (chmod +x "$DeOS_BOOT_PATH/bootstrap.sh")
        (exec "$DeOS_BOOT_PATH/bootstrap.sh") ;;
    b)  (chmod +x "$DeOS_BOOT_PATH/bitcoin.sh")
        (exec "$DeOS_BOOT_PATH/bitcoin.sh") ;;
    c)  (chmod +x "$DeOS_BOOT_PATH/python.sh")
        (exec "$DeOS_BOOT_PATH/python.sh") ;;
    n)  (chmod +x "$DeOS_BOOT_PATH/node.sh")
        (exec "$DeOS_BOOT_PATH/node.sh") ;;
    u)  (chmod +x "$DeOS_BOOT_PATH/nvm.sh")
        (exec "$DeOS_BOOT_PATH/nvm.sh") ;;
    y)  (chmod +x "$DeOS_BOOT_PATH/yarn.sh")
        (exec "$DeOS_BOOT_PATH/yarn.sh") ;;
    x)  (chmod +x "$DeOS_BOOT_PATH/nginx.sh")
        (exec "$DeOS_BOOT_PATH/nginx.sh") ;;
    r)  (chmod +x "$DeOS_BOOT_PATH/virtualenv.sh")
        (exec "$DeOS_BOOT_PATH/virtualenv.sh") ;;
    m)  (chmod +x "$DeOS_BOOT_PATH/dvm.sh")
        (exec "$DeOS_BOOT_PATH/dvm.sh") ;;
    d)  (chmod +x "$DeOS_BOOT_PATH/docker.sh")
        (exec "$DeOS_BOOT_PATH/docker.sh") ;;
    v)  (chmod +x "$DeOS_BOOT_PATH/zerotier.sh")
        (exec "$DeOS_BOOT_PATH/zerotier.sh") ;;
    z)  (chmod +x "$DeOS_BOOT_PATH/compose.sh")
        (exec "$DeOS_BOOT_PATH/compose.sh") ;;
    f)  (chmod +x "$DeOS_BOOT_PATH/flask.sh")
        (exec "$DeOS_BOOT_PATH/flask.sh") ;;
    j)  (chmod +x "$DeOS_BOOT_PATH/jupyter.sh")
        (exec "$DeOS_BOOT_PATH/jupyter.sh") ;;
    ?)  EXIT_SUCCESS ;;
  esac
done
