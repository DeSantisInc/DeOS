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
phony: all bin build check chmod clean init rm sh venv vm
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
```
