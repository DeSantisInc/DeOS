export MAKEFLAGS=--no-print-directory

.DEFAULT_GOAL:=all
.PHONY: all build dev logic ssh test
.SUBLIME_TARGETS: all

include .deosrc

all: logic

travis: logic.travis

dev: #down
	vagrant up
	$(MAKE) ssh

ssh:
	vagrant ssh -c "cd /vagrant; bash -i -c 'ipython --profile=vagrant'" DeVM

down:
	vagrant destroy DeVM
