export MAKEFLAGS=--no-print-directory
include .deosrc


.DEFAULT_GOAL:=all
.PHONY:all meta
.SUBLIME_TARGETS:all


DeOS_ADD_DOTDEOS:=mkdir .deos .deos/bin .deos/bin/darwin .deos/bin/vagrant .deos/bin/travis .deos/obj .deos/obj/darwin .deos/obj/vagrant .deos/obj/travis .deos/venv .deos/venv/darwin .deos/venv/vagrant .deos/venv/travis
DeOS_ADD_TRAVIS:=gem install travis --no-rdoc --no-ri
DeOS_BIN_TRAVIS:=$(shell which travis)
DeOS_RM_DOTDEOS:=rm -rf .deos


all: #clean install build venv lint
	@echo && $(PRINTM) cyan $@ start
ifeq ($(HOSTOS),$(IS_MAC))
	@(python src/hello.py)
else
	@(echo "'make $@' isn't yet supported on $(HOSTOS).")
endif
	@$(PRINTM) cyan $@ stop && echo


wiki:
	@$(PRINTM) yellow $@ start
	-rm -rf var/wiki/
	cd var/ && git clone git@github.com:DeSantisInc/DeOS.wiki.git wiki
	rm -rf var/wiki/.git/
	@$(PRINTM) yellow $@ stop


cache:
ifeq ($(SETCACHE),$(IS_TRUE))
	@$(PRINTM) cyan $@ start
	-rm -rf .cache/webpy/
	cd .cache && git clone git@github.com:webpy/webpy.git
	cd .cache && tar -cvzf webpy.tar.gz webpy/*
	rm -rf .cache/webpy/
	-rm -rf .cache/hyper/
	cd .cache && git clone git@github.com:zeit/hyper.git
	cd .cache && tar -cvzf hyper.tar.gz hyper/*
	rm -rf .cache/hyper/
	@$(PRINTM) cyan $@ stop
endif


bips:
ifeq ($(HOSTOS),$(IS_MAC))
	@$(PRINTM) yellow $@ start
	-rm -rf doc/bips
	cd doc/ && git clone git@github.com:bitcoin/bips.git
	rm -rf doc/bips/.git/
	@$(PRINTM) yellow $@ stop
else
	@(echo "'make $@' isn't yet supported on $(HOSTOS).")
endif


terminal:
ifeq ($(HOSTOS),$(IS_MAC))
	@$(PRINTM) cyan $@ start
	-rm -rf app/terminal
	cd app/ && git clone git@github.com:zeit/hyper.git terminal
	rm -rf app/terminal/.git/ app/terminal/.github/
	@$(PRINTM) cyan $@ stop
else
	@(echo "'make $@' isn't yet supported on $(HOSTOS).")
endif


meta:
ifeq ($(HOSTOS),$(IS_MAC))
	@$(PRINTM) yellow $@ start
	sh bootstrap.sh
	python src/hello.py
	$(MAKE) cache
	$(MAKE) wiki
	$(MAKE) webpy
	$(MAKE) terminal
	$(MAKE) bips
	@$(PRINTM) yellow $@ stop
else
	@(echo "'make $@' isn't yet supported on $(HOSTOS).")
endif


webpy:
ifeq ($(HOSTOS),$(IS_MAC))
	@$(PRINTM) cyan $@ start
	-rm -rf src/web/
ifeq ($(USECACHE),$(IS_TRUE))
	-rm src/web.tar
	[ -f ".cache/webpy.tar.gz" ] && (cp .cache/webpy.tar.gz src/web.tar.gz && gunzip src/web.tar.gz && cd src && tar -xvf web.tar && mv webpy web) || (cd src/ && git clone git@github.com:webpy/webpy.git web)
	-rm src/web.tar
else
	cd src/ && git clone git@github.com:webpy/webpy.git web
endif
	rm -rf src/web/.git/
	-rm src/web/.gitignore
	-rm src/web/.travis.yml
	mv src/web/test/ test/web/
	mv src/web/docs/ doc/web/
	@$(PRINTM) cyan $@ stop
else
	@(echo "'make $@' isn't yet supported on $(HOSTOS).")
endif


clean:
	@$(PRINTM) cyan $@ start
	@([ -d ".deos" ] && $(DeOS_RM_DOTDEOS) || echo "$@:else")
	@$(PRINTM) cyan $@ stop


install:
	@$(PRINTM) yellow $@ start
	@([ ! -x "$(DeOS_BIN_TRAVIS)" ] && $(DeOS_ADD_TRAVIS) || echo "$@:else")
	@$(PRINTM) yellow $@ stop


build:
	@$(PRINTM) yellow $@ start
	@([ ! -d ".deos" ] && $(DeOS_ADD_DOTDEOS) || echo "$@:else")
	@$(PRINTM) yellow $@ stop


venv:
ifeq ($(HOSTOS),$(IS_MAC))
	@$(PRINTM) yellow $@ start
	@([ -d ".deos/venv" ] && rm -rf .deos/venv || echo "$@:else")
	@([ ! -d ".deos/venv" ] && mkdir .deos/venv .deos/venv/darwin .deos/venv/vagrant .deos/venv/travis || echo "$@:else")
	@$(PRINTM) yellow $@ stop
else
	@(echo "'make $@' isn't yet supported on $(HOSTOS).")
endif


lint:
	@$(PRINTM) cyan $@ start
ifeq ($(HOSTOS),$(IS_MAC))
	@(travis lint .travis.yml)
else
	@(echo "'make $@' isn't yet supported on $(HOSTOS).")
endif
	@$(PRINTM) cyan $@ stop
