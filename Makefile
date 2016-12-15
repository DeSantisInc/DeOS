export MAKEFLAGS=--no-print-directory

.DEFAULT_GOAL:=all

.PHONY:all bin build check chmod clean init rm sh venv vm

.SUBLIME_TARGETS:all

include .deosrc

all: init clean check build
	@$(PRINT) cyan $@ start
ifeq ($(DeOS_HOST_OS),$(IS_MAC))
	@(echo $@)
else
	@(echo "'make $@' isn't yet supported on $(DeOS_HOST_OS).")
endif
	@$(PRINT) cyan $@ stop

init:
ifeq ($(DeOS_HOST_OS),$(IS_MAC))
	@-$(MAKE) bin
	@-$(MAKE) chmod
else
	@(echo "'make $@' isn't yet supported on $(DeOS_HOST_OS).")
endif

bin:
	@$(PRINT) cyan $@ start
ifeq ($(DeOS_HOST_OS),$(IS_MAC))
	@echo $@
else
	@(echo "'make $@' isn't yet supported on $(DeOS_HOST_OS).")
endif
	@$(PRINT) cyan $@ stop

chmod:
ifeq ($(DeOS_HOST_OS),$(IS_MAC))
	@-chmod +x $(PRINT) $(DEOS)
else
	@(echo "'make $@' isn't yet supported on $(DeOS_HOST_OS).")
endif

build: venv
	@$(PRINT) cyan $@ start
ifeq ($(DeOS_HOST_OS),$(IS_MAC))
	-mkdir $(BASEDIR)/config/nginx/
	-$(MAKE) vm
else
	@(echo "'make $@' isn't yet supported on $(DeOS_HOST_OS).")
endif
	@$(PRINT) cyan $@ stop

clean:
	@$(PRINT) magenta $@ start
ifeq ($(DeOS_HOST_OS),$(IS_MAC))
	@-$(MAKE) rm
	@-rm -rf $(BASEDIR)/.blockstack/
	@-rm -rf $(BASEDIR)/.vagrant/
	@-rm -rf $(BASEDIR)/.zerotier/
	@-rm -rf $(BASEDIR)/config/nginx/
	@-rm -rf $(VENV)/darwin/default/
	@-rm -rf $(VENV)/linux/default/
else
	@(echo "'make $@' isn't yet supported on $(DeOS_HOST_OS).")
endif
	@$(PRINT) magenta $@ stop

check:
	@$(PRINT) cyan $@ start
ifeq ($(DeOS_HOST_OS),$(IS_MAC))
	@-$(MAKE) deos.check
else
	@(echo "'make $@' isn't yet supported on $(DeOS_HOST_OS).")
endif
	@$(PRINT) cyan $@ stop

venv:
	@$(PRINT) cyan $@ start
ifeq ($(DeOS_HOST_OS),$(IS_MAC))
	cd $(VENV)/darwin/ && virtualenv default --no-site-packages
	cp $(SRC)/templates/git/gitignore.txt \
	   $(VENV)/darwin/default/.gitignore
else
	@(echo "'make $@' isn't yet supported on $(DeOS_HOST_OS).")
endif
	@$(PRINT) cyan $@ stop

rm:
	@$(PRINT) yellow $@ start
ifeq ($(DeOS_HOST_OS),$(IS_MAC))
	-$(MAKE) vm.uninstall
else
	@(echo "'make $@' isn't yet supported on $(DeOS_HOST_OS).")
endif
	@$(PRINT) yellow $@ stop

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

#run: venv
#	@$(PRINT) yellow $@ start
#ifeq ($(DeOS_HOST_OS),$(IS_MAC))
#	(python $(SRC)/main.py)
#else
#	@(echo "'make $@' isn't yet supported on $(DeOS_HOST_OS).")
#endif
#	@$(PRINT) yellow $@ stop

#main:
#	@$(PRINT) yellow $@ start
#	@-(rm -rf $(BIN)/main*)
#	($(CC) -std=c89 -Wall -g -pthread -I$(LIB) $(SRC)/main.c -o $(BIN)/main)
#	(chmod +x $(BIN)/main)
#	($(BIN)/main)
#	@$(PRINT) yellow $@ stop

#app:; electron ./app/
#install:; (yarn global add electron)
#js:; (yarn run gulp && yarn run test)
