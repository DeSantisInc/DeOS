#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function
from __future__ import division

import configobj
import jsonschema
import web

import simplejson as json
import ruamel.yaml as yaml

MACRO_BUILD="build/%s.ui"
MACRO_CONFIG="config/%s.yml"
MACRO_TEMPLATES="templates/%s.xml"
PATH_TEMPLATES="./templates/"
PATH_TEMPLATES_PARTIALS="./templates/partials/"
TEMPLATES=["add_password_dialog"]

def partial(name, env=None, factor=12):
    render=web.template.render(PATH_TEMPLATES_PARTIALS)
    render._add_global(partial,'render')
    if 'item'==name:
        res=str(render.item(env=env,factor=factor))
        if factor==12: rm,back,div=4,0,6
        elif factor==10: rm,back,div=6,2,6
        else: rm,back,div=0,0,0
        res='\n'.join([div*' '+x for x in res.split('\n')[0:-1]])[rm:].replace((back*' ')+'</item>','</item>')
        return res
    return "</error func=partial>"

def render():
    for template in TEMPLATES:
        with open(MACRO_TEMPLATES%template) as f:
            code=web.template.render(PATH_TEMPLATES)
            code._add_global(partial,'render')
            with open(MACRO_CONFIG%template) as y:
                data=y.read()
                if isinstance(data, basestring):
                    env=yaml.safe_load(data)
                    with open(MACRO_BUILD%template,'w') as p:
                        res=str(getattr(code,template)(env))
                        p.write(res)

def main():
    render()

if __name__=="__main__":
    main()
