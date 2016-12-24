export MAKEFLAGS=--no-print-directory
include .deosrc


.DEFAULT_GOAL:=all
.PHONY:all meta
.SUBLIME_TARGETS:all


all:
ifeq ($(HOSTOS),$(ISMAC))
	@ ($(LOGGER) "INFO" "$(HOSTOS) : make : $@ : 0")
	@ ($(PRINTM) cyan $@ start)
	@ (python src/hello.py)
	@ ($(PRINTM) cyan $@ stop)
	@ ($(LOGGER) "INFO" "$(HOSTOS) : make : $@ : 1")
else
	@ (echo "'make $@' isn't yet supported on $(HOSTOS).")
endif


vm:
ifeq ($(HOSTOS),$(ISMAC))
	@ ($(LOGGER) "INFO" "$(HOSTOS) : make : $@ : 0")
	@ ($(PRINTM) cyan $@ start)
	@-([   -d "$(BASEDIR)/.vagrant/" ] && vagrant destroy DeVM --force)
	@-([   -d "$(BASEDIR)/.vagrant/" ] && rm -rf $(BASEDIR)/.vagrant/)
	@ ([ ! -d "$(BASEDIR)/.vagrant/" ] && $(SPINNER) $(UPCMD))
	@ ($(PRINTM) cyan $@ stop)
	@ ($(LOGGER) "INFO" "$(HOSTOS) : make : $@ : 1")
else
	@ (echo "'make $@' isn't yet supported on $(HOSTOS).")
endif


wiki:
ifeq ($(HOSTOS),$(ISMAC))
	@ ($(LOGGER) "INFO" "$(HOSTOS) : make : $@ : 0")
	@ ($(PRINTM) cyan $@ start)
	@-(rm -rf var/wiki)
	@ (cd var && git clone $(DeOS_GIT_REPO_WIKI) wiki)
	@ (rm -rf var/wiki/.git)
	@ ($(PRINTM) cyan $@ stop)
	@ ($(LOGGER) "INFO" "$(HOSTOS) : make : $@ : 1")
else
	@ (echo "'make $@' isn't yet supported on $(HOSTOS).")
endif


wikiup:
ifeq ($(HOSTOS),$(ISMAC))
	@ ($(LOGGER) "INFO" "$(HOSTOS) : make : $@ : 0")
	@ ($(PRINTM) cyan $@ start)
	@-(rm -rf var/wiki)
	@ (cd var && git clone $(DeOS_GIT_REPO_WIKI) wiki)
	@ (cp meta/* var/wiki)
	@-(cd var/wiki && git add . && git commit -S -m "wiki: update" && git push)
	@-(rm -rf var/wiki)
	@ (cd var && git clone $(DeOS_GIT_REPO_WIKI) wiki)
	@ (rm -rf var/wiki/.git)
	@ ($(PRINTM) cyan $@ stop)
	@ ($(LOGGER) "INFO" "$(HOSTOS) : make : $@ : 1")
else
	@ (echo "'make $@' isn't yet supported on $(HOSTOS).")
endif


cache:
ifeq ($(HOSTOS),$(ISMAC))
ifeq ($(SETCACHE),$(ISTRUE))
	@ ($(LOGGER) "INFO" "$(HOSTOS) : make : $@ : 0")
	@ ($(PRINTM) magenta $@ start)
	@-(rm -rf .cache/webpy)
	@ (cd .cache && git clone $(DeOS_GIT_REPO_WEB))
	@ (cd .cache && tar -cvzf webpy.tar.gz webpy/*)
	@ (rm -rf .cache/webpy)
	@-(rm -rf .cache/hyper)
	@ (cd .cache && git clone $(DeOS_GIT_REPO_HYPER))
	@ (cd .cache && tar -cvzf hyper.tar.gz hyper/*)
	@ (rm -rf .cache/hyper)
	@ ($(PRINTM) magenta $@ stop)
	@ ($(LOGGER) "INFO" "$(HOSTOS) : make : $@ : 1")
endif
else
	@ (echo "'make $@' isn't yet supported on $(HOSTOS).")
endif


bips:
ifeq ($(HOSTOS),$(ISMAC))
	@ ($(LOGGER) "INFO" "$(HOSTOS) : make : $@ : 0")
	@ ($(PRINTM) magenta $@ start)
	@-(rm -rf docs/bips)
	@ (cd docs && git clone $(DeOS_GIT_REPO_BIPS))
	@ (rm -rf docs/bips/.git)
	@ ($(PRINTM) magenta $@ stop)
	@ ($(LOGGER) "INFO" "$(HOSTOS) : make : $@ : 1")
else
	@ (echo "'make $@' isn't yet supported on $(HOSTOS).")
endif


terminal:
ifeq ($(HOSTOS),$(ISMAC))
	@ ($(PRINTM) cyan $@ start)
	@-(rm -rf app/terminal)
	@ (cd app && git clone $(DeOS_GIT_REPO_HYPER) terminal)
	@ (rm -rf app/terminal/.git app/terminal/.github)
	@ ($(PRINTM) cyan $@ stop)
else
	@ (echo "'make $@' isn't yet supported on $(HOSTOS).")
endif


meta:
ifeq ($(HOSTOS),$(ISMAC))
	@ ($(LOGGER) "INFO" "$(HOSTOS) : make : $@ : 0")
	@ ($(PRINTM) yellow $@ start)
	@ (sh bootstrap.sh)
	@ (python src/hello.py)
	$(MAKE) blockstack.clone
	$(MAKE) blockstack.venv
	@ ($(MAKE) cache)
	@ ($(MAKE) wiki)
	@ ($(MAKE) webpy)
	@ ($(MAKE) terminal)
	@ ($(MAKE) bips)
	@ ($(MAKE) pycpp)
	@-($(MAKE) wikiup)
	@ ($(PRINTM) yellow $@ stop)
	@ ($(LOGGER) "INFO" "$(HOSTOS) : make : $@ : 1")
else
	@ (echo "'make $@' isn't yet supported on $(HOSTOS).")
endif


blockstack:
	source $(BASEDIR)/.deos/venv/darwin/blockstack/bin/activate && python $(BASEDIR)/src/blockstack.py

blockstack.clone:
ifeq ($(HOSTOS),$(ISMAC))
	-cd src/blockstack && rm -rf blockstack-cli
	cd src/blockstack && git clone git@github.com:blockstack/blockstack-cli.git
	cd src/blockstack/blockstack-cli && rm -rf .git
	-cd docs/blockstack && rm -rf blockstack_client
	mv src/blockstack/blockstack-cli/docs docs/blockstack/blockstack_client
	-cd tools/blockstack && rm -rf blockstack_client
	mv src/blockstack/blockstack-cli/tools tools/blockstack/blockstack_client
	-cd tests/blockstack && rm -rf blockstack_client
	cd tests/blockstack && mkdir blockstack_client
	mv src/blockstack/blockstack-cli/unit_tests.py tests/blockstack/blockstack_client/unit_tests.py
endif


blockstack.venv:
ifeq ($(HOSTOS),$(ISMAC))
	-([ -d "$(BASEDIR)/.deos/venv/darwin/blockstack" ] && rm -rf $(BASEDIR)/.deos/venv/darwin/blockstack)
	cd $(BASEDIR)/.deos/venv/darwin && virtualenv blockstack --no-site-packages
	source $(BASEDIR)/.deos/venv/darwin/blockstack/bin/activate && pip install blockstack && pip install simplejson
endif


pycpp:
ifeq ($(HOSTOS),$(ISMAC))
	-cd src && rm -rf pypreprocessor
	cd src && git clone git@github.com:evanplaice/pypreprocessor.git
	cd src/pypreprocessor && rm -rf .git
endif


webpy:
ifeq ($(HOSTOS),$(ISMAC))
	@ ($(LOGGER) "INFO" "$(HOSTOS) : make : $@ : 0")
	@ ($(PRINTM) magenta $@ start)
	@-(rm -rf src/web/)
ifeq ($(USECACHE),$(ISTRUE))
	@-(rm src/web.tar)
	@ ([ -f ".cache/webpy.tar.gz" ] && (cp .cache/webpy.tar.gz src/web.tar.gz && gunzip src/web.tar.gz && cd src && tar -xvf web.tar && mv webpy web) || cd src && git clone $(DeOS_GIT_REPO_WEB) web)
	@-(rm src/web.tar)
else
	@ (cd src/ && git clone $(DeOS_GIT_REPO_WEB) web)
endif
	@ (rm -rf src/web/.git)
	@-(rm src/web/.gitignore)
	@-(rm src/web/.travis.yml)
	@ (mv src/web/test tests/web)
	@ (mv src/web/docs docs/web)
	@ ($(PRINTM) magenta $@ stop)
	@ ($(LOGGER) "INFO" "$(HOSTOS) : make : $@ : 1")
else
	@ echo "'make $@' isn't yet supported on $(HOSTOS)."
endif


clean:
ifeq ($(HOSTOS),$(ISMAC))
	@ ($(PRINTM) cyan $@ start)
	@ ([ -d ".deos" ] && $(DeOS_RM_DOTDEOS) || echo "$@:else")
	@ ($(PRINTM) cyan $@ stop)
else
	@ (echo "'make $@' isn't yet supported on $(HOSTOS).")
endif


install:
ifeq ($(HOSTOS),$(ISMAC))
	@ ($(PRINTM) yellow $@ start)
	@ ([ ! -x "$(DeOS_BIN_TRAVIS)" ] && $(DeOS_ADD_TRAVIS) || echo "$@:else")
	@ ($(PRINTM) yellow $@ stop)
else
	@ (echo "'make $@' isn't yet supported on $(HOSTOS).")
endif


build:
ifeq ($(HOSTOS),$(ISMAC))
	@ ($(PRINTM) yellow $@ start)
	@ ([ ! -d ".deos" ] && $(DeOS_ADD_DOTDEOS) || echo "$@:else")
	@ ($(PRINTM) yellow $@ stop)
else
	@ (echo "'make $@' isn't yet supported on $(HOSTOS).")
endif


venv:
ifeq ($(HOSTOS),$(ISMAC))
	@ ($(PRINTM) yellow $@ start)
	@ ([   -d ".deos/venv" ] && rm -rf .deos/venv || echo "$@:else")
	@ ([ ! -d ".deos/venv" ] && mkdir .deos/venv .deos/venv/darwin .deos/venv/vagrant .deos/venv/travis || echo "$@:else")
	@ ($(PRINTM) yellow $@ stop)
else
	@ echo "'make $@' isn't yet supported on $(HOSTOS)."
endif


lint:
ifeq ($(HOSTOS),$(ISMAC))
	@ ($(PRINTM) magenta $@ start)
	@ (travis lint .travis.yml)
	@ ($(PRINTM) magenta $@ stop)
else
	@ (echo "'make $@' isn't yet supported on $(HOSTOS).")
endif
