include .deosrc

all: vm #build; @($(DEOS) && echo)

app:; electron ./app/

build: chmod check

check: deos.check; @(echo)

chmod:; (chmod +x $(PRINT) $(DEOS))

clean:; -(rm -rf node_modules/)

down:; (vagrant destroy DeVM)

install:; (yarn global add electron)

rm: vm.uninstall

ssh: vm.ssh

vm: vm.install

yarn:; (yarn all)
