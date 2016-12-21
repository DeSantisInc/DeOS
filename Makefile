HOSTOS=$(shell uname -s)

ifeq ($(HOSTOS),Darwin)
	include make-darwin.mk
endif

ifeq ($(OSTYPE),Linux)
	include make-travis.mk
endif
