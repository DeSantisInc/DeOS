export MAKEFLAGS=--no-print-directory

.DEFAULT_GOAL:=all

.PHONY:all build chmod clean install main run venv

.SUBLIME_TARGETS:all

include .deosrc

all: build
	@$(PRINT) cyan $@ start
ifeq ($(DeOS_HOST_OS),$(IS_MAC))
	@echo $@
else
	@(echo "'make $@' isn't yet supported on $(DeOS_HOST_OS).")
endif
	@$(PRINT) cyan $@ stop

build: clean check
	@$(PRINT) cyan $@ start
ifeq ($(DeOS_HOST_OS),$(IS_MAC))
	-$(MAKE) vm
else
	@(echo "'make $@' isn't yet supported on $(DeOS_HOST_OS).")
endif
	@$(PRINT) cyan $@ stop

clean: chmod
	@$(PRINT) cyan $@ start
ifeq ($(DeOS_HOST_OS),$(IS_MAC))
	-$(MAKE) rm
else
	@(echo "'make $@' isn't yet supported on $(DeOS_HOST_OS).")
endif
	@$(PRINT) cyan $@ stop

chmod:
	@$(PRINT) cyan $@ start
ifeq ($(DeOS_HOST_OS),$(IS_MAC))
	@-chmod +x $(PRINT) $(DEOS)
else
	@(echo "'make $@' isn't yet supported on $(DeOS_HOST_OS).")
endif
	@$(PRINT) cyan $@ stop

check:
	@$(PRINT) cyan $@ start
ifeq ($(DeOS_HOST_OS),$(IS_MAC))
	-$(MAKE) deos.check
else
	@(echo "'make $@' isn't yet supported on $(DeOS_HOST_OS).")
endif
	@$(PRINT) cyan $@ stop

rm:
	@$(PRINT) cyan $@ start
ifeq ($(DeOS_HOST_OS),$(IS_MAC))
	-$(MAKE) vm.uninstall
else
	@(echo "'make $@' isn't yet supported on $(DeOS_HOST_OS).")
endif
	@$(PRINT) cyan $@ stop

sh:
	@$(PRINT) cyan $@ start
ifeq ($(DeOS_HOST_OS),$(IS_MAC))
	-$(MAKE) vm.ssh
else
	@(echo "'make $@' isn't yet supported on $(DeOS_HOST_OS).")
endif
	@$(PRINT) cyan $@ stop

vm:
	@$(PRINT) cyan $@ start
ifeq ($(DeOS_HOST_OS),$(IS_MAC))
	-$(MAKE) vm.install
else
	@(echo "'make $@' isn't yet supported on $(DeOS_HOST_OS).")
endif
	@$(PRINT) cyan $@ stop

zt:
	@$(PRINT) cyan $@ start
ifeq ($(DeOS_HOST_OS),$(IS_MAC))
	-$(MAKE) zt.install
else
	@(echo "'make $@' isn't yet supported on $(DeOS_HOST_OS).")
endif
	@$(PRINT) cyan $@ stop

###

run: venv
	@$(PRINT) yellow $@ start
ifeq ($(DeOS_HOST_OS),$(IS_MAC))
	(python $(SRC)/main.py)
else
	@(echo "'make $@' isn't yet supported on $(DeOS_HOST_OS).")
endif
	@$(PRINT) yellow $@ stop

venv:
	@$(PRINT) yellow $@ start
ifeq ($(DeOS_HOST_OS),$(IS_MAC))
	@-(rm -rf $(VENV)/darwin/python/)
	(cd $(VENV)/darwin/ && virtualenv python --no-site-packages)
	(cp $(SRC)/templates/dotfiles/gitignore.txt \
		$(VENV)/darwin/python/.gitignore)
else
	@(echo "'make $@' isn't yet supported on $(DeOS_HOST_OS).")
endif
	@$(PRINT) yellow $@ stop

main:
	@$(PRINT) yellow $@ start
	@-(rm -rf $(BIN)/main*)
	($(CC) -std=c89 -Wall -g -pthread -I$(LIB) $(SRC)/main.c -o $(BIN)/main)
	(chmod +x $(BIN)/main)
	($(BIN)/main)
	@$(PRINT) yellow $@ stop

app:; electron ./app/

ext: ext.bitcoin ext.two1

install:; (yarn global add electron)

js:; (yarn run gulp && yarn run test)
