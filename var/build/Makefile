export MAKEFLAGS=--no-print-directory

.DEFAULT_GOAL:=all

.PHONY:all bin build check chmod clean init rm sh venv vm

.SUBLIME_TARGETS:all

include .deosrc

all: #init build
	@echo && $(PRINT) cyan $@ start
ifeq ($(DeOS_HOST_OS),$(IS_MAC))
	@$(MAKE) templates
else
	@(echo "'make $@' isn't yet supported on $(DeOS_HOST_OS).")
endif
	@$(PRINT) cyan $@ stop && echo

