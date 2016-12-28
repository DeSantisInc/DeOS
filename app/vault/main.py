#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function

import configobj
import jsonschema
import web

import simplejson as json
import ruamel.yaml as yaml

TEMPLATES=['add_password_dialog']

def main():
    for template in TEMPLATES:
        with open('templates/'+template+'.xml') as f:
            raw=f.read()
            code=web.template.Template(raw)
            with open('config/'+template+'.yml') as y:
                rawdata=y.read()
                if isinstance(rawdata, basestring):
                    data=yaml.safe_load(rawdata)
                    with open('build/'+template+'.ui','w') as p:
                        out=str(code(data))
                        p.write(out)

if __name__=="__main__":
    main()
