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
- cache
- install
- lint
- meta
- terminal
- venv
- webpy
- wiki

properties:
  makeflags: {type: string}
  default_goal: {type: string}
  phony: {type: string}
  sublime_targets: {type: string}
  config_file: {type: string}

  all:
    type: object
    required: [hook, 'if:host;is:mac', else]
    hook:
      type: object
      required: [pre, post]

  bips:
    type: object
    required: [hook]
    hook:
      type: object
      required: [pre, post]

  cache:
    type: object
    required: [hook]
    hook:
      type: object
      required: [pre, post]

  install:
    type: object
    required: [hook]
    hook:
      type: object
      required: [pre, post]

  lint:
    type: object
    required: [hook]
    hook:
      type: object
      required: [pre, post]

  meta:
    type: object
    required: [hook]
    hook:
      type: object
      required: [pre, post]

  terminal:
    type: object
    required: [hook]
    hook:
      type: object
      required: [pre, post]

  venv:
    type: object
    required: [hook]
    hook:
      type: object
      required: [pre, post]

  webpy:
    type: object
    required: [hook]
    hook:
      type: object
      required: [pre, post]

  wiki:
    type: object
    required: [hook]
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
    pre: >
      @echo && $(PRINTM) cyan $@ start
    post: >
      @$(PRINTM) cyan $@ stop && echo
  if:host;is:mac: >
    @(python src/hello.py)
  else: >
    @(echo "'make $@' isn't yet supported on $(DeOS_HOST_OS).")

bips:
  hook:
    pre: >
      @$(PRINTM) yellow $@ start
    post: >
      @$(PRINTM) yellow $@ stop

cache:
  hook:
    pre: >
      @$(PRINTM) cyan $@ start
    post: >
      @$(PRINTM) cyan $@ stop

install:
  hook:
    pre: >
      @$(PRINTM) yellow $@ start
    post: >
      @$(PRINTM) yellow $@ stop

lint:
  hook:
    pre: >
      @$(PRINTM) cyan $@ start
    post: >
      @$(PRINTM) cyan $@ stop

meta:
  hook:
    pre: >
      @$(PRINTM) yellow $@ start
    post: >
      @$(PRINTM) yellow $@ stop

terminal:
  hook:
    pre: >
      @$(PRINTM) cyan $@ start
    post: >
      @$(PRINTM) cyan $@ stop

venv:
  hook:
    pre: >
      @$(PRINTM) yellow $@ start
    post: >
      @$(PRINTM) yellow $@ stop

webpy:
  hook:
    pre: >
      @$(PRINTM) cyan $@ start
    post: >
      @$(PRINTM) cyan $@ stop

wiki:
  hook:
    pre: >
      @$(PRINTM) yellow $@ start
    post: >
      @$(PRINTM) yellow $@ stop

```

## Template

```makefile
Δ with (data=None)

export MAKEFLAGS=Δ(data['makeflags'])
include .deosrc

.DEFAULT_GOAL:=Δ(data['default_goal'])
.PHONY:Δ(data['phony'])
.SUBLIME_TARGETS:Δ(data['sublime_targets'])

DeOS_ADD_DOTDEOS:=mkdir .deos .deos/bin .deos/bin/darwin .deos/bin/vagrant .deos/bin/travis .deos/obj .deos/obj/darwin .deos/obj/vagrant .deos/obj/travis .deos/venv .deos/venv/darwin .deos/venv/vagrant .deos/venv/travis
DeOS_ADD_TRAVIS:=gem install travis --no-rdoc --no-ri
DeOS_BIN_TRAVIS:=$(shell which travis)
DeOS_RM_DOTDEOS:=rm -rf .deos

all: #clean install build venv lint
    Δ(data['all']['hook']['pre'])
ifeq ($(HOSTOS),$(IS_MAC))
    Δ(data['all']['if:host;is:mac'])
else
    Δ(data['all']['else'])
endif
    Δ(data['all']['hook']['post'])

wiki:
    Δ(data['wiki']['hook']['pre'])
    -rm -rf var/wiki/
    cd var/ && git clone git@github.com:DeSantisInc/DeOS.wiki.git wiki
    rm -rf var/wiki/.git/
    Δ(data['wiki']['hook']['post'])

cache:
ifeq ($(SETCACHE),$(IS_TRUE))
    Δ(data['cache']['hook']['pre'])
    -rm -rf .cache/webpy/
    cd .cache && git clone git@github.com:webpy/webpy.git
    cd .cache && tar -cvzf webpy.tar.gz webpy/*
    rm -rf .cache/webpy/

    -rm -rf .cache/hyper/
    cd .cache && git clone git@github.com:zeit/hyper.git
    cd .cache && tar -cvzf hyper.tar.gz hyper/*
    rm -rf .cache/hyper/
    Δ(data['cache']['hook']['post'])
endif

webpy:
    Δ(data['webpy']['hook']['pre'])
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
    Δ(data['webpy']['hook']['post'])

bips:
    Δ(data['bips']['hook']['pre'])
    -rm -rf doc/bips
    cd doc/ && git clone git@github.com:bitcoin/bips.git
    rm -rf doc/bips/.git/
    Δ(data['bips']['hook']['post'])

terminal:
    Δ(data['terminal']['hook']['pre'])
    -rm -rf app/terminal
    cd app/ && git clone git@github.com:zeit/hyper.git terminal
    rm -rf app/terminal/.git/
    rm -rf app/terminal/.github/
    Δ(data['terminal']['hook']['post'])

meta:
    Δ(data['meta']['hook']['pre'])
    sh bootstrap.sh
    python src/hello.py
    $(MAKE) cache
    $(MAKE) wiki
    $(MAKE) webpy
    $(MAKE) terminal
    $(MAKE) bips
    Δ(data['meta']['hook']['post'])

clean:
    @([ -d ".deos" ] && $(DeOS_RM_DOTDEOS) || echo "$@:else")

install:
    Δ(data['install']['hook']['pre'])
    @([ ! -x "$(DeOS_BIN_TRAVIS)" ] && $(DeOS_ADD_TRAVIS) || echo "$@:else")
    Δ(data['install']['hook']['post'])

build:
    @([ ! -d ".deos" ] && $(DeOS_ADD_DOTDEOS) || echo "$@:else")

venv:
    Δ(data['venv']['hook']['pre'])
    @([ -d ".deos/venv" ] && rm -rf .deos/venv || echo "$@:else")
    @([ ! -d ".deos/venv" ] && mkdir .deos/venv .deos/venv/darwin .deos/venv/vagrant .deos/venv/travis || echo "$@:else")
    Δ(data['venv']['hook']['post'])

lint:
    Δ(data['lint']['hook']['pre'])
    @(travis lint .travis.yml)
    Δ(data['lint']['hook']['post'])
```

## Test: Environment

```yaml
a: 1
b: 2
c: 3
```

## Test: Pass

```sh
#!/bin/sh
echo "1"
echo "2"
echo "3"
```

## Test: Fail

```sh
#!/bin/sh
echo "3"
echo "2"
echo "1"
```

