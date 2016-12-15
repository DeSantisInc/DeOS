Δ with (data=None)

include src/host/common.mk

BASEDIR:=$(CURDIR)
BIN:=$(BASEDIR)/bin

#[config]
export DeOS_CONFIG_DEBUG:=$(Δ(data['deos']['config']['debug']))
export DeOS_CONFIG_FASTBOOT:=$(Δ(data['deos']['config']['fastboot']))

#[boot]
export DeOS_BOOT_ARGS_BITCOIN:=Δ(data['deos']['boot']['args']['bitcoin'])
export DeOS_BOOT_ARGS_BLOCKSTACK:=Δ(data['deos']['boot']['args']['blockstack'])
export DeOS_BOOT_ARGS_BOOTSTRAP:=Δ(data['deos']['boot']['args']['bootstrap'])
export DeOS_BOOT_ARGS_DOCKER:=Δ(data['deos']['boot']['args']['docker'])
export DeOS_BOOT_ARGS_NGINX:=Δ(data['deos']['boot']['args']['nginx'])
export DeOS_BOOT_ARGS_PYTHON:=Δ(data['deos']['boot']['args']['python'])
ifeq ($(DeOS_CONFIG_DEBUG),$(IS_TRUE))
export DeOS_BOOT_DEBUG:=
else
export DeOS_BOOT_DEBUG:=2> /dev/null
endif
export DeOS_BOOT_PATH:=Δ(data['deos']['boot']['path'])
export DeOS_BOOT_SCRIPT:=Δ(data['deos']['boot']['script'])

#[build]
ifeq ($(DeOS_CONFIG_FASTBOOT),$(IS_TRUE))
export DeOS_BUILD_APT_UPGRADE:=$(FALSE)
else
export DeOS_BUILD_APT_UPGRADE:=$(TRUE)
endif
export DeOS_BUILD_BITCOIN:=$(Δ(data['deos']['build']['bitcoin']))
export DeOS_BUILD_BLOCKSTACK:=$(Δ(data['deos']['build']['blockstack']))
export DeOS_BUILD_DOCKER:=$(Δ(data['deos']['build']['docker']))
export DeOS_BUILD_NGINX:=$(Δ(data['deos']['build']['nginx']))
export DeOS_BUILD_PYTHON:=$(Δ(data['deos']['build']['python']))

#[cmd]
ifeq ($(DeOS_CONFIG_FASTBOOT),$(IS_TRUE))
export DeOS_CMD_APT_UPGRADE:=echo 'FASTBOOT!'
else
export DeOS_CMD_APT_UPGRADE:=apt-get -y upgrade $(DeOS_BOOT_DEBUG)
endif

#[host]
export DeOS_HOST_OS:=$(shell uname -s)

#[run]
export DeOS_RUN_SERVER:=$(FALSE)

#[vm]
export DeOS_VM_BOX:=bento/ubuntu-16.04
export DeOS_VM_PATH:=/deos
export DeOS_VM_PATH_ZT:=/var/lib/zerotier-one
export DeOS_VM_USER:=vagrant
export DeOS_VM_SHELL_DEFAULT:=bash -c 'BASH_ENV=/etc/profile exec bash'
export DeOS_VM_SHELL_SSH:=bash -l
