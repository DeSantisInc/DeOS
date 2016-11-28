deos.vm: vm.install

vm.install:
	@[ -d $(BASEDIR)/.vagrant/ ]\
	&& echo "vagrant is setup"\
	|| echo "vagrant isn't setup";
