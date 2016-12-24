# `Makefile`

## Schema

```yaml
type: object

required:
- makeflags
- default_goal
- phony
- sublime_targets
- config_file
- all
- bips
- build
- cache
- clean
- install
- lint
- meta
- terminal
- venv
- webpy
- wiki
- wikiup

properties:
  makeflags: {type: string}
  default_goal: {type: string}
  phony: {type: string}
  sublime_targets: {type: string}
  config_file: {type: string}

  all:
    type: object
    required: [hook, 'if:host;is:mac', 'else:host']
    properties:
      if:host;is:mac: {type: string}
      else:host: {type: string}
      hook:
        type: object
        required: [logger, printm]
        properties:
          logger:
            type: object
            required: [pre, post]
            properties:
              pre: {type: string}
              post: {type: string}
          printm:
            type: object
            required: [pre, post]
            properties:
              pre: {type: string}
              post: {type: string}

  bips:
    type: object
    required: [hook, 'else:host']
    properties:
      else:host: {type: string}
      hook:
        type: object
        required: [logger, printm]
        properties:
          logger:
            type: object
            required: [pre, post]
            properties:
              pre: {type: string}
              post: {type: string}
          printm:
            type: object
            required: [pre, post]
            properties:
              pre: {type: string}
              post: {type: string}

  build:
    type: object
    required: [hook, 'else:host']
    hook:
      type: object
      required: [pre, post]

  cache:
    type: object
    required: [hook, 'else:host']
    hook:
      type: object
      required: [pre, post]

  clean:
    type: object
    required: [hook, 'else:host']
    hook:
      type: object
      required: [pre, post]

  install:
    type: object
    required: [hook, 'else:host']
    hook:
      type: object
      required: [pre, post]

  lint:
    type: object
    required: [hook, 'if:host;is:mac', 'else:host']
    hook:
      type: object
      required: [pre, post]

  meta:
    type: object
    required: [hook, 'else:host']
    hook:
      type: object
      required: [pre, post]

  terminal:
    type: object
    required: [hook, 'else:host']
    hook:
      type: object
      required: [pre, post]

  venv:
    type: object
    required: [hook, 'else:host']
    hook:
      type: object
      required: [pre, post]

  webpy:
    type: object
    required: [hook, 'if:repo;is:cached', 'else:repo', 'else:host']
    hook:
      type: object
      required: [pre, post]

  wiki:
    type: object
    required: [hook, 'else:host']
    hook:
      type: object
      required: [pre, post]

  wikiup:
    type: object
    required: [hook, 'else:host']
    hook:
      type: object
      required: [pre, post]
```

## Environment

```yaml
makeflags: --no-print-directory
default_goal: all
phony: all meta
sublime_targets: all
config_file: .deosrc

all:
  hook:
    logger:
      pre: '$(LOGGER) "INFO" "$(HOSTOS) : make : $@ : 0"'
      post: '$(LOGGER) "INFO" "$(HOSTOS) : make : $@ : 1"'
    printm:
      pre: $(PRINTM) cyan $@ start
      post: $(PRINTM) cyan $@ stop
  if:host;is:mac: python src/hello.py
  else:host: echo "'make $@' isn't yet supported on $(HOSTOS)."

bips:
  hook:
    logger:
      pre: '$(LOGGER) "INFO" "$(HOSTOS) : make : $@ : 0"'
      post: '$(LOGGER) "INFO" "$(HOSTOS) : make : $@ : 1"'
    printm:
      pre: $(PRINTM) magenta $@ start
      post: $(PRINTM) magenta $@ stop
  else:host: echo "'make $@' isn't yet supported on $(HOSTOS)."

build:
  hook:
    pre: $(PRINTM) yellow $@ start
    post: $(PRINTM) yellow $@ stop
  else:host: (echo "'make $@' isn't yet supported on $(HOSTOS).")

cache:
  hook:
    pre: $(PRINTM) magenta $@ start
    post: $(PRINTM) magenta $@ stop
  else:host: (echo "'make $@' isn't yet supported on $(HOSTOS).")

clean:
  hook:
    pre: $(PRINTM) cyan $@ start
    post: $(PRINTM) cyan $@ stop
  else:host: (echo "'make $@' isn't yet supported on $(HOSTOS).")

install:
  hook:
    pre: $(PRINTM) yellow $@ start
    post: $(PRINTM) yellow $@ stop
  else:host: (echo "'make $@' isn't yet supported on $(HOSTOS).")

lint:
  hook:
    pre: $(PRINTM) magenta $@ start
    post: $(PRINTM) magenta $@ stop
  if:host;is:mac: (travis lint .travis.yml)
  else:host: (echo "'make $@' isn't yet supported on $(HOSTOS).")

meta:
  hook:
    pre: $(PRINTM) yellow $@ start
    post: $(PRINTM) yellow $@ stop
  else:host: (echo "'make $@' isn't yet supported on $(HOSTOS).")

terminal:
  hook:
    pre: $(PRINTM) cyan $@ start
    post: $(PRINTM) cyan $@ stop
  else:host: (echo "'make $@' isn't yet supported on $(HOSTOS).")

venv:
  hook:
    pre: $(PRINTM) yellow $@ start
    post: $(PRINTM) yellow $@ stop
  else:host: (echo "'make $@' isn't yet supported on $(HOSTOS).")

webpy:
  hook:
    pre: $(PRINTM) magenta $@ start
    post: $(PRINTM) magenta $@ stop
  if:repo;is:cached: (cp .cache/webpy.tar.gz src/web.tar.gz && gunzip src/web.tar.gz && cd src && tar -xvf web.tar && mv webpy web)
  else:repo: (cd src/ && git clone $(DeOS_GIT_REPO_WEB) web)
  else:host: (echo "'make $@' isn't yet supported on $(HOSTOS).")

wiki:
  hook:
    pre: $(PRINTM) cyan $@ start
    post: $(PRINTM) cyan $@ stop
  else:host: (echo "'make $@' isn't yet supported on $(HOSTOS).")

wikiup:
  hook:
    pre: $(PRINTM) cyan $@ start
    post: $(PRINTM) cyan $@ stop
  else:host: (echo "'make $@' isn't yet supported on $(HOSTOS).")

```

## Template

```makefile
Δ with (data=None)

export MAKEFLAGS=Δ(data['makeflags'])
include .deosrc


.DEFAULT_GOAL:=Δ(data['default_goal'])
.PHONY:Δ(data['phony'])
.SUBLIME_TARGETS:Δ(data['sublime_targets'])


all:
ifeq ($(HOSTOS),$(IS_MAC))
    @ (Δ(data['all']['hook']['logger']['pre']))
    @ (Δ(data['all']['hook']['printm']['pre']))
    @
    @ (Δ(data['all']['if:host;is:mac']))
    @
    @ (Δ(data['all']['hook']['printm']['post']))
    @ (Δ(data['all']['hook']['logger']['post']))
else
    @ (Δ(data['all']['else:host']))
endif


vm:
ifeq ($(HOSTOS),$(IS_MAC))
    @ $(LOGGER) "INFO" "$(HOSTOS) : make : $@ : 0"
    @ $(PRINTM) cyan $@ start
    @
    @-([   -d "$(BASEDIR)/.vagrant/" ] && vagrant destroy DeVM --force)
    @-([   -d "$(BASEDIR)/.vagrant/" ] && rm -rf $(BASEDIR)/.vagrant/)
    @ ([ ! -d "$(BASEDIR)/.vagrant/" ] && $(SPINNER) $(UPCMD))
    @
    @ $(PRINTM) cyan $@ stop
    @ $(LOGGER) "INFO" "$(HOSTOS) : make : $@ : 1"
else
    @ (echo "'make $@' isn't yet supported on $(HOSTOS).")
endif


wiki:
ifeq ($(HOSTOS),$(IS_MAC))
    @ $(LOGGER) "INFO" "$(HOSTOS) : make : $@ : 0"
    @ Δ(data['wiki']['hook']['pre'])
    @
    @-(rm -rf var/wiki/)
    @ (cd var/ && git clone $(DeOS_GIT_REPO_WIKI) wiki)
    @ (rm -rf var/wiki/.git/)
    @
    @ Δ(data['wiki']['hook']['post'])
    @ $(LOGGER) "INFO" "$(HOSTOS) : make : $@ : 1"
else
    @ Δ(data['wiki']['else:host'])
endif


wikiup:
ifeq ($(HOSTOS),$(IS_MAC))
    @ $(LOGGER) "INFO" "$(HOSTOS) : make : $@ : 0"
    @ Δ(data['wikiup']['hook']['pre'])
    @
    @-(rm -rf var/wiki/)
    @ (cd var/ && git clone $(DeOS_GIT_REPO_WIKI) wiki)
    @ (cp meta/* var/wiki/)
    @-(cd var/wiki/ && git add .)
    @-(cd var/wiki/ && git commit -S -m "wiki: update")
    @-(cd var/wiki/ && git push)
    @-(rm -rf var/wiki/)
    @ (cd var/ && git clone $(DeOS_GIT_REPO_WIKI) wiki)
    @ (rm -rf var/wiki/.git/)
    @
    @ Δ(data['wikiup']['hook']['post'])
    @ $(LOGGER) "INFO" "$(HOSTOS) : make : $@ : 1"
else
    @ Δ(data['wikiup']['else:host'])
endif


cache:
ifeq ($(HOSTOS),$(IS_MAC))
ifeq ($(SETCACHE),$(IS_TRUE))
    @ $(LOGGER) "INFO" "$(HOSTOS) : make : $@ : 0"
    @ Δ(data['cache']['hook']['pre'])
    @
    @-(rm -rf .cache/webpy/)
    @ (cd .cache && git clone $(DeOS_GIT_REPO_WEB))
    @ (cd .cache && tar -cvzf webpy.tar.gz webpy/*)
    @ (rm -rf .cache/webpy/)
    @
    @-(rm -rf .cache/hyper/)
    @ (cd .cache && git clone $(DeOS_GIT_REPO_HYPER))
    @ (cd .cache && tar -cvzf hyper.tar.gz hyper/*)
    @ (rm -rf .cache/hyper/)
    @
    @ Δ(data['cache']['hook']['post'])
    @ $(LOGGER) "INFO" "$(HOSTOS) : make : $@ : 1"
endif
else
    @ Δ(data['cache']['else:host'])
endif


bips:
ifeq ($(HOSTOS),$(IS_MAC))
    @ (Δ(data['bips']['hook']['logger']['pre']))
    @ (Δ(data['bips']['hook']['printm']['pre']))
    @
    @-(rm -rf doc/bips)
    @ (cd doc/ && git clone $(DeOS_GIT_REPO_BIPS))
    @ (rm -rf doc/bips/.git/)
    @
    @ (Δ(data['bips']['hook']['printm']['post']))
    @ (Δ(data['bips']['hook']['logger']['post']))
else
    @ (Δ(data['bips']['else:host']))
endif


terminal:
ifeq ($(HOSTOS),$(IS_MAC))
    @ Δ(data['terminal']['hook']['pre'])
    @
    @-(rm -rf app/terminal)
    @ (cd app/ && git clone $(DeOS_GIT_REPO_HYPER) terminal)
    @ (rm -rf app/terminal/.git/ app/terminal/.github/)
    @
    @ Δ(data['terminal']['hook']['post'])
else
    @ Δ(data['terminal']['else:host'])
endif


meta:
ifeq ($(HOSTOS),$(IS_MAC))
    @ $(LOGGER) "INFO" "$(HOSTOS) : make : $@ : 0"
    @ Δ(data['meta']['hook']['pre'])
    @
    @ (sh bootstrap.sh)
    @ (python src/hello.py)
    @ ($(MAKE) cache)
    @ ($(MAKE) wiki)
    @ ($(MAKE) webpy)
    @ ($(MAKE) terminal)
    @ ($(MAKE) bips)
    @-($(MAKE) wikiup)
    @
    @ Δ(data['meta']['hook']['post'])
    @ $(LOGGER) "INFO" "$(HOSTOS) : make : $@ : 1"
else
    @ Δ(data['meta']['else:host'])
endif


webpy:
ifeq ($(HOSTOS),$(IS_MAC))
    @ $(LOGGER) "INFO" "$(HOSTOS) : make : $@ : 0"
    @ Δ(data['webpy']['hook']['pre'])
    @
    @-(rm -rf src/web/)
ifeq ($(USECACHE),$(IS_TRUE))
    @-(rm src/web.tar)
    @ ([ -f ".cache/webpy.tar.gz" ] && Δ(data['webpy']['if:repo;is:cached']) || Δ(data['webpy']['else:repo']))
    @-(rm src/web.tar)
else
    @ (cd src/ && git clone $(DeOS_GIT_REPO_WEB) web)
endif
    @ (rm -rf src/web/.git/)
    @-(rm src/web/.gitignore)
    @-(rm src/web/.travis.yml)
    @ (mv src/web/test/ test/web/)
    @ (mv src/web/docs/ doc/web/)
    @
    @ Δ(data['webpy']['hook']['post'])
    @ $(LOGGER) "INFO" "$(HOSTOS) : make : $@ : 1"
else
    @ Δ(data['webpy']['else:host'])
endif


clean:
ifeq ($(HOSTOS),$(IS_MAC))
    @ Δ(data['clean']['hook']['pre'])
    @
    @ ([ -d ".deos" ] && $(DeOS_RM_DOTDEOS) || echo "$@:else")
    @
    @ Δ(data['clean']['hook']['post'])
else
    @ Δ(data['clean']['else:host'])
endif


install:
ifeq ($(HOSTOS),$(IS_MAC))
    @ Δ(data['install']['hook']['pre'])
    @
    @ ([ ! -x "$(DeOS_BIN_TRAVIS)" ] && $(DeOS_ADD_TRAVIS) || echo "$@:else")
    @
    @ Δ(data['install']['hook']['post'])
else
    @ Δ(data['install']['else:host'])
endif


build:
ifeq ($(HOSTOS),$(IS_MAC))
    @ Δ(data['build']['hook']['pre'])
    @
    @ ([ ! -d ".deos" ] && $(DeOS_ADD_DOTDEOS) || echo "$@:else")
    @
    @ Δ(data['build']['hook']['post'])
else
    @ Δ(data['build']['else:host'])
endif


venv:
ifeq ($(HOSTOS),$(IS_MAC))
    @ Δ(data['venv']['hook']['pre'])
    @
    @ ([   -d ".deos/venv" ] && rm -rf .deos/venv || echo "$@:else")
    @ ([ ! -d ".deos/venv" ] && mkdir .deos/venv .deos/venv/darwin .deos/venv/vagrant .deos/venv/travis || echo "$@:else")
    @
    @ Δ(data['venv']['hook']['post'])
else
    @ Δ(data['venv']['else:host'])
endif


lint:
ifeq ($(HOSTOS),$(IS_MAC))
    @ Δ(data['lint']['hook']['pre'])
    @
    @ Δ(data['lint']['if:host;is:mac'])
    @
    @ Δ(data['lint']['hook']['post'])
else
    @ Δ(data['lint']['else:host'])
endif
```

## Test

```yaml
a: 1
b: 2
c: 3
```
