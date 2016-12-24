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
	mv src/blockstack/blockstack-cli/README.md docs/blockstack/blockstack_client/README.md
	mv src/blockstack/blockstack-cli/LICENSE docs/blockstack/blockstack_client/LICENSE
	-cd docs/blockstack && rm -rf blockstack_registrar
	mv src/blockstack/blockstack-cli/blockstack_registrar/doc docs/blockstack/blockstack_registrar
	mv src/blockstack/blockstack-cli/blockstack_registrar/README.md docs/blockstack/blockstack_registrar/README.md
	mv src/blockstack/blockstack-cli/blockstack_registrar/LICENSE docs/blockstack/blockstack_registrar/LICENSE
	-cd tools/blockstack && rm -rf blockstack_client
	mv src/blockstack/blockstack-cli/tools tools/blockstack/blockstack_client
	-cd tools/blockstack && rm -rf blockstack_registrar
	mv src/blockstack/blockstack-cli/blockstack_registrar/tools tools/blockstack/blockstack_registrar
	-cd tests/blockstack && rm -rf blockstack_client
	cd tests/blockstack && mkdir blockstack_client
	mv src/blockstack/blockstack-cli/unit_tests.py tests/blockstack/blockstack_client/unit_tests.py
	-cd tests/blockstack && rm -rf blockstack_registrar
	mv src/blockstack/blockstack-cli/blockstack_registrar/tests tests/blockstack/blockstack_registrar

	-rm -rf src/blockstack/virtualchain
	cd src/blockstack && git clone git@github.com:blockstack/virtualchain.git
	rm -rf src/blockstack/virtualchain/.git
	-rm -rf docs/blockstack/virtualchain
	mkdir docs/blockstack/virtualchain
	mv src/blockstack/virtualchain/LICENSE docs/blockstack/virtualchain/LICENSE
	mv src/blockstack/virtualchain/README.md docs/blockstack/virtualchain/README.md
	mv src/blockstack/virtualchain/virtualchain/impl_ref docs/blockstack/virtualchain/impl_ref

	-cd src/blockstack && rm -rf pybitcoin
	cd src/blockstack && git clone git@github.com:blockstack/pybitcoin.git
	cd src/blockstack/pybitcoin && rm -rf .git
	-cd tests/blockstack && rm -rf pybitcoin
	mv src/blockstack/pybitcoin/tests tests/blockstack/pybitcoin
	mv src/blockstack/pybitcoin/unit_tests.py tests/blockstack/pybitcoin/unit_tests.py
	-cd docs/blockstack && rm -rf pybitcoin
	mkdir docs/blockstack/pybitcoin
	mv src/blockstack/pybitcoin/AUTHORS docs/blockstack/pybitcoin/AUTHORS
	mv src/blockstack/pybitcoin/DEPRECATED.md docs/blockstack/pybitcoin/DEPRECATED.md
	mv src/blockstack/pybitcoin/LICENSE docs/blockstack/pybitcoin/LICENSE
	mv src/blockstack/pybitcoin/README.md docs/blockstack/pybitcoin/README.md
	mv src/blockstack/pybitcoin/MANIFEST.in docs/blockstack/pybitcoin/MANIFEST.in
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
	-rm tests/pypreprocessor test.py
	mv src/pypreprocessor/test.py tests/pypreprocessor/test.py
	-rm -rf docs/pypreprocessor
	mkdir docs/pypreprocessor
	mv src/pypreprocessor/Examples docs/pypreprocessor/examples
	mv src/pypreprocessor/LICENSE docs/pypreprocessor/LICENSE
	mv src/pypreprocessor/INSTALL.md docs/pypreprocessor/INSTALL.md
	mv src/pypreprocessor/README.md docs/pypreprocessor/README.md
	mv src/pypreprocessor/MANIFEST docs/pypreprocessor/MANIFEST
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
	@-(rm -rf tools/web)
	@ (mv src/web/tools tools/web)
	@ (mv src/web/test tests/web)
	@ (mv src/web/docs docs/web)
	@ (mv src/web/LICENSE.txt docs/web/LICENSE.txt)
	@ (mv src/web/ChangeLog.txt docs/web/ChangeLog.txt)
	@ (mv src/web/README.md docs/web/README.md)
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
