export MAKEFLAGS=--no-print-directory

include .deosrc

ifeq ($(DeOS_HOST_OS),Darwin)
	include etc/deos/darwin.mk
endif

ifeq ($(DeOS_HOST_OS),Linux)
	include etc/deos/travis.mk
endif
