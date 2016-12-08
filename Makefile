include .deosrc

all: run #vm ssh #build; @($(DEOS) && echo)

run: venv
	(python $(SRC)/main.py)

venv:
ifeq ($(HOST_OS), $(IS_MAC))
	-rm -rf $(VENV)/darwin/python/
	cd $(VENV)/darwin/ && virtualenv python
	cp $(SRC)/templates/dotfiles/gitignore.txt $(VENV)/darwin/python/.gitignore
ifeq ($(HOST_OS), $(IS_LINUX))
	@echo $@-linux
else
	@echo "Your platform, $(HOST_OS), is not supported."
endif

main:
	-(rm -rf $(BIN)/main*)
	($(CC) -std=c89 -Wall -g -pthread -I$(LIB) $(SRC)/main.c -o $(BIN)/main)
	(chmod +x $(BIN)/main)
	($(BIN)/main)

picocoin:
	@echo $@

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
