include .deosrc

all: vm ssh #build; @($(DEOS) && echo)

app:; electron ./app/

build: chmod check

check: deos.check; @(echo)

chmod:; (chmod +x $(PRINT) $(DEOS))

ext: ext.bitcoin ext.two1

install:; (yarn global add electron)

gulp:; (yarn run gulp && yarn run test)

rm: vm.uninstall

ssh: vm.ssh

vm: vm.install
