include .deosrc

all: build; @($(DEOS) && echo)

build: chmod check

check: deos.check; @(echo)

chmod:; @(chmod +x $(PRINT) $(DEOS))

clean:; -@(rm -rf node_modules/)

down:; @(vagrant destroy DeVM)

vm:; @(vagrant up)

yarn:; @(yarn all)
