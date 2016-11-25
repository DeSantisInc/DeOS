export MAKEFLAGS=--no-print-directory

.DEFAULT_GOAL:=all

.PHONY: all build logic ssh start vm

.SUBLIME_TARGETS: all

include .deosrc

all: logic

down:; (vagrant destroy DeVM)

git:; (cd ./ext/DeGIT && make all)

ssh:; (vagrant ssh -c $(VM_CMD) DeVM)

start:; (yarn start)

test:; (yarn test)

travis: logic.travis

vm:; (vagrant up; $(MAKE) ssh)

webpack:; (yarn all)
