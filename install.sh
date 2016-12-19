#!/usr/bin/env bash

# travis command line client
if ! [ -x $(which travis) ]; then
	gem install travis --no-rdoc --no-ri
fi
