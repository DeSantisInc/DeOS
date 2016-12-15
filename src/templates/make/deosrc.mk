Δ with (data=None)

include src/host/common.mk

BASEDIR:=$(CURDIR)
BIN:=$(BASEDIR)/bin

export DeOS_BOOT_ARGS_BITCOIN:=-b
export DeOS_BOOT_ARGS_BLOCKSTACK:=-d
export DeOS_BOOT_ARGS_BOOTSTRAP:=-a test
export DeOS_BOOT_ARGS_DOCKER:=-f
export DeOS_BOOT_ARGS_NGINX:=-e
export DeOS_BOOT_ARGS_PYTHON:=-c
export DeOS_BOOT_PATH:=/deos/src/boot
export DeOS_BOOT_SCRIPT:=./src/boot/index.sh
export DeOS_BUILD_BITCOIN:=$(FALSE)
export DeOS_BUILD_BLOCKSTACK:=$(FALSE)
export DeOS_BUILD_DOCKER:=$(FALSE)
export DeOS_BUILD_NGINX:=$(TRUE)
export DeOS_BUILD_PYTHON:=$(FALSE)
export DeOS_CONFIG_DEBUG:=$(FALSE)
export DeOS_CONFIG_FASTBOOT:=$(TRUE)
export DeOS_HOST_OS:=$(shell uname -s)
export DeOS_RUN_SERVER:=$(FALSE)
export DeOS_VM_BOX:=bento/ubuntu-16.04
export DeOS_VM_PATH:=/deos
export DeOS_VM_PATH_ZT:=/var/lib/zerotier-one
export DeOS_VM_USER:=vagrant
export DeOS_VM_SHELL_DEFAULT:=bash -c 'BASH_ENV=/etc/profile exec bash'
export DeOS_VM_SHELL_SSH:=bash -l

ifeq ($(DeOS_CONFIG_DEBUG),$(IS_TRUE))
export DeOS_BOOT_DEBUG:=
else
export DeOS_BOOT_DEBUG:=2> /dev/null
endif

ifeq ($(DeOS_CONFIG_FASTBOOT),$(IS_TRUE))
export DeOS_BUILD_APT_UPGRADE:=$(FALSE)
export DeOS_CMD_APT_UPGRADE:=echo 'FASTBOOT!'
else
export DeOS_BUILD_APT_UPGRADE:=$(TRUE)
export DeOS_CMD_APT_UPGRADE:=apt-get -y upgrade $(DeOS_BOOT_DEBUG)
endif

###

export BUILDDOCKER:=$(FALSE)
export BUILDJS:=$(FALSE)
export BUILDNGINX:=$(FALSE)
export BUILDZT:=$(FALSE)
export BUILDNOTEBOOK:=$(FALSE)
export DeOS_FILESYNC:=$(TRUE)

export BOOT:=$(BASEDIR)/boot
DELTA:=$(BASEDIR)/bin/delta
DEOS:=$(BASEDIR)/bin/deos
LIB:=$(BASEDIR)/lib
PRINT:=$(BASEDIR)/bin/printm
SRC:=$(BASEDIR)/src
STATIC:=$(BASEDIR)/static
VENV:=$(BASEDIR)/.deos/venv

export VM_BASHRC:=/home/$(DeOS_VM_USER)/.bashrc
export VM_PATH_NVM:=/home/$(DeOS_VM_USER)/.nvm

export DeOS_VM_PORT_GUEST_0:=1337
export DeOS_VM_PORT_HOST_0:=80
export DeOS_VM_PORT_GUEST_1:=5000
export DeOS_VM_PORT_HOST_1:=1335
export DeOS_VM_PORT_GUEST_2:=8888
export DeOS_VM_PORT_HOST_2:=1336

export DOCKER_APT_REPO:=https://apt.dockerproject.org/repo
export DOCKER_GPG_KEY:=58118E89F3A912897C070ADBF76221572C52609D
export DOCKER_KEY_SERV:=hkp://ha.pool.sks-keyservers.net:80
export DOCKER_PY_PATH:=/deos/var/docker/python
export DOCKER_UBUNTU:=ubuntu-xenial
export DOCKER_SOURCES:=/etc/apt/sources.list.d/docker.list
export DOCKER_VERSION:=1.8.2

export DVM_ACTIVATE:=/home/$(DeOS_VM_USER)/.dvm/dvm.sh
export DVM_INSTALL:=https://download.getcarina.com/dvm/latest/install.sh

export NODE_INSTALL:=https://deb.nodesource.com/setup_7.x
export NVM_GIT_REPO:=https://github.com/creationix/nvm.git

export UBUNTU_GPG_KEY:=F76221572C52609D
export UBUNTU_KEY_SERV:=keyserver.ubuntu.com

export ZT_GPG_KEY:=https://raw.githubusercontent.com/zerotier/ZeroTierOne/master/doc/contact%40zerotier.com.gpg
export ZT_INSTALL:=https://install.zerotier.com/
export ZT_INSTALL_TMP:=/tmp/zt-install.sh
export ZT_NETWORK:=565799d8f6747f84

SSHCMD:="cd /deos; bash -i -c 'source venv/linux/python/bin/activate && bash'"
UPCMD:="vagrant up --provider virtualbox"
VMCMD:="cd /deos; bash -i -c 'ipython --profile=deos'"
GIT_BITCOIN:=git@github.com:DeSantisInc/bitcoin.git

FILES:=\
.deosrc\
.editorconfig\
.gitattributes\
.gitignore\
.nvmrc\
.travis.yml\
LICENSE.md\
Makefile\
README.md\
Vagrantfile\
yarn.lock\
app/yarn.lock\
bin/deos\
bin/logic\
bin/printm\
src/deos/logic.mk\
src/deos/test.mk\
src/flow/css-modules.js\
src/ipython/ipython_config.py\
src/atdlib.h\
src/deArray.c\
src/deArray.h\
src/deContainer.c\
src/deContainer.h\
src/deGroup.c\
src/deGroup.h\
src/deList.c\
src/deList.h\
src/deListNode.c\
src/deListNode.h\
src/deNetwork.c\
src/deNetwork.h\
src/main.c\
var/assets/icons/512x512.png\
var/build/es5/.gitkeep\
var/build/obj/.gitkeep

include src/host/index.mk
