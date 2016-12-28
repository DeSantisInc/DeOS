#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function

import configobj
import jsonschema
import web

import simplejson as json
import ruamel.yaml as yaml

TEMPLATES=['add_password_dialog']

def render_partial(filename, env=None):
    code,res=None,None
    #try:
    if isinstance(filename,basestring):
        with open('./templates/partials/'+filename+'.xml') as f:
            raw=str(f.read())
            #print(raw)
            code=web.template.Template(raw)
            if isinstance(code,web.template.Template):
                res=str(code(env))
            else:
                print('not instance!')
    #except:
    #    print('render_partial: filename:%s env=%s'%(filename,env))
    #finally:
    return res

def render():
    for template in TEMPLATES:
        with open('templates/'+template+'.xml') as f:
            raw=f.read()
            code=web.template.Template(raw)
            with open('config/'+template+'.yml') as y:
                data=y.read()
                if isinstance(data, basestring):
                    env=yaml.safe_load(data)
                    with open('build/'+template+'.ui','w') as p:
                        res=str(code(env))
                        p.write(res)

def main():
    render()
    code=render_partial('item',env={'type': 'widget',})
    print(code)

if __name__=="__main__":
    main()
