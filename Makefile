export MAKEFLAGS=--no-print-directory

include .deosrc

ifeq ($(DeOS_HOST_OS),Darwin)
	include src/make/darwin.mk
endif

ifeq ($(DeOS_HOST_OS),Linux)
	include src/make/travis.mk
endif
