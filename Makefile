include .deosrc

all: init
	@-echo "$@";

init: clean
	@-mkdir .DocumentRevisions-V100;
	@-mkdir .fseventsd;
	@-touch .fseventsd/no_log;
	@-mkdir .TemporaryItems;
	@-mkdir .Trashes;
	@-touch .metadata_never_index;

clean:
	@-rm -rf .DocumentRevisions-V100/;
	@-rm -rf .fseventsd/;
	@-rm -rf .TemporaryItems/;
	@-rm -rf .Trashes/;
	@-rm .metadata_never_index;
