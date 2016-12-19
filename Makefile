export MAKEFLAGS=--no-print-directory

all: lint

lint:
	$(MAKE) lint.travis

lint.travis:
	travis lint .travis.yml
