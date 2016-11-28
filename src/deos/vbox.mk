deos.vm: vm.install

vm.install:; ([ ! -d $(BASEDIR)/.vagrant/ ] && vagrant up)
