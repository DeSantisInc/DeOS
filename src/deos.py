#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import division
from __future__ import print_function

import os
import sys

import configobj
import simplejson as json
import ruamel.yaml as yaml

def main():
    for module in (os, sys, configobj, json, yaml):
        print(module)

if __name__ == "__main__":
    main()
