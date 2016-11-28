include .deosrc

all: build; @($(DEOS) && echo)

build: chmod check

check: deos.check; @(echo)

chmod:; @(chmod +x $(PRINT) $(DEOS))
