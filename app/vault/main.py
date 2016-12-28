#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function
import web
import simplejson as json
import ruamel.yaml as yaml

TEMPLATES=['templates/add_password_dialog.ui']

def main():
    for template in TEMPLATES:
        with open(template) as f:
            raw=f.read()
            code=web.template.Template(raw)
            data=None
            print(code(data))

if __name__=="__main__":
    main()
