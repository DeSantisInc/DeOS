include .deosrc

all: chmod; @($(MAKE) check)

check: deos.check; @(echo)

chmod:; @(chmod +x $(PRINT))
