include .deosrc

all: run #vm ssh #build; @($(DEOS) && echo)

run: venv
	@echo $@

venv:
	@echo $@

main:
	-(rm -rf $(BIN)/main*)
	($(CC) -std=c89 -Wall -g -pthread -I$(LIB) $(SRC)/main.c -o $(BIN)/main)
	(chmod +x $(BIN)/main)
	($(BIN)/main)

alt: _all

app:; electron ./app/

build: chmod check

check: deos.check; @(echo)

chmod:; (chmod +x $(PRINT) $(DEOS))

ext: ext.bitcoin ext.two1

install:; (yarn global add electron)

js:; (yarn run gulp && yarn run test)

rm: vm.uninstall

sh: vm.ssh

vm: vm.install

zt: zt.install
