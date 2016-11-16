export MAKEFLAGS=--no-print-directory

.DEFAULT_GOAL:=all

.PHONY: all build

.SUBLIME_TARGETS: all

include .deosrc

all: build
	@$(PRINT) purple $@ start
	@echo "hello, world!"
	@$(PRINT) purple $@ stop

build:
	@chmod +x $(PRINT)
	@$(PRINT) yellow $@ start
	clang --version
	@$(PRINT) yellow $@ stop
