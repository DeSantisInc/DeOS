include .deosrc

all: build; @($(DEOS) && echo)

yarn:; (yarn all)

build: chmod check

check: deos.check; @(echo)

chmod:; @(chmod +x $(PRINT) $(DEOS))

clean:; -(rm -rf node_modules/)
