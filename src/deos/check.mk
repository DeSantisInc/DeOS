CHECK_FILES:=$(addprefix check.,$(FILES))

deos.check: $(CHECK_FILES)

$(CHECK_FILES):
	@[ -f $(BASEDIR)/$(subst check.,,$@) ]\
	&& echo "$(subst check.,[PASS] CHECK -> ,$@)"\
	|| echo "$(subst check.,[FAIL] CHECK -> ,$@)";
