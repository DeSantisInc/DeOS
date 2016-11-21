export MAKEFLAGS=--no-print-directory

.DEFAULT_GOAL:=all
.PHONY: all build dev logic ssh test
.SUBLIME_TARGETS: all

include .deosrc

all: logic

test:
	nvm --version

build:
	@chmod +x $(PRINT)
	@$(PRINT) yellow $@ start
	$(CC) -std=c89 -Wall -g -pthread $(PATH_DOJO)/main.c -o $(PATH_BIN)/deos
	chmod +x $(PATH_BIN)/deos
	@$(PRINT) yellow $@ stop

dev: #down
	vagrant up
	$(MAKE) ssh

ssh:
	vagrant ssh -c "cd /vagrant; bash -i -c 'ipython --profile=vagrant'" DeVM

down:
	vagrant destroy DeVM
