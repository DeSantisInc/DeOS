export MAKEFLAGS=--no-print-directory

.DEFAULT_GOAL:=all

.PHONY: all

.SUBLIME_TARGETS: all

include .deosrc

all:
	@chmod +x $(PRINT)
	@$(PRINT) purple $@ start
	@echo "hello, world!"
	@$(PRINT) purple $@ end
