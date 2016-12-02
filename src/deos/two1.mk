ext.two1: two1.all

two1.all: two1.install
	@$(PRINT) purple $@ start
	-rm -rf $(BASEDIR)/.tmp
	@$(PRINT) purple $@ stop

two1.install: two1.clone
	@$(PRINT) purple $@ start
	mv $(BASEDIR)/.tmp/two1/two1 $(BASEDIR)/src/two1
	mv $(BASEDIR)/.tmp/two1/tests $(BASEDIR)/src/test/two1
	mv $(BASEDIR)/.tmp/two1/docs $(BASEDIR)/var/docs/two1
	mv $(BASEDIR)/.tmp/two1/README.md $(BASEDIR)/var/docs/two1/README.md
	@$(PRINT) purple $@ stop

two1.clone: two1.clean
	@$(PRINT) purple $@ start
	cd $(BASEDIR)/.tmp && git clone $(GIT_TWO1)
	@$(PRINT) purple $@ stop

two1.clean:
	@$(PRINT) purple $@ start
	-rm -rf $(BASEDIR)/.tmp
	-mkdir $(BASEDIR)/.tmp
	-rm -rf $(BASEDIR)/src/two1
	-rm -rf $(BASEDIR)/src/test/two1
	-rm -rf $(BASEDIR)/var/docs/two1
	@$(PRINT) purple $@ stop
