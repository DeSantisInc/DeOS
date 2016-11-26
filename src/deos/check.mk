__FILES:=$(addprefix check.,$(FILES))

deos.check: $(__FILES)

$(__FILES):
	@[ -f $(BASEDIR)/$(subst check.,,$@) ]\
	&& echo "$(subst check.,[PASS] CHECK -> ,$@)"\
	|| echo "$(subst check.,[FAIL] CHECK -> ,$@)";
