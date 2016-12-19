export MAKEFLAGS=--no-print-directory

all: #lint

lint:
	travis lint .travis.yml
