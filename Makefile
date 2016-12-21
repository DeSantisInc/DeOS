export MAKEFLAGS=--no-print-directory

include .deosrc

all: clean install build venv lint
	@(python src/deos.py)

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
