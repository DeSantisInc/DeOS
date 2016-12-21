# `Makefile`

## Schema

```yaml
type: object
required: [makeflags, default_goal, phony, sublime_targets, config_file, all]
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
```

## Environment

```yaml
makeflags: --no-print-directory
default_goal: all
phony: all
sublime_targets: all
config_file: .deosrc

all:
  hook:
    pre: >
      @echo && $(PRINT) cyan $@ start
    post: >
      @$(PRINT) cyan $@ stop && echo
  if:host;is:mac: >
    @$(MAKE) templates
  else: >
    @(echo "'make $@' isn't yet supported on $(DeOS_HOST_OS).")
```

## Template

```makefile
Δ with (data=None)

export MAKEFLAGS=Δ(data['makeflags'])
.DEFAULT_GOAL:=Δ(data['default_goal'])
.PHONY:Δ(data['phony'])
.SUBLIME_TARGETS:Δ(data['sublime_targets'])
include Δ(data['config_file'])

all:
    Δ(data['all']['hook']['pre'])
ifeq ($(DeOS_HOST_OS),$(IS_MAC))
    Δ(data['all']['if:host;is:mac'])
else
    Δ(data['all']['else'])
endif
    Δ(data['all']['hook']['post'])

clean:
    @([ -d ".deos" ] && $(DeOS_RM_DOTDEOS) || echo "$@:else")

install:
    @([ ! -x "$(DeOS_BIN_TRAVIS)" ] && $(DeOS_ADD_TRAVIS) || echo "$@:else")

build:
    @([ ! -d ".deos" ] && $(DeOS_ADD_DOTDEOS) || echo "$@:else")

venv:
    @([ -d ".deos/venv" ] && rm -rf .deos/venv || echo "$@:else")
    @([ ! -d ".deos/venv" ] && mkdir .deos/venv .deos/venv/darwin .deos/venv/vagrant .deos/venv/travis || echo "$@:else")

lint:
    @(travis lint .travis.yml)
```
