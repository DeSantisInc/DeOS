#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function
from __future__ import division


import configobj
import jsonschema
import os
import ruamel.yaml as yaml
import simplejson as json
import sys
import web


def _envtolist(s):
    if isinstance(s,basestring):
        a=s.split(' ')
        if isinstance(a,list):
            return a
    return None


VAULT_MACRO_BUILD=os.getenv('VAULT_MACRO_BUILD','build/%s.ui')
VAULT_MACRO_CONFIG=os.getenv('VAULT_MACRO_CONFIG','config/%s.yml')
VAULT_MACRO_TEMPLATES=os.getenv('VAULT_MACRO_TEMPLATES','templates/%s.xml')
VAULT_PATH_TEMPLATES=os.getenv('VAULT_PATH_TEMPLATES','./templates/')
VAULT_PATH_PARTIALS=os.getenv('VAULT_PATH_PARTIALS','./templates/partials/')
VAULT_TEMPLATES=_envtolist(os.getenv('VAULT_TEMPLATES',None))
VAULT_TODO=_envtolist(os.getenv('VAULT_TODO',None))


def partial(name,env=None,factor=0):
    render=web.template.render(VAULT_PATH_PARTIALS)
    render._add_global(partial,'render')
    rm,back,div,res=0,0,0,str(getattr(render,name)(env=env,factor=factor))
    if   'item'==name and 12==factor:rm,back,div=4,0,6
    elif 'item'==name and 10==factor:rm,back,div=6,2,6
    elif 'rect'==name:               rm,back,div=6,2,6
    if name in['resources','rect','item']:
        res='\n'.join([div*' '+x for x in res.split('\n')[0:-1]])[rm:]
    if 'item'==name:
        res=res.replace((back*' ')+'</item>','</item>')
    return res


def render():
    for template in VAULT_TEMPLATES:
        with open(VAULT_MACRO_TEMPLATES%template) as f:
            code=web.template.render(VAULT_PATH_TEMPLATES)
            code._add_global(partial,'render')
            with open(VAULT_MACRO_CONFIG%template) as y:
                data=y.read()
                if isinstance(data,basestring):
                    env=yaml.safe_load(data)
                    with open(VAULT_MACRO_BUILD%template,'w') as p:
                        res=str(getattr(code,template)(env))
                        p.write(res)


def main():
    if 'replace' in sys.argv:
        for fname in ['dialogs','TrezorPass']:
            with open(fname+'.py') as f:
                with open(fname+'.swap.py','w') as p:
                    p.write(f.read().replace('from ui_','from build.ui_'))
    elif 'render' in sys.argv:
        render()


if __name__=="__main__":
    main()
